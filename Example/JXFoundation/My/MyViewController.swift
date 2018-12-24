//
//  MyViewController.swift
//  JXFoundation_Example
//
//  Created by 杜进新 on 2018/12/24.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class MyViewController: JXBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的"
        if #available(iOS 11.0, *) {
            self.customNavigationItem.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
        //self.customNavigationItem.
    }
}
