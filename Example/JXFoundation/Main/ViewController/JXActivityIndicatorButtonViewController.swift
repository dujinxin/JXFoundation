//
//  JXActivityIndicatorButtonViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 10/14/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class JXActivityIndicatorButtonViewController: JXBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        let titles = ["付费浏览","付费浏览","付费浏览"]
        for i in 0..<titles.count {
            
            let activityButton = JXActivityIndicatorButton.init(frame: CGRect(x: Int((kScreenWidth - 160.0) / 2.0), y: 200 + (i % titles.count) * (60 + 20) , width: 160, height: 60))
            activityButton.normalTitle = titles[i]
            
            activityButton.style = .white
            
            if i == 0 {
                activityButton.useActivityIndicatorView = false
            } else {
                
                activityButton.useActivityIndicatorView = true
                activityButton.selectedTitle = "付费中..."
                if i == 1 {
                    activityButton.position = .left
                } else {
                    activityButton.position = .top
                }
            }
            activityButton.backgroundColor = UIColor.systemPink
            self.view.addSubview(activityButton)
            
            activityButton.clickBlock = {[weak self] (_,_) in
            
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 1)) {
                    self?.showNotice("付费失败")
                }
            }
        }

        
    }
    
}
