//
//  InputViewController.swift
//  JXFoundation_Example
//
//  Created by 杜进新 on 2018/11/10.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class InputViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var submitButton: UIButton! {
        didSet{
            submitButton.layer.cornerRadius = 2
            submitButton.layer.shadowOpacity = 1
            submitButton.layer.shadowRadius = 10
            submitButton.layer.shadowOffset = CGSize(width: 0, height: 10)
            submitButton.layer.shadowColor = UIColor.lightGray.cgColor
            
            submitButton.addTarget(self, action: #selector(addOrder), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var remarkTextView: JXPlaceHolderTextView! {
        didSet{
            //remarkTextView.layer.borderColor = UIColor.lightGray.cgColor
            //remarkTextView.layer.borderWidth = 1
            remarkTextView.placeHolderText = "写一段话介绍一下自己吧！"
        }
    }
    
    var defaultArray: Array = [["title":"可用币数量"],["title":"卖出币数量"],["title":"卖出单价"],["title":"卖出总价"],["title":"手续费"],["title":"实际总价"],["title":"支付方式"]]
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 30, y: 0, width: 200, height: 44)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("添加", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(addOrder), for: .touchUpInside)
        //button.backgroundColor = JXOrangeColor
        return button
    }()

    var payName = "请选择"
    var payType = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
//        if #available(iOS 11.0, *) {
//            self.mainScrollView.contentInsetAdjustmentBehavior = .never
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = false
//        }
        
        self.title = "InputView"
        
        let bar = JXKeyboardToolBar(frame: CGRect(), views: [nameTextField,ageTextField,remarkTextView]) { (view, value) in
            print(view,value)
        }
        self.view.addSubview(bar)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func addOrder() {
        print("T##items: Any...##Any")
        
    }
    
}

extension InputViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc func textChange(notify: NSNotification) {
        
        if
            notify.object is UITextField,
            let textField = notify.object as? UITextField,
            textField == self.nameTextField {
            
            
            if
                let num = textField.text,
                let numDouble = Double(num){
                
            } else {
                
            }
            
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //删除键
        if string == "" {
            return true
        }
        return true
    }
    
}
