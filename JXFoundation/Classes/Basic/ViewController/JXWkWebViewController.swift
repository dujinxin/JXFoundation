//
//  JXWkWebViewController.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/7/13.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit
import WebKit

open class JXWkWebViewController: JXScrollViewController {
    open override var scrollView: UIScrollView? {
        return self.webView.scrollView
    }
    public lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        //初始化偏好设置属性：preferences
        let preferences = WKPreferences()
        config.preferences = preferences
        //The minimum font size in points default is 0
        config.preferences.minimumFontSize = 10
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = true
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        //通过JS与webView内容交互
        let userContentController = WKUserContentController()
        config.userContentController = userContentController
        // 注入JS对象名称senderModel，当JS通过senderModel来调用时，我们可以在WKScriptMessageHandler代理中接收到
        let web = WKWebView(frame: CGRect(), configuration: config)
        web.backgroundColor = UIColor.clear
        web.uiDelegate = self
        web.navigationDelegate = self
        
        return web
    }()
    public lazy var processView: UIProgressView = {
        let process = UIProgressView()
        process.progressTintColor = UIColor.blue
        process.progress = 0.0
        return process
    }()
    override open func viewDidLoad() {
        super.viewDidLoad()
        if self.useCustomNavigationBar {
            if #available(iOS 11.0, *) {
                self.webView.scrollView.contentInsetAdjustmentBehavior = .never
            } else {
                self.automaticallyAdjustsScrollViewInsets = false
            }
        }
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.defaultView.frame = view.bounds
        self.customNavigationBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: self.navStatusHeight)
        let y = self.navStatusHeight
        self.webView.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: (view.bounds.height - y))
    }
    override open func setUpMainView() {
        let y = self.useCustomNavigationBar ? self.navStatusHeight : 0
        let height = self.useCustomNavigationBar ? (view.bounds.height - self.navStatusHeight) : view.bounds.height
        
        self.webView.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: height)
        view.addSubview(self.webView)
        
        self.processView.frame = CGRect(x: 0, y: y, width: UIScreen.main.screenWidth, height: 2)
        view.addSubview(self.processView)
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if
            let change = change,
            let processValue = change[NSKeyValueChangeKey.newKey],
            keyPath == "estimatedProgress",
            let process = processValue as? Float{
            
            //动画有延时，所以要等动画结束再隐藏
            self.processView.setProgress(process, animated: true)
            if process == 1.0 {
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.25, execute: {
                    self.processView.alpha = 0.0
                })
            }
        }
    }
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        print(self.classForCoder)
    }
}
extension JXWkWebViewController:WKUIDelegate{
    /*! @abstract Creates a new web view.
     @param webView The web view invoking the delegate method.
     @param configuration The configuration to use when creating the new web
     view.
     @param navigationAction The navigation action causing the new web view to
     be created.
     @param windowFeatures Window features requested by the webpage.
     @result A new web view or nil.
     @discussion The web view returned must be created with the specified configuration. WebKit will load the request in the returned web view.
     
     If you do not implement this method, the web view will cancel the navigation.
     */
    ///点击新打开一个网页（新打开的网页无法返回到原网页，不能goback）
    open func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    open func webViewDidClose(_ webView: WKWebView) {
        print("close")
    }
    ///只包含确定的提示框
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        print("alert")

        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            print("确定")
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    ///带有确认和取消的提示框，确定true,取消false
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("confirm")
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            print("确定")
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            print("取消")
            completionHandler(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    ///输入框，可以有多个输入框，但是最后回传时，要拼接成一个字符串
    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        print("textInput")
        let alert = UIAlertController(title: "提示", message: prompt, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = defaultText
        }
        alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            print("确定")
            completionHandler(alert.textFields?.first?.text)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    ///实现该方法，可以弹出自定义视图
    @available(iOS 10.0, *)
    open func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return true
    }
    ///实现该方法，可以弹出自定义视图控制器
    @available(iOS 10.0, *)
    open func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        return nil
    }
    ///实现该方法，关闭自定义视图控制器
    open func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
        
    }
}
extension JXWkWebViewController:WKNavigationDelegate{
    
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start")
    }
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("commit")
    }
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish")
    }
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("fail:\(error.localizedDescription)")
    }
    
    //当webView的web内容进程被终止时调用。(iOS 9.0之后)
    open func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
    //监听页面跳转的代理方法，分为：收到跳转与决定是否跳转两种
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    //收到服务器重定向时调用
    open func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    //当webView需要响应身份验证时调用(如需验证服务器证书)
    open func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, nil)
    }
    ////加载错误时调用
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
}
extension JXWkWebViewController :WKScriptMessageHandler{
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message:",message)
    }
}
/**
 1.原生调用H5方法

 [wkWebView evaluateJavaScript:@"js方法名" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
     if (!error) { // 成功
        NSLog(@"%@",response);
     } else { // 失败
         NSLog(@"%@",error.localizedDescription);
     }
 }];
 H5调用原生方法

 1> App端：
   // 1. WKWebView注入ScriptMessageHandler
  [wkWebView.configuration.userContentController addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:@"xxx"];
   // 2. 提供setWebViewAppearance方法，这样就能反射出H5即将传来的字符串@"setWebViewAppearance"
   - (void)setWebViewAppearance {
   
   }
   
 2> H5端：
   // 1. 获取handler
   var handler = {
     callHander: function (json) {
     if (iOS端) {
         window.webkit.messageHandlers.xxx.postMessage(JSON.stringify(json))
     }
     if (安卓端) {
         window.xxx.postMessage(JSON.stringify(json));
     }
   }
   // 2. 设置调用App方法所需要的传出的参数（这里是json格式）
   function setAppAppearance(){
     handler.callHander({
         'body':"setWebViewAppearance",
         'buttons': [
             {
                 "text":"分享",
                 "action":""
             }
         ],
         'title':"这是webView的标题"
     });
   }
   // 3. H5调用自己的设置方法,继而调用了原生客户端的方法
   setAppAppearance()
 */
