//
//  MainViewController.swift
//  JXFoundation_Example
//
//  Created by 杜进新 on 2018/7/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        self.title = "首页"
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
