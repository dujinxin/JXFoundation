//
//  JXBaseViewController.swift
//  ShoppingGo-Swift
//
//  Created by 杜进新 on 2017/6/6.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit
import Reachability

public enum JXNetworkStatus: Int {
    case unavailable
    case wifi
    case cellular
}


open class JXBaseViewController: UIViewController {
    
    open var backBlock : (()->())?
    public var networkStatus : JXNetworkStatus = .unavailable
    //MARK: - custom NavigationBar
    //自定义导航栏
    public lazy var customNavigationBar : JXNavigationBar = {
        let navigationBar = JXNavigationBar(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kNavStatusHeight))
        navigationBar.useCustomBackgroundView = true
        //navigationBar.isTranslucent = true
        navigationBar.barStyle = .default
        navigationBar.tintColor = (self.preferredStatusBarStyle == .default) ? UIColor.darkText : UIColor.white //item图片文字颜色
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: (self.preferredStatusBarStyle == .default) ? UIColor.darkText : UIColor.white,
            NSAttributedString.Key.font:UIFont(name: "PingFangSC-Semibold", size: 17) as Any]//标题设置
        
        //navigationBar.barTintColor = UIColor.clear//导航条颜色,透明色不起作用,可以用下面的方法来设置
        //navigationBar.setBackgroundImage(navigationBar.imageWithColor(UIColor.clear), for: UIBarMetrics.default)
        //大标题
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = false
            navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: (self.preferredStatusBarStyle == .default) ? UIColor.darkText : UIColor.white,
            NSAttributedString.Key.font:UIFont(name: "PingFangSC-Semibold", size: 34) as Any]
        }
        
        return navigationBar
    }()
    public lazy var customNavigationItem: UINavigationItem = {
        let item = UINavigationItem(title: "")
        //item.standardAppearance
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
            if self.useCustomNavigationBar {
                self.customNavigationItem.title = title
            } else {
                self.navigationItem.title = title
            }
        }
    }
    //子类重写返回按钮 backItem里， 事件默认为pop，可以自定义
    open var backItem: UIBarButtonItem {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 10, y: 7, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "icon_back_light")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.tintColor = (self.preferredStatusBarStyle == .default) ? UIColor.darkText : UIColor.white
        //leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24)
        //leftButton.setTitle("up", for: .normal)
        leftButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        let item = UIBarButtonItem(customView: leftButton)
        return item
    }
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - navStatusHeight
    private var _navStatusHeight: CGFloat = kNavStatusHeight
    open var navStatusHeight: CGFloat {
        set{
            _navStatusHeight = newValue
        }
        get{
            return _navStatusHeight
        }
    }
    //子类重写setter方法
    open var useLargeTitles: Bool = false {
        didSet {
            if useLargeTitles == true {
                self.navStatusHeight = kNavStatusHeight + kNavLargeTitleHeight
            } else {
                self.navStatusHeight = kNavStatusHeight
            }
            self.customNavigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.navStatusHeight)
            if #available(iOS 11.0, *) {
                if self.useCustomNavigationBar {
                    
                    self.customNavigationBar.prefersLargeTitles = useLargeTitles
                } else {
                    self.navigationController?.navigationBar.prefersLargeTitles = useLargeTitles
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    //MARK: - Reachability
    let reachablity = try? Reachability.init()
    
    //MARK: - default view info
    
    /// default view
    public lazy var defaultView: JXDefaultView = {
        let v = JXDefaultView()
        v.backgroundColor = UIColor.randomColor
        return v
    }()
    
    public var defaultInfo : [String: String]?
    
    //prefersDefaultView show or not
    public var prefersDefaultView: Bool = false
    
    //MARK: - viewController life circle
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.useCustomNavigationBar ? setupCustomNavigationBar() : setupNavigationBarConfig()
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkReachablity(notify:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        do {
            try reachablity?.startNotifier()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reachablity?.stopNotifier()
    }
    override open func loadView() {
        super.loadView()
        prefersDefaultView ? setUpDefaultView() : setUpMainView()
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.defaultView.frame = view.bounds
    }
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print(self.classForCoder)
    }
    //MARK: - 子类重写
    override open var preferredStatusBarStyle: UIStatusBarStyle {
         return .default
    }
    open var useCustomNavigationBar : Bool{
        return true
    }
    /// request data
    @objc open func networkReachablity(notify: NSNotification) {
        
        guard let reach = notify.object as? Reachability else { return }
        switch reach.connection {
        case .unavailable:
            self.networkStatus = .unavailable
        case .wifi:
            self.networkStatus = .wifi
        case .cellular:
            self.networkStatus = .cellular
        default:
            self.networkStatus = .unavailable
        }
        
        self.resetView(status: self.networkStatus)
        
        
    }
    open func resetView(status: JXNetworkStatus) {
        if status == .unavailable {
            //展示无网络的视图
        } else {
            //正常展示内容
            if status == .wifi {
                //正常展示内容，没有限制
            } else {
                //正常展示内容，运营商网络，要限制耗流量的操作，提示用户
            }
        }
    }
    /// request data
    @objc open func requestData() {}
    
    open func setUpMainView() {}
    /// add default view eg: no data,no network,no login
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
        self.navigationController?.navigationBar.isHidden = false
        
        let image = UIImage(named: "icon-back")
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.barTintColor = UIColor.orange//UIColor.clear 导航条颜色,透明色不起作用
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationController?.navigationBar.tintColor = UIColor.rgbColor(rgbValue: 0x000000) //item图片文字颜色
        self.navigationItem.leftItemsSupplementBackButton = false;
        let backBarButtonItem = UIBarButtonItem.init(title:"", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.rgbColor(rgbValue: 0x000000) ,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)]//标题设置
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.rgbColor(rgbValue: 0x000000) ,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 34)]//大标题设置
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
    }
}

extension JXBaseViewController {
    
}

