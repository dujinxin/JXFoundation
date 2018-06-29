//
//  String+Extension.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/29.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    
    
    static func validateTelephone(tel:String) -> Bool {
        //手机号以13， 15，18开头，八个 \d 数字字符
        //NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
        //只做1开头，11位的校验，其他详细的交给后台来做
        let phoneRegex = "^1\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: tel)
    }
    //用户名 6-16位只含有汉字、数字、字母、下划线，下划线位置不限
//    func validateUserName(name:String) -> Bool {
//        let userNameRegex = "^[a-zA-Z0-9_\u4e00-\u9fa5]{2,12}+$"
//        let predicate = NSPredicate(format: "SELF MATCHES %@", userNameRegex)
//        return predicate.evaluate(with: name)
//    }
    //密码  8-16位数字或字母 ^[a-zA-Z0-9]{8,16}+$
    // 数字和密码的组合，不能纯数字或纯密码 ^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$
    static func validatePassword(passWord:String) -> Bool {
        
        let passWordRegex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        return predicate.evaluate(with: passWord)
    }
    static func validateVerficationCode(code:String) -> Bool {
        
        let passWordRegex = "^[0-9]{6}+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        return predicate.evaluate(with: code)
    }
    static func validateCode(code:String) -> Bool {
        
        let passWordRegex = "^[0-9]{12}+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        return predicate.evaluate(with: code)
    }
}

public extension String {
    
    public func calculate(width: CGFloat,fontSize:CGFloat,lineSpace:CGFloat = -1) -> CGSize {
        
        if self.isEmpty {
            return CGSize()
        }
        
        let ocText = self as NSString
        
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineSpacing = lineSpace
        var attributes : Dictionary<NSAttributedStringKey, Any>
        if lineSpace < 0 {
            attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize)]
        }else{
            attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize),NSAttributedStringKey.paragraphStyle:paragraph]
        }
        //usesLineFragmentOrigin 绘制文本时使用 line fragement origin 而不是 baseline origin
        //usesFontLeading 根据字体计算高度
        //使用以上这两属性来组合，一定要加，不然计算不准确，
        //usesDeviceMetrics使用象形文字计算高度，这个不要加，加了计算也不准确
        let rect = ocText.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: attributes, context: nil)
        
        let height : CGFloat
        if rect.origin.y < 0 {
            height = abs(rect.origin.y) + rect.height
        }else{
            height = rect.height
        }
        
        return CGSize(width: rect.width, height: height)
    }
}
