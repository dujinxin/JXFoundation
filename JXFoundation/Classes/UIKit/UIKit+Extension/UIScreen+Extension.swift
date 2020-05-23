//
//  UIScreen+Extension.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/7/3.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

public let kStatusBarHeight : CGFloat = UIScreen.main.isIphoneXAbove ?44 : 20
public let kNavBarHeight : CGFloat = 44
public let kNavStatusHeight = kStatusBarHeight + kNavBarHeight
public let kNavLargeTitleHeight : CGFloat = 60
public let kBottomMaginHeight : CGFloat = UIScreen.main.isIphoneXAbove ? 34 : 0
public let kTabBarHeight : CGFloat = kBottomMaginHeight + 49

public let kScreenWidth = UIScreen.main.screenWidth
public let kScreenHeight = UIScreen.main.screenHeight

public let kHWPercent = (UIScreen.main.screenHeight / UIScreen.main.screenWidth)//高宽比例
public let kPercent = UIScreen.main.screenWidth / 375.0

/// 设备型号
public enum Model: CGSize {
    case iPhoneSE1 = "{640.0,1136.0}"
    //以最新机型SE2为代表，其尺寸一样
    //case iPhone8 = "{750.0,1334.0}"         //6 6S 7
    case iPhone8p = "{1242.0,2208.0}"       //6P 6SP 7P
    
    case iPhoneSE2 = "{750.0,1334.0}"
    
    case iPhone11 = "{828.0,1792.0}"        //XR
    case iPhone11Pro = "{1125.0,2436.0}"    //X XS
    case iPhone11ProMax = "{1242.0,2688.0}" //XMAX XSMAX
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
public extension UIScreen {
    
    var isIphoneXAbove : Bool {
        get{
            if self.model == .iPhone11 || self.model == .iPhone11Pro || self.model == .iPhone11ProMax {
                return true
            } else {
                return false
            }
        }
    }
    var model: Model {
        get{
            
            guard let mode = self.currentMode
                else {
                    return .iPhoneSE2
            }
            return Model.init(rawValue: mode.size) ?? .iPhone11Pro
        }
    }
    
    var screenSize : CGSize {
        get{
            return bounds.size
        }
    }
    var screenWidth : CGFloat {
        get{
            return bounds.width
        }
    }
    var screenHeight : CGFloat {
        get{
            return bounds.height
        }
    }
}
