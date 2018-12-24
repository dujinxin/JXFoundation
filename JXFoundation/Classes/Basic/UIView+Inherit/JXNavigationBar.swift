//
//  JXNavigationBar.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/10/20.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

open class JXNavigationBar: UINavigationBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }￼
    */

    /// 颜色渐变
    lazy var gradientLayer: CAGradientLayer = {
        
        let gradient = CAGradientLayer.init()
        gradient.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        //gradient.locations = [0.5]
        gradient.locations = [0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = CGRect(x: 0, y: 0, width: self.jxWidth, height: self.jxHeight)
        return gradient
    }()
    func imageWithColor(_ color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    public var separatorHidden: Bool? {
        didSet {
            print("------------------------------------------------")
            clipsToBounds = separatorHidden ?? true
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttribute()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAttribute()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        var rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kNavStatusHeight)

        print("*******************\(#file)************************")
        self.subviews.forEach { (v) in

            if NSStringFromClass(type(of: v)).contains("UIBarBackground") {
                v.frame = rect
                //隐藏分割线
//                v.subviews.forEach({ (subV) in
//                    if subV is UIImageView {
//                        subV.backgroundColor = UIColor.clear
//                    }
//                })

            } else if NSStringFromClass(type(of: v)).contains("UINavigationBarContentView") {
                rect.origin.y += kStatusBarHeight
                rect.size.height -= kStatusBarHeight
                v.frame = rect
            }
        }
    }
    func setupAttribute() {
        titleTextAttributes = [NSAttributedString.Key.foregroundColor:  UIColor.rgbColor(rgbValue: 0x000000), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]//标题设置
        barTintColor = UIColor.clear //导航条颜色, 透明色不起作用, 需用透明图片来代替
        tintColor = UIColor.darkText //item图片文字颜色
        isTranslucent = true
        barStyle = .default
        
        setBackgroundImage(self.imageWithColor(UIColor.clear), for: UIBarMetrics.default) //导航条透明
    }
}
