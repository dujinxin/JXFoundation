//
//  JXBaseViewController.swift
//  ShoppingGo-Swift
//
//  Created by 杜进新 on 2017/6/6.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

open class JXBaseViewController: UIViewController {
    
    open var backBlock : (()->())?
    
    //MARK: - custom NavigationBar
    //自定义导航栏
    public lazy var customNavigationBar : JXNavigationBar = {
        let navigationBar = JXNavigationBar(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kNavStatusHeight))
        navigationBar.barTintColor = UIColor.clear//导航条颜色,透明色不起作用
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .default
        navigationBar.tintColor = UIColor.rgbColor(rgbValue: 0x000000) //item图片文字颜色
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.rgbColor(rgbValue: 0x000000),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)]//标题设置
        navigationBar.setBackgroundImage(navigationBar.imageWithColor(UIColor.clear), for: UIBarMetrics.default)
        //大标题
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = false
            //navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.rgbColor(rgbValue: 0x000000),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)]
        }
        
        return navigationBar
    }()
    public lazy var customNavigationItem: UINavigationItem = {
        let item = UINavigationItem(title: "")
        if #available(iOS 11.0, *) {
            item.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
        return item
    }()
    //子类重写title的setter方法
    override open var title: String?{
        didSet {
            customNavigationItem.title = title
        }
    }
    
    //MARK: - default view info
    
    /// default view
    public lazy var defaultView: JXDefaultView = {
        let v = JXDefaultView()
        v.backgroundColor = UIColor.randomColor
        return v
    }()
    
    public var defaultInfo : [String: String]?
    
    //log state
    public var isLogin: Bool = true
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.isCustomNavigationBarUsed() ? setupCustomNavigationBar() : setupNavigationBarConfig()
    }
    override open func loadView() {
        super.loadView()
        
        isLogin ? setUpMainView() : setUpDefaultView()
    }
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override open var preferredStatusBarStyle: UIStatusBarStyle {
         return .default
    }
    open func isCustomNavigationBarUsed() -> Bool{
        return true
    }
    /// request data
    @objc open func requestData() {}
    //MARK: - base view set
    open func setUpMainView() {}
    /// add default view eg:no data,no network,no login
    open func setUpDefaultView() {
        defaultView.frame = view.bounds
        view.addSubview(defaultView)
        defaultView.info = defaultInfo
        defaultView.tapBlock = {()->() in
            self.requestData()
        }
    }
}

extension JXBaseViewController {
    /// 设置自定义导航栏
    open func setupCustomNavigationBar() {
        //隐藏navigationBar
        self.navigationController?.navigationBar.isHidden = true
        //1.自定义view代替NavigationBar,需要自己实现手势返回;
        //2.自定义navigatioBar代替系统的，手势返回不用自己实现
        self.view.addSubview(self.customNavigationBar)
        self.customNavigationBar.items = [self.customNavigationItem]
    }
    /// 设置系统导航栏，子类可重新设置
    open func setupNavigationBarConfig() {
        let image = UIImage(named: "icon-back")
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftItemsSupplementBackButton = false;
        let backBarButtonItem = UIBarButtonItem.init(title:"", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkText //item图片文字颜色
//        self.navigationController?.navigationBar.barTintColor = UIColor.rgbColor(rgbValue: 0x046ac9)//导航条颜色
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 19)]//标题设置
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
    }
}

extension JXBaseViewController {
    
}

