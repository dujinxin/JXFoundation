//
//  MainTableViewController.swift
//  JXView
//
//  Created by 杜进新 on 2017/8/23.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = JXDebugColor
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
                let notice = JXNoticeView(text: "温馨提示！")
                notice.show()
            case 1:
                self.navigationController?.pushViewController(FeedbackViewController(), animated: true)
            case 2:
                let vc = ViewController()
                vc.type = .ad
                self.navigationController?.present(vc, animated: true, completion: nil)
            case 3:
                let vc = ViewController()
                vc.type = .guide
                self.navigationController?.present(vc, animated: true, completion: nil)
            case 4:
                self.navigationController?.pushViewController(OrderManagerViewController(), animated: true)
            case 5:
                self.navigationController?.pushViewController(FeedbackViewController(), animated: true)
            default:
                break
            }
        default:
            break
        }
    }
}
