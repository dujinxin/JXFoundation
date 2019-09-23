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

        print(self.tableView.subviews)
        self.tableView.subviews.forEach { (v) in
            if v is UIRefreshControl {
                v.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 60)
            }
        }
        
       self.customNavigationBar.barTintColor = UIColor.yellow
        //self.customNavigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.red), for: UIBarMetrics.default)
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }

    override func refresh() {
        JXFoundationHelper.shared.countDown(timeOut: 3, process: { (a) in
            print(a)
        }) {
            self.refreshControl?.endRefreshing()
            //self.tableView.setContentOffset(CGPoint(x: 0, y: -self.navStatusHeight), animated: true)
        }
    }
}
extension MyViewController {
    override func tableView(_ tvareView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension MyViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
}
