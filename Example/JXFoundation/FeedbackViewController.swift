//
//  FeedbackViewController.swift
//  JXView_Example
//
//  Created by 杜进新 on 2018/6/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class FeedbackViewController: UIViewController {
    
    lazy var textView: JXPlaceHolderTextView = {
        //        let textView = JXPlaceHolderTextView(frame: CGRect(x: 10, y:kNavStatusHeight + 10, width: kScreenWidth - 20, height: 80), textContainer: NSTextContainer(size: CGSize(width: 100, height: 44)))
        let textView = JXPlaceHolderTextView()
        textView.frame = CGRect(x: 10, y:kNavStatusHeight + 10, width: kScreenWidth - 20, height: 80)
        textView.placeHolderText = "为了寻你，我错过了许许许多多的良辰美景!"
        textView.delegate = self
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(self.textView)
        
        //self.textView.text = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
        
        NotificationCenter.default.addObserver(self, selector: #selector(placeHolderTextChange(nofiy:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
}

extension FeedbackViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //限制输入字符个数
        if range.location >= 100{
            let notice = JXNoticeView(text: "字符个数不能大于100")
            notice.show()
            return false
        }
        //return键 收键盘
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    @objc func placeHolderTextChange(nofiy:Notification) {
        
    }
}
