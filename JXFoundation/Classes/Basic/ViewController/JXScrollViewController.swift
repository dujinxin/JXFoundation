//
//  JXScrollViewController.swift
//  FBSnapshotTestCase
//
//  Created by Admin on 12/18/20.
//

import UIKit

open class JXScrollViewController: JXBaseViewController{

    open override var useLargeTitles: Bool {
        didSet{
            if useLargeTitles == true {
                self.navStatusHeight = kNavStatusHeight + kNavLargeTitleHeight
            } else {
                self.navStatusHeight = kNavStatusHeight
            }
            
            if #available(iOS 11.0, *) {
                if self.useCustomNavigationBar {
                    self.customNavigationBar.prefersLargeTitles = useLargeTitles
                } else {
                    self.navigationController?.navigationBar.prefersLargeTitles = useLargeTitles
                }
            } else {
                // Fallback on earlier versions
            }
            self.customNavigationBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: self.navStatusHeight)
            self.scrollView?.frame = CGRect(x: 0, y: self.navStatusHeight, width: view.bounds.width, height: (view.bounds.height - self.navStatusHeight))
        }
    }
    
    //MARK: - 子类重写
    open var useRefreshControl : Bool {
        return false
    }
    //scrollView
    open var scrollView: UIScrollView? {
        return nil
    }
    //MARK: -
    
    //refreshControl
    public lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString.init(string: "下拉刷新", attributes: [:])
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    /// scrollView代理block
    open var scrollViewDidScrollBlock : ((_ scrollView: UIScrollView)->())?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.defaultView.frame = view.bounds
        self.customNavigationBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: self.navStatusHeight)
        let y = self.navStatusHeight
        self.scrollView?.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: (view.bounds.height - y))
    }
    /// 添加观察者，不起作用，我很费解呀
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath,keyPath == "isRefreshing",let change = change,let newText = change[.newKey] as? Bool else { return }
        print(newText)
        if newText {
            self.refreshControl.attributedTitle = NSAttributedString.init(string: "刷新中•••", attributes: [:])
        } else {
            self.refreshControl.attributedTitle = NSAttributedString.init(string: "下拉刷新", attributes: [:])
        }
    }
    @objc override open func setUpMainView() {
        setUpScrollView()
    }
    
    open func setUpScrollView(){
        if let scrollView = self.scrollView {
            self.view.addSubview(scrollView)
        }
    }
    /// request data
    ///
    /// - Parameter page: load data for page,
    open func request(page:Int) {}

    /// refresh
    open func beginRefreshing() {
        if #available(iOS 10.0, *) {
            guard let scrollView = self.scrollView, let refreshControl = scrollView.refreshControl else {
                return
            }
            let offset = CGPoint(x: 0, y: scrollView.contentOffset.y - refreshControl.bounds.height)
            scrollView.setContentOffset(offset, animated: false)
            refreshControl.beginRefreshing()
            refreshControl.sendActions(for: UIControl.Event.valueChanged)
        } else {
            // Fallback on earlier versions
        }
        
    }
    /// refresh
    ///
    /// - Parameter page: load data for page,
    @objc open func refresh(){
        //self.refreshControl.attributedTitle = NSAttributedString.init(string: "刷新中•••", attributes: [:])
    }
}

extension JXScrollViewController : UIScrollViewDelegate {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let block = scrollViewDidScrollBlock {
            block(scrollView)
        }
    }
}
