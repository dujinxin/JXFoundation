//
//  String+Extension.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/29.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

public enum  RegularExpression : String{
    case none                = ""          //
    
    case phone               = "^1\\d{10}$"   //手机号，只做1开头11位的基本校验
    case identityCard        = "^(\\d{14}|\\d{17})(\\d|[xX])$"//身份证号
    case number              = "[0-9]*"       //数字
    case letter              = "[a-zA-Z]*"    //字母
    case chinese             = "[\\u4e00-\\u9fa5]+"  //汉字
    case numberOrLetter      = "[a-zA-Z0-9]*" //数字或字母
    case numberOrLetter8_20  = "[a-zA-Z0-9]{8,20}+$"//8-20位数字或字母
    case code4               = "^[0-9]{4}+$"  //四位验证码
    case code6               = "^[0-9]{6}+$"  //六位验证码
    case numberAndLetter8_20 = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$" //8-20位数字加字母的组合

}

// MARK: - 字符串校验
public extension String {
    
    /// 字符串校验
    ///
    /// - Parameters:
    ///   - string: 需要校验的字符串
    ///   - predicateStr: 正则
    /// - Returns: 结果
    func validate(predicateStr: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", predicateStr)
        return predicate.evaluate(with: self)
    }
    static func validate(_ string: String, predicateStr: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", predicateStr)
        return predicate.evaluate(with: string)
    }
}
// MARK: - 文本计算
public extension String {
    
    func calculate(width: CGFloat = CGFloat.greatestFiniteMagnitude, font: UIFont, lineSpace: CGFloat = -1) -> CGSize {
        
        if self.isEmpty {
            return CGSize()
        }
        
        let ocText = self as NSString
        var attributes : Dictionary<NSAttributedString.Key, Any>
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineSpacing = lineSpace
        
        if lineSpace < 0 {
            attributes = [NSAttributedString.Key.font:font]
        }else{
            attributes = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:paragraph]
        }
        
        let rect = ocText.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading,.usesDeviceMetrics], attributes: attributes, context: nil)
        
        let height : CGFloat
        if rect.origin.x < 0 {
            height = abs(rect.origin.x) + rect.height
        } else {
            height = rect.height
        }
        
        return CGSize(width: rect.width, height: height)
    }
}
// MARK: - 加解密
public extension String {
//    func md5(string:String) -> String {
//        return MD5.encode(string)
//    }
//    func base64encode(string:String) -> String? {
//        return Base64.stringDecode(string)
//    }
//    func base64decode(string:String) -> String? {
//        return Base64.stringDecode(string)
//    }
}
// MARK: - 沙盒文件路径 path
public extension String {
    //MARK: - 系统路径
    /// home文件夹路径
    static var homeDirectoryPath: String {
        return NSHomeDirectory()
    }
    /// tmp文件夹路径
    static var tmpDirectoryPath: String {
        return NSTemporaryDirectory()
    }
    /// document文件夹路径 eg: /var/mobile/Containers/Data/Application/18BD30C1-CEA0-4EEF-B315-0944AC3EEC7B/Documents
    static var documentDirectoryPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    /// library文件夹路径
    static var libraryDirectoryPath: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
    }
    /// caches文件夹路径  .../Library/Caches
    static var cachesDirectoryPath: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    }
    //MARK: - 自定义路径
    /// userInfoPath文件路径 eg: /var/mobile/Containers/Data/Application/18BD30C1-CEA0-4EEF-B315-0944AC3EEC7B/Documents/userInfo"
    static var userInfoPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/userInfo"
    }
    /// downloads文件夹路径 eg: /var/mobile/Containers/Data/Application/18BD30C1-CEA0-4EEF-B315-0944AC3EEC7B/Documents/downloads"
    static var downloadsDirectoryPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/Downloads"
    }
}
