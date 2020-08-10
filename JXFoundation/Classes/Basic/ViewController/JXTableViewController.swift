//
//  JXTableViewController.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/7.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

let reuseIdentifierNormal = "reuseIdentifierNormal"

open class JXTableViewController: JXBaseViewController{

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
            self.customNavigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.navStatusHeight)
            self.tableView.frame = CGRect(x: 0, y: self.navStatusHeight, width: view.bounds.width, height: (view.bounds.height - self.navStatusHeight))
        }
    }
    
    //MARK: - 子类重写
    open var style : UITableView.Style {
        return .plain
    }
    open var useRefreshControl : Bool {
        return false
    }
    //MARK: -
    //tableview
    public lazy var tableView : UITableView = {
        
        let y = self.useCustomNavigationBar ? self.navStatusHeight : 0
        let height = self.useCustomNavigationBar ? (view.bounds.height - self.navStatusHeight) : view.bounds.height
        
        let table = UITableView.init(frame: CGRect(x: 0, y: y, width: view.bounds.width, height: height), style: style)
        
        table.backgroundColor = UIColor.clear
        table.separatorStyle = .singleLine
        //table.separatorColor = JXSeparatorColor
        table.delegate = self
        table.dataSource = self
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        table.estimatedRowHeight = 44
        table.rowHeight = UITableView.automaticDimension
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.sectionFooterHeight = UITableView.automaticDimension
        
        if self.useCustomNavigationBar {
            if #available(iOS 11.0, *) {
                table.contentInsetAdjustmentBehavior = .never
            } else {
                self.automaticallyAdjustsScrollViewInsets = false
            }
        }
        if self.useRefreshControl {
            if #available(iOS 10.0, *) {
                table.refreshControl = self.refreshControl
            } else {
                // Fallback on earlier versions
            }
        }
        
        return table
    }()
    //refreshControl
    public lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString.init(string: "下拉刷新", attributes: [:])
        
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
       
        return refreshControl
    }()
    //data array
    public var dataArray : Array<Any> = []
    public var page : Int = 1
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    deinit {
        
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
        setUpTableView()
    }
    
    open func setUpTableView(){
        
        self.view.addSubview(self.tableView)
   
    }
    /// request data
    ///
    /// - Parameter page: load data for page,
    open func request(page:Int) {}

    /// refresh
    open func beginRefreshing() {
        if #available(iOS 10.0, *) {
            guard let refreshControl = self.tableView.refreshControl else {
                return
            }
            let offset = CGPoint(x: 0, y: self.tableView.contentOffset.y - refreshControl.bounds.height)
            self.tableView.setContentOffset(offset, animated: false)
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
extension JXTableViewController : UITableViewDelegate,UITableViewDataSource{

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

