//
//  JXTestViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 5/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation


class JXTestViewController: JXBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        self.title = "分类"
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        
        
        let scr = JXScrollCycleView.init(frame: CGRect(x: 0, y: kNavStatusHeight + 60, width: view.bounds.width, height: 100), titles: ["mainScrollView.addGestureRecognizer(gesture1)","分类分类分类分类分类分类分类分类分类","//创建上下文，并让两个scrollView都持有"], attribute: JXAttribute()) { (v, a) in
            print(v,a)
        }
        view.addSubview(scr)
        scr.beginScroll()
        
        let moreButton = UIButton()
        moreButton.setTitle("查看全文", for: .normal)
        moreButton.setTitleColor(UIColor.red, for: .normal)
       
        moreButton.contentVerticalAlignment = .bottom;
        moreButton.tag = 996;
        self.view.addSubview(moreButton);
        
        moreButton.frame = CGRect(x: 0, y: 300 - 60, width: 375, height: 60)
        
        let layer = CAGradientLayer.init()
        layer.colors = [UIColor.black.cgColor, UIColor.rgbColor(rgbValue: 0x000000, alpha: 0).cgColor];
        layer.startPoint = CGPoint(x: 0, y: 0);
        layer.endPoint = CGPoint(x: 0, y: 1.0);
        layer.frame = moreButton.bounds;
        
        moreButton.layer.insertSublayer(layer, at: 0)
        //self.view.layer.addSublayer(layer)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


