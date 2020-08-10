//
//  JXSettingViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 5/2/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId = "cellId"

class JXSettingViewController: JXTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置"
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        self.tableView.frame = CGRect(x: 0, y: self.navStatusHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        self.dataArray = ["device","隐私","数据存储"]
    }
    
    
    override var useCustomNavigationBar : Bool{
        return true
    }
    
    override func refresh() {
        let _ = JXFoundationHelper.shared.countDown(timeOut: 2, process: { (a) in
            print(a)
        }) {
            self.refreshControl.endRefreshing()
            //self.tableView.setContentOffset(CGPoint(x: 0, y: -self.navStatusHeight), animated: true)
        }
    }
    override func resetView(status: JXNetworkStatus) {
        if status == .unavailable {
            
        } else {
            
            if status == .wifi {
                
            } else {
                
            }
        }
    }
}
extension JXSettingViewController {
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
            self.navigationController?.pushViewController(JXDeviceViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(JXPrivateViewController(), animated: true)
        case 2:
            self.navigationController?.pushViewController(JXDataViewController(), animated: true)
        default:
            print(indexPath.row)
        }
    }
}
extension JXSettingViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
}
