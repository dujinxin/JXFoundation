//
//  MyViewController.swift
//  JXFoundation_Example
//
//  Created by 杜进新 on 2018/12/24.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId = "cellId"

class MyViewController: JXTableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的"
        self.useLargeTitles = true
        print(self.navStatusHeight)
        self.tableView.frame = CGRect(x: 0, y: self.navStatusHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

        self.customNavigationBar.barTintColor = UIColor.blue
        if #available(iOS 13.0, *) {
            self.customNavigationBar.standardAppearance.backgroundColor = UIColor.yellow
            self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:  UIColor.rgbColor(rgbValue: 0x000000), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34)]
        } else {
            
            self.customNavigationBar.barTintColor = UIColor.yellow
        }
       
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        self.customNavigationBar.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8)
        
        
        
        self.beginRefreshing()
    }
    override var useCustomNavigationBar : Bool{
        return true
    }
    override var useRefreshControl : Bool {
        return true
    }
    override func refresh() {
        super.refresh()
        let _ = JXFoundationHelper.shared.countDown(timeOut: 1, process: { (a) in
            print(a)
        }) {
            self.dataArray = ["通用","个人中心","拖动排序","其他"]
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            //self.tableView.setContentOffset(CGPoint(x: 0, y: -self.navStatusHeight), animated: true)
        }
    }
}
extension MyViewController {
    override func tableView(_ tvareView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.dataArray[indexPath.row] as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let vc = JXSettingViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = JXUserViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = JXChannelViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = JXTestViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            print(indexPath.row)
        }
    }
}
extension MyViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset)
    }
}
