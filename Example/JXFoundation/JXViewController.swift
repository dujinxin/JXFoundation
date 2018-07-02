//
//  JXViewController.swift
//  JXView
//
//  Created by 杜进新 on 2017/8/23.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class JXViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
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
            case 6:
                self.showInputView()
            default:
                break
            }
        default:
            break
        }
    }
    
    func showInputView() {
        let inputTextView = JXInputTextView(frame: CGRect(x: 0, y: self.tableView.frame.height, width: view.bounds.width, height: 60), style: .hidden, completion:nil)
        inputTextView.sendBlock = { (_,object) in
            let notice = JXNoticeView(text: "发表成功")
            notice.show()
        }
        inputTextView.limitWords = 1000
        inputTextView.placeHolder = "写下你的评论吧~~🌹🌹🌹"
        inputTextView.show()
    }
}
