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

    //tableview
    public lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect())
        
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
        
        return table
    }()
    //refreshControl
    public var refreshControl : UIRefreshControl?
    //data array
    public var dataArray : Array<Any>!
    public var page : Int = 1
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isCustomNavigationBarUsed() {
            if #available(iOS 11.0, *) {
                self.tableView.contentInsetAdjustmentBehavior = .never
            } else {
                self.automaticallyAdjustsScrollViewInsets = false
            }
        }
    }
    
    @objc override open func setUpMainView() {
        setUpTableView()
    }
    
    open func setUpTableView(){
        let y = self.isCustomNavigationBarUsed() ? self.navStatusHeight : 0
        let height = self.isCustomNavigationBarUsed() ? (view.bounds.height - self.navStatusHeight) : view.bounds.height
        
        
        self.tableView.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: height)
        self.view.addSubview(self.tableView)
        
//        refreshControl = UIRefreshControl()
//        refreshControl?.addTarget(self, action: #selector(requestData), for: UIControlEvents.valueChanged)
//        self.tableView?.addSubview(refreshControl!)
    }
    /// request data
    ///
    /// - Parameter page: load data for page,
    open func request(page:Int) {}
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

