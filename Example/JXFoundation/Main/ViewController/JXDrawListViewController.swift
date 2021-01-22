//
//  JXDrawListViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 11/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class JXDrawListViewController: JXBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
       
        for i in 0..<5 {
            let att = JXAttribute()
            att.selectedImage = "home_item_recharge"
            att.normalImage = "home_item_recharge"
            
            att.normalColor = UIColor.rgbColor(rgbValue: 0x999999)
            att.normalFontSize = 18
            att.selectedColor = UIColor.red
            att.backgroundColor = UIColor.blue
            att.normalBackgroundColor = UIColor.yellow
            att.selectedBackgroundColor = UIColor.red
            att.cornerRadius = 25
            att.selectedFontSize =  24
            att.sectionEdgeInsets = UIEdgeInsets.init(top: 5, left: 15, bottom: -5, right: -15)
            //att.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: -8, bottom: 0, right: 8)
            att.contentMarginEdge = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
            
            att.minimumInteritemSpacing = 0
            
            var direction: JXDrawerViewUnfoldDirection = .left
            var type: JXDrawerViewContentType = .image
            var titles = ["home_item_recharge","home_item_recharge","home_item_wthdraw","home_item_exchange","home_item_promote"]
            
            switch i {
            case 0:
                direction = .right
                type = .image
            case 1:
                direction = .right
                type = .title
                titles = ["😭","推荐","视频","热点","体育"]
            case 2:
                direction = .bottom
                type = .image
            case 3:
                direction = .left
                type = .image
            case 4:
                direction = .top
                type = .image
                
            default:
                ()
            }
            //["home_item_recharge","home_item_wthdraw","home_item_exchange","home_item_promote"]
            //["😭","推荐","视频","热点","体育"]
            var topBar: JXDrawerView!
            if i == 3 {
                topBar = JXDrawerView.init(frame: CGRect.init(x: 36 + (60 * i), y: 100 + (60 * i) , width: 50, height: 50), delegate: self, titles: titles, contentType: type, attribute: att)
            } else {
                topBar = JXDrawerView.init(frame: CGRect.init(x: 36 + (60 * i), y: 100 + (60 * i) , width: 50, height: 50), titles: titles, contentType: type, attribute: att, clickBlock: { (v, index) in
                    print(v,index)
                })
            }
            topBar.unfoldDirection = direction
            topBar.layer.cornerRadius = 25
            topBar.layer.masksToBounds = true
            
            if i == 4 {
                topBar.unfoldBlock = { (v, obj) in
                    print(v,obj)
                }
            }
            self.view.addSubview(topBar)
        }

        
    }
    
}
extension JXDrawListViewController: JXDrawerViewDelegate {
    func jxDrawerView(drawerView: JXDrawerView, didSelectItemAt index: Int) {
        print(index)
    }
}
