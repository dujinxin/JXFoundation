//
//  JXInputViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 6/28/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class JXInputViewController: JXBaseViewController {
    
   
    @IBOutlet weak var inputButton: UIButton!
    @IBOutlet weak var inputBgView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
      
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        
        
        //位于底部
        let inputTextView = JXInputTextView(frame: CGRect(x: 0, y: view.bounds.height - 60 - kBottomMaginHeight, width: view.bounds.width, height: 60), style: .bottom, completion:nil)
        inputTextView.sendBlock = { (_,object) in
            let notice = JXNoticeView(text: "发表成功")
            notice.show()
        }
        inputTextView.limitWords = 1000
        inputTextView.placeHolder = "写下你的评论吧~~🌹🌹🌹"
        self.view.addSubview(inputTextView)
        
    }
 
    @IBAction func showInputView() {
        let inputTextView = JXInputTextView(frame: CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 60), style: .hidden, completion:nil)
        inputTextView.sendBlock = { (_,object) in
            let notice = JXNoticeView(text: "发表成功")
            notice.show()
        }
        inputTextView.limitWords = 1000
        inputTextView.placeHolder = "写下你的评论吧~~🌹🌹🌹"
        inputTextView.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension JXInputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
