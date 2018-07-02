//
//  UIKitViewController.swift
//  JXFoundation_Example
//
//  Created by 杜进新 on 2018/7/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class UIKitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.rgbColor(from: 10, 200, 50)
        
        let v = UIView()
        v.frame = CGRect(x: 100, y: 100, width: view.jxWidth / 2, height: view.jxHeight / 3)
        v.backgroundColor = UIColor.jxeeeeeeColor
        self.view.addSubview(v)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "测试", fontSize: 15, target: self, action: #selector(test))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func test() {
        print(UIScreen.main.modelSize)
        print(UIViewController.topStackViewController ?? "")
    }

}
