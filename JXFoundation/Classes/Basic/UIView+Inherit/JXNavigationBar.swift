//
//  JXNavigationBar.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/10/20.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

open class JXNavigationBar: UINavigationBar {
    //MARK:自定义导航栏内容
    ///是否使用自定义背景视图
    public var useCustomBackgroundView: Bool = false {
        didSet {
            self.backgroundView.isHidden = !useCustomBackgroundView
        }
    }
    ///是否使用大标题
    public var useLargeTitles: Bool = false {
        didSet {
            self.largeTitleView.isHidden = !useLargeTitles
        }
    }
    ///背景视图
    public lazy var backgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    ///背景图片
    public lazy var backgroundImage: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    ///分割线
    public lazy var separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    ///控制分割线的隐藏
    public var separatorHidden: Bool = false {
        didSet {
            clipsToBounds = separatorHidden
            self.separatorView.isHidden = separatorHidden
        }
    }
    ///内容视图，这里先不做，用导航栏的内容视图，需要的话自己往上写东西
    public lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    ///大标题视图，这里先不做，用导航栏自带大标题，需要的话自己往上写东西
    public lazy var largeTitleView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    //MARK:修改导航栏内容
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttribute()
        setupViews()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAttribute()
        setupViews()
    }
    open override func updateConstraints() {
        super.updateConstraints()
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: frame.maxY)
        self.backgroundImage.frame = CGRect(x: 0, y: 0, width: bounds.width, height: frame.maxY)
        self.separatorView.frame = CGRect(x: 0, y: frame.maxY - 0.33, width: bounds.width, height: 0.33)
        self.contentView.frame = CGRect(x: 0, y: kStatusBarHeight, width: bounds.width, height: 44)
        self.largeTitleView.frame = CGRect(x: 0, y: kStatusBarHeight + 44, width: bounds.width, height: 52)
        
        subviews.forEach { (v) in
            
            if NSStringFromClass(type(of: v)).contains("UIBarBackground") {
               
                if frame.maxY != frame.height {
                    v.frame = CGRect(x: 0, y: -frame.minY, width: bounds.width, height: frame.maxY - frame.minY)
                } else {
                    v.frame = CGRect(x: 0, y: -frame.minY, width: bounds.width, height: frame.maxY)
                }
                
                //隐藏分割线
                v.subviews.forEach({ (subV) in
                    
                    if subV.frame.height > 1 {
                        
                    } else {
                        //subV.backgroundColor = UIColor.clear
                    }
                    if let _ = self.backgroundView.superview {
                        
                    } else {
                        v.addSubview(self.backgroundView)
                        self.backgroundView.addSubview(self.backgroundImage)
                        self.backgroundView.addSubview(self.contentView)
                        self.backgroundView.addSubview(self.largeTitleView)
                        self.backgroundView.addSubview(self.separatorView)
                    }
                })
       
            } else if NSStringFromClass(type(of: v)).contains("UINavigationBarContentView") {
                if frame.maxY != frame.height {
                    v.frame = CGRect(x: 0, y: frame.minY, width: bounds.width, height: 44)
                } else {
                    v.frame = CGRect(x: 0, y: kStatusBarHeight, width: bounds.width, height: 44)
                }
            } else if NSStringFromClass(type(of: v)).contains("UINavigationBarLargeTitleView") {
                if frame.maxY != frame.height {
                    v.frame = CGRect(x: 0, y: frame.minY + 44, width: bounds.width, height: 52)
                } else {
                    v.frame = CGRect(x: 0, y: kStatusBarHeight + 44, width: bounds.width, height: 52)
                }
                ///调整 UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            }
            
//            if NSStringFromClass(type(of: v)).contains("UIBarBackground") {
//                v.frame = CGRect(x: 0, y: -kStatusBarHeight, width: UIScreen.main.bounds.width, height: rect.height + kStatusBarHeight)
//                //隐藏分割线
//                v.subviews.forEach({ (subV) in
//                    if subV.frame.height > 1 {
//                        subV.frame = CGRect(x: 0, y: -kStatusBarHeight, width: UIScreen.main.bounds.width, height: rect.height + kStatusBarHeight)
//                    } else {
//                        subV.backgroundColor = UIColor.clear
//                    }
//                    subV.alpha = 1
//                })
//                print(v.subviews)
//
//            } else if NSStringFromClass(type(of: v)).contains("UINavigationBarContentView") {
//
//                v.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
//            } else if NSStringFromClass(type(of: v)).contains("UINavigationBarLargeTitleView") {
//
//                v.frame = CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: 52)
//            }

//            if NSStringFromClass(type(of: v)).contains("UIBarBackground") {
//                v.frame = rect
//                //隐藏分割线
//                v.subviews.forEach({ (subV) in
//                    if subV.frame.height > 1 {
//                        subV.frame = rect
//                    } else {
//                        subV.backgroundColor = UIColor.clear
//                    }
//                    subV.alpha = 1
//                })
//                print(v.subviews)
//
//            } else if NSStringFromClass(type(of: v)).contains("UINavigationBarContentView") {
//
//                v.frame = CGRect(x: 0, y: kStatusBarHeight, width: UIScreen.main.bounds.width, height: 44)
//            } else if NSStringFromClass(type(of: v)).contains("UINavigationBarLargeTitleView") {
//
//                v.frame = CGRect(x: 0, y: kNavStatusHeight, width: UIScreen.main.bounds.width, height: 52)
//            }
        }
    }
    func setupAttribute() {
        
        isTranslucent = true
        barStyle = .default
        tintColor = UIColor.darkText //item图片文字颜色
        barTintColor = UIColor.clear //导航条颜色, 透明色不起作用, 需用透明图片来代替
        //setBackgroundImage(self.imageWithColor(UIColor.clear), for: UIBarMetrics.default) //导航条透明
        
//        if #available(iOS 13.0, *) {//标题设置
//            standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:  UIColor.rgbColor(rgbValue: 0x000000), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
//
//        } else {
//            titleTextAttributes = [NSAttributedString.Key.foregroundColor:  UIColor.rgbColor(rgbValue: 0x000000), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]//标题设置
//        }
        
    }
    
    func setupViews() {
        //_UIBarBackground
    }
}
