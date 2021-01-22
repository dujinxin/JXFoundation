//
//  JXTableViewController.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/7.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

let reuseIdentifierNormal = "reuseIdentifierNormal"

open class JXTableViewController: JXScrollViewController{
    
    //MARK: - 子类重写
    open var style : UITableView.Style {
        return .plain
    }
    open override var useRefreshControl : Bool {
        return false
    }
    open override var scrollView: UIScrollView? {
        return self.tableView
    }
    //MARK: -
    //tableview
    public lazy var tableView : JXTableView = {
        
        let y = self.navStatusHeight
        let height = view.bounds.height - self.navStatusHeight
        
        let table = JXTableView.init(frame: CGRect(x: 0, y: y, width: view.bounds.width, height: height), style: style)
        
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
        
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
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
    //data array
    public var dataArray : Array<Any> = []
    public var page : Int = 1
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.defaultView.frame = view.bounds
        self.customNavigationBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: self.navStatusHeight)
        let y = self.navStatusHeight
        self.tableView.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: (view.bounds.height - y))
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
