//
//  JXNavigationController.swift
//  ShoppingGo-Swift
//
//  Created by 杜进新 on 2017/6/6.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

open class JXNavigationController: UINavigationController {
    
    open var backItem: UIBarButtonItem = {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 10, y: 7, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "icon_back_dark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.tintColor = UIColor.darkText
        //leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24)
        //leftButton.setTitle("up", for: .normal)
        leftButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        let item = UIBarButtonItem(customView: leftButton)
        return item
    }()

    override open func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationBar.isTranslucent = true
//        self.navigationBar.barStyle = .blackTranslucent //状态栏 白色
//        //self.navigationBar.barStyle = .default      //状态栏 黑色
//        self.navigationBar.barTintColor = UIColor.white//导航条颜色
//        self.navigationBar.tintColor = UIColor.darkText   //item图片文字颜色
//        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkText,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)]//标题设置
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// 重写push方法
    ///
    /// - Parameters:
    ///   - viewController: 将要push的viewController
    ///   - animated: 是否使用动画
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        
        guard viewControllers.count > 0 else { return }
        
        var titleName = ""//"返回"
        if viewControllers.count == 1 {
            titleName = viewControllers.first?.title ?? titleName
        }
        
        if viewController.isKind(of: JXBaseViewController.self) {
            let vc = viewController as! JXBaseViewController
            vc.hidesBottomBarWhenPushed = true
            vc.customNavigationItem.leftBarButtonItem = vc.backItem
        } else {
            viewController.navigationItem.leftBarButtonItem = self.backItem
        }
    }
    
    /// 自定义导航栏的返回按钮事件
    @objc func pop() {
        popViewController(animated: true)
    }
    
    //重写这两个方法，解决单个控制器设置状态栏隐藏或文字无效的问题
    override open var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    override open var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    //或者这两个...
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return self.visibleViewController!.preferredStatusBarStyle
    }
    override open var prefersStatusBarHidden: Bool {
        return self.visibleViewController!.prefersStatusBarHidden
    }
    
    
}

public extension JXNavigationController {
    
}
