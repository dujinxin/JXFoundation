//
//  SubViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 5/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class SubViewController: UIViewController {
    
    override var title: String?{
        didSet{
            let moreButton = UIButton()
            moreButton.setTitle(title, for: .normal)
             moreButton.setTitleColor(UIColor.red, for: .normal)
            moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
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
        }
    }

    override func loadView() {
        super.loadView()
        print(#function,self.title ?? "")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        print(#function,self.title ?? "")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function,self.title ?? "")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function,self.title ?? "")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function,self.title ?? "")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function,self.title ?? "")
    }
}
