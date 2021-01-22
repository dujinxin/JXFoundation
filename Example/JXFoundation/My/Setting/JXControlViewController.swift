//
//  JXControlViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 11/4/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId = "cellId"

class JXControlViewController: JXTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "控制中心"
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        self.dataArray = ["屏幕旋转","声音","亮度","震动"]
    }
    override var useCustomNavigationBar : Bool{
        return true
    }
}
extension JXControlViewController {
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
            self.navigationController?.pushViewController(JXRotationViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(JXPrivateViewController(), animated: true)
        case 2:
            self.navigationController?.pushViewController(JXDataViewController(), animated: true)
        case 3:
            self.navigationController?.pushViewController(JXLocalNotificationController(), animated: true)
        default:
            print(indexPath.row)
        }
    }
}
