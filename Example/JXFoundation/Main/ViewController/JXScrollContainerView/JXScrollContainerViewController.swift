//
//  JXHorizontalViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 8/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class JXScrollContainerViewController: JXBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    @IBAction func horizontalAction(_ sender: Any) {
        let vc = JXHorizontalViewController()
        vc.title = "JXScrollContainerView-horizontal"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func verticallyAction(_ sender: Any) {
        
        let vc = JXVerticallyViewController()
        vc.title = "JXScrollContainerView-vertically"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func customAction(_ sender: Any) {
        let vc = HomeViewController()
        vc.title = "JXScrollContainerView-custom"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
