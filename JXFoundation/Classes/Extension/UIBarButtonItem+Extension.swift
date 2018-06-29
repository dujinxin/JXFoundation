//
//  UIBarButtonItem+Extension.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/6.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

extension  UIBarButtonItem {
    
    /// custom UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title:
    ///   - fontSize: default 17
    ///   - imageName:
    ///   - target:
    ///   - action:
    convenience init(title:String = "",fontSize:CGFloat = 17, imageName:String = "",target:Any,action:Selector) {
        
        let btn = UIButton()
        var width : CGFloat = 30
        
        if title.isEmpty == false {
            let size = title.calculate(width: kScreenWidth, fontSize: fontSize)
            if size.width > 30 {
                width = size.width
            }
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitleColor(UIColor.lightText, for: .highlighted)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
        if imageName.isEmpty == false{
            
            let image = UIImage(named: imageName)
            width += (image?.size.width ?? 0)
            
            btn.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
            btn.tintColor = UIColor.white
           
            //btn.setImage(image?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        }
        width = width > 30 ? width : 30
        btn.frame = CGRect(x: 0, y: 0, width: width, height: 30)

        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)

        self.init(customView: btn)
    }

}
