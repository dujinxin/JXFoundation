//
//  UIScreen+Extension.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/7/3.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

public let kStatusBarHeight = UIScreen.main.isIphoneX ? CGFloat(44) : CGFloat(20)
public let kNavBarHeight = CGFloat(44)
public let kNavStatusHeight = kStatusBarHeight + kNavBarHeight
public let kBottomMaginHeight : CGFloat = UIScreen.main.isIphoneX ? 34 : 0
public let kTabBarHeight : CGFloat = kBottomMaginHeight + 49

public let kHWPercent = (UIScreen.main.screenHeight / UIScreen.main.screenWidth)//高宽比例
public let kPercent = UIScreen.main.screenWidth / 375.0

public enum Model: CGSize {
    case iPhoneSE = "{640.0,1136.0}"
    case iPhone8 = "{750.0,1334.0}"
    case iPhone8p = "{1242.0,2208.0}"
    case iPhoneX = "{1125.0,2436.0}"
    case iPhoneXR = "{828.0,1792.0}"
    case iPhoneXM = "{1242.0,2688.0}"
}
extension CGSize: ExpressibleByStringLiteral{
    
    public init(stringLiteral value: String) {
        let size = NSCoder.cgSize(for: value)
        self.init(width: size.width, height: size.height)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        let size = NSCoder.cgSize(for: value)
        self.init(width: size.width, height: size.height)
    }
    
    public init(unicodeScalarLiteral value: String) {
        let size = NSCoder.cgSize(for: value)
        self.init(width: size.width, height: size.height)
    }
}
extension UIScreen {
    
    public var isIphoneX : Bool {
        get{
            if self.model == .iPhoneX || self.model == .iPhoneXR || self.model == .iPhoneXM {
                return true
            } else {
                return false
            }
        }
    }
    public var model: Model {
        get{
            
            guard let mode = self.currentMode
                else {
                    return .iPhoneSE
            }
            return Model.init(rawValue: mode.size) ?? .iPhoneX
        }
    }
    
    public var screenSize : CGSize {
        get{
            return bounds.size
        }
    }
    public var screenWidth : CGFloat {
        get{
            return bounds.width
        }
    }
    public var screenHeight : CGFloat {
        get{
            return bounds.height
        }
    }
}
