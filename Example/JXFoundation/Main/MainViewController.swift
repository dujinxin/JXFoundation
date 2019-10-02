//
//  MainViewController.swift
//  JXFoundation_Example
//
//  Created by 杜进新 on 2018/7/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class MainViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        self.title = "首页"
        
        if #available(iOS 13.0, *) {
//            self.navigationController?.navigationBar.standardAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:  UIColor.rgbColor(rgbValue: 0x000000), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34)]
            self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.yellow
        } else {
//            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:  UIColor.rgbColor(rgbValue: 0x000000), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34)]
            self.navigationController?.navigationBar.barTintColor = UIColor.red
        }
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl!)
        
        print(self.navigationItem)
        print(self.navigationController?.navigationBar.items)
        
    }
    @objc func refresh() {
        let _ = JXFoundationHelper.shared.countDown(timeOut: 3, process: { (a) in
            print(a)
        }) {
            self.refreshControl?.endRefreshing()
            //self.tableView.setContentOffset(CGPoint(x: 0, y: -0), animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "JXView", sender: nil)
            case 1:
                self.performSegue(withIdentifier: "UIKitExtension", sender: nil)
            case 2:
                self.performSegue(withIdentifier: "JXView", sender: nil)
            default:
                break
            }
        default:
            break
        }
    }

}
