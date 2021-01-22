//
//  JXAlertViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 8/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class JXAlertViewController: JXBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
    }
    
    @IBAction func allAction(_ sender: Any) {
        let alert = JXAlertView.initWithTitle("温馨提示", content: "let activityButton = JXActivityIndicatorButton.init(frame: CGRect(x: 30, y: 320, width: 160, height: 60))", cancelTitle: "取消", confirmTitle: "确定")
        alert.contentLabel.textAlignment = .center
        let attribute = JXAttribute()
        attribute.contentMarginEdge = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        attribute.minimumInteritemSpacing = 16
        alert.attribute = attribute
        alert.confirmBlock = {
            self.showNotice("确定")
        }
        alert.cancelBlock = {
            self.showNotice("取消")
        }
        alert.show()
    }
    @IBAction func titleAction(_ sender: Any) {
        let alert = JXAlertView.initWithTitle("温馨提示", content: "", cancelTitle: "取消", confirmTitle: "确定")
        alert.contentLabel.textAlignment = .center
        let attribute = JXAttribute()
        attribute.contentMarginEdge = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        attribute.minimumInteritemSpacing = 16
        alert.attribute = attribute
        alert.confirmBlock = {
            self.showNotice("确定")
        }
        alert.cancelBlock = {
            self.showNotice("取消")
        }
        alert.show()
    }
    @IBAction func contentAction(_ sender: Any) {
        let alert = JXAlertView.initWithTitle("", content: "let activityButton = JXActivityIndicatorButton.init(frame: CGRect(x: 30, y: 320, width: 160, height: 60))", cancelTitle: "取消", confirmTitle: "付费")
        alert.contentLabel.textAlignment = .center
        let attribute = JXAttribute()
        attribute.contentMarginEdge = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        attribute.minimumInteritemSpacing = 16
        alert.attribute = attribute
        alert.confirmBlock = {
            self.showNotice("确定")
        }
        alert.cancelBlock = {
            self.showNotice("取消")
        }
        alert.show()
    }
    @IBAction func singleAction(_ sender: Any) {
        let alert = JXAlertView.initWithTitle("温馨提示", content: "let activityButton = JXActivityIndicatorButton.init(frame: CGRect(x: 30, y: 320, width: 160, height: 60))", cancelTitle: "", confirmTitle: "付费")
        alert.contentLabel.textAlignment = .center
        let attribute = JXAttribute()
        attribute.contentMarginEdge = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        attribute.minimumInteritemSpacing = 20
        alert.attribute = attribute
        alert.confirmBlock = {
            self.showNotice("确定")
        }
        
        alert.show()
    }
    @IBAction func loadingAction(_ sender: Any) {
        let alert = JXAlertView.initWithTitle("温馨提示", content: "let activityButton = JXActivityIndicatorButton.init(frame: CGRect(x: 30, y: 320, width: 160, height: 60))", cancelTitle: "取消", confirmTitle: "付费")
        alert.contentLabel.textAlignment = .center
        
        alert.confirmButton.normalTitle = "付费"
        alert.confirmButton.selectedTitle = "付费中..."
        alert.confirmButton.position = .left
        alert.confirmButton.style = .white
        alert.confirmButton.useActivityIndicatorView = true
        
        let attribute = JXAttribute()
        attribute.contentMarginEdge = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        attribute.minimumInteritemSpacing = 20
        alert.attribute = attribute
        alert.nextBlock = {
            self.showNotice("请求中...")
            //结束后，自己调用关闭方法 alert.dismiss()
        }
        alert.cancelBlock = {
            self.showNotice("取消")
        }
        alert.show()
        
        
    }
    @IBAction func contentMarginEdgeAction(_ sender: Any) {
        let alert = JXAlertView.initWithTitle("温馨提示", content: "let activityButton = JXActivityIndicatorButton.init(frame: CGRect(x: 30, y: 320, width: 160, height: 60))", cancelTitle: "取消", confirmTitle: "确定")
        alert.contentLabel.textAlignment = .center
        let attribute = JXAttribute()
        attribute.contentMarginEdge = UIEdgeInsets.init(top: 30, left: 40, bottom: 50, right: 60)
        attribute.minimumInteritemSpacing = 16
        alert.attribute = attribute
        alert.confirmBlock = {
            self.showNotice("确定")
        }
        alert.cancelBlock = {
            self.showNotice("取消")
        }
        alert.show()
    }
    @IBAction func title1Action(_ sender: Any) {
    }
    @IBAction func title2Action(_ sender: Any) {
    }
    @IBAction func title3Action(_ sender: Any) {
    }
    
    
}
