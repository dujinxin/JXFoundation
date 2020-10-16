//
//  JXAutoScrollViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 10/14/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class JXAutoScrollViewController: JXBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
       
        for i in 0..<3 {
            let titles =  ["mainScrollView.addGestureRecognizer(gesture1)","分类分类😊分类分类分类分类分类分类分类","//创建上下文，并让两个scrollView都持有"]
            
            if i == 0 {
                var newTitles = [Any]()
                for j in 0..<titles.count {
                    let str = titles[j]
                    let attributeString = NSMutableAttributedString(string: str as String, attributes: [NSAttributedString.Key.foregroundColor: UIColor.rgbColor(rgbValue: 0xa5a5da)])
                    attributeString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.rgbColor(rgbValue: 0xe4ba9a), NSAttributedString.Key.underlineStyle: 1], range: NSMakeRange(8, 5))
                    newTitles.append(attributeString)
                }
                
                let scr = JXAutoScrollView.init(frame: CGRect(x: 0, y: 200 + (i % 3) * (40 + 20), width: Int(view.bounds.width), height: 40), titles: newTitles, attribute: JXAttribute()) { (v, a) in
                    print(v,a)
                }
                scr.backgroundColor = UIColor.rgbColor(rgbValue: 0x1f1932)
                view.addSubview(scr)
                scr.beginScroll()
                
            } else {
                
                if i == 1 {
                    
                } else {
                    
                }
                
                let scr = JXAutoScrollView.init(frame: CGRect(x: 0, y: 200 + (i % 3) * (40 + 20), width: Int(view.bounds.width), height: 40), titles: ["mainScrollView.addGestureRecognizer(gesture1)","分类分类分类分类分类分类分类分类分类","//创建上下文，并让两个scrollView都持有"], attribute: JXAttribute()) { (v, a) in
                    print(v,a)
                }
                scr.backgroundColor = UIColor.systemPink
                view.addSubview(scr)
                scr.beginScroll()
            }
        }

        
    }
    
}
