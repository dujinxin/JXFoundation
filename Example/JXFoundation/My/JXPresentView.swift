//
//  JXPresentView.swift
//  JXFoundation_Example
//
//  Created by Admin on 11/14/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

open class JXPresentView: JXView {

    lazy private var bgWindow : UIWindow = {
        let window = UIWindow()
        window.frame = UIScreen.main.bounds
        window.windowLevel = UIWindow.Level.alert + 1
        window.backgroundColor = UIColor.clear
        window.isHidden = false
        return window
    }()
    
    lazy private var bgControl : UIControl = {
        let control = UIControl()
        control.frame = UIScreen.main.bounds
        control.backgroundColor = UIColor.black
        control.alpha = 0
        
        control.addTarget(self, action: #selector(tapClick), for: .touchUpInside)
        return control
    }()

    //MARK:子类重写
    @objc func tapClick() {
        
    }
}
