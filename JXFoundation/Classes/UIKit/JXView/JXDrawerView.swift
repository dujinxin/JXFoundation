//
//  JXDrawerView.swift
//  JXFoundation_Example
//
//  Created by Admin on 10/24/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public enum JXDrawerViewContentType {
    case title
    case image
}

public enum JXDrawerViewUnfoldDirection {
    case left
    case right
    case top
    case bottom
}

public protocol JXDrawerViewDelegate {
    func jxDrawerView(drawerView : JXDrawerView,didSelectItemAt index: Int) -> Void
}

public class JXDrawerView: JXButton {
    //MARK:public properties & methods
    /// delegate : JXDrawerViewDelegate
    public var delegate : JXDrawerViewDelegate?
    /// 回调
    public var clickBlock : JXSelectedBlock?
    public var unfoldBlock : JXClickBlock?
    
    public var contentType: JXDrawerViewContentType = .title
    public var unfoldDirection: JXDrawerViewUnfoldDirection = .bottom
    public var buttons = Array<UIButton>()
    public lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = attribute.backgroundColor
        view.layer.cornerRadius = attribute.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
   
    /// 创建一个滑动视图
    /// - Parameters:
    ///   - frame: frame
    ///   - delegate: 代理
    ///   - titles: 标题集合
    ///   - attribute: 常用属性设置
    public init(frame: CGRect, delegate: JXDrawerViewDelegate, titles: Array<String>, contentType: JXDrawerViewContentType, attribute: JXAttribute) {
        super.init(frame: frame)
        
        if attribute.normalImage.isEmpty, titles.isEmpty == false {
            attribute.normalImage = titles[0]
        }
        
        self.backgroundColor = attribute.normalBackgroundColor
        self.layer.cornerRadius = attribute.cornerRadius
        if attribute.normalImage.isEmpty == false {
            self.setImage(UIImage(named: attribute.normalImage), for: .normal)
        }
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(clickAction(button:)), for: .touchUpInside)
        
        
        self.rect = frame
        self.delegate = delegate
        self.attribute = attribute
        self.contentType = contentType
        
        self.titles = titles
        
        self.initSubViews(self.titles)
        
        //self.setFrame()
    }
    /// 创建一个滑动视图
    /// - Parameters:
    ///   - frame: frame
    ///   - titles: 标题集合（第一个为默认显示，其normal,selected状态颜色，字体，图片,背景色在attribute中配置）
    ///   - attribute: 常用属性设置
    ///   - clickBlock: 回调
    public init(frame: CGRect, titles: Array<String>, contentType: JXDrawerViewContentType, attribute: JXAttribute, clickBlock: JXClickBlock?) {
        super.init(frame: frame)

        if attribute.normalImage.isEmpty, titles.isEmpty == false {
            attribute.normalImage = titles[0]
        }
        
        self.backgroundColor = attribute.normalBackgroundColor
        self.layer.cornerRadius = attribute.cornerRadius
        if attribute.normalImage.isEmpty == false {
            self.setImage(UIImage(named: attribute.normalImage), for: .normal)
        }
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(clickAction(button:)), for: .touchUpInside)
        
        self.rect = frame
        self.clickBlock = clickBlock
        self.attribute = attribute
        self.contentType = contentType

        self.titles = titles

        self.initSubViews(self.titles)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    /// 被添加到父视图上时触发，
    public override func didMoveToSuperview() {
        self.setFrame()
    }
    func setFrame() {
        let itemWidth = frame.size.width > frame.size.height ? frame.size.height : frame.size.width
        self.totalWidth = CGFloat(self.titles.count) * itemWidth
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: itemWidth, height: itemWidth)
        self.containerView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: itemWidth, height: itemWidth)
        if let superview = self.superview {
            if let _ = self.containerView.superview {} else {
                superview.insertSubview(self.containerView, belowSubview: self)
            }
        }
        
        self.rects.removeAll(keepingCapacity: true)
        for i in 0..<self.titles.count {
            let button = self.buttons[i]
            var rect = CGRect()
            if unfoldDirection == .top {
                rect = CGRect(x: 0, y: self.totalWidth - itemWidth * CGFloat(i + 1), width: itemWidth, height: itemWidth)
            } else if unfoldDirection == .bottom {
                rect = CGRect(x: 0, y: itemWidth * CGFloat(i), width: itemWidth, height: itemWidth)
            } else if unfoldDirection == .left {
                rect = CGRect(x: self.totalWidth - itemWidth * CGFloat(i + 1), y: 0, width: itemWidth, height: itemWidth)
            } else if unfoldDirection == .right {
                rect = CGRect(x: itemWidth * CGFloat(i), y: 0, width: itemWidth, height: itemWidth)
            }
            button.frame = rect
            button.contentEdgeInsets = attribute.contentEdgeInsets
            
            self.rects.append(rect)
        }
    }
    //MARK:private properties & methods
    private var attribute: JXAttribute!
    private var titles = Array<String>()
    
    private var rects = Array<CGRect>()
    private var rect: CGRect = CGRect()
    private var totalWidth: CGFloat = 0
    private var isUnfold: Bool = false
    
    private func initSubViews(_ titles: Array<String>) {
        
        for i in 0..<titles.count {
            let title = titles[i]
            
            let button = UIButton()
            button.setTitleColor(attribute.normalColor, for: .normal)
            button.setTitleColor(attribute.selectedColor, for: .selected)
            button.tag = i
            
            button.contentEdgeInsets = attribute.contentEdgeInsets
            if contentType == .title {
                button.setTitle(title, for: .normal)
                
                if let fontName = attribute.fontName {
                    button.titleLabel?.font = UIFont(name: fontName, size: button.isSelected ? attribute.selectedFontSize : attribute.normalFontSize)
                } else {
                    button.titleLabel?.font = UIFont.systemFont(ofSize: button.isSelected ? attribute.selectedFontSize : attribute.normalFontSize)
                }
            } else {
                button.setImage(UIImage(named: title), for: .normal)
            }
            button.layer.cornerRadius = attribute.cornerRadius
            if i == 0 {
                //button.backgroundColor = attribute.normalBackgroundColor
            } else {
                button.addTarget(self, action: #selector(tabButtonAction(button:)), for: .touchUpInside)
            }
            
            self.containerView.addSubview(button)
            self.buttons.append(button)
        }
    }
    /// 展开点击事件
    /// - Parameter button: <#button description#>
    @objc func tabButtonAction(button : UIButton) {
        
        if button.tag == 0 {} else {
            let btn = self.buttons[0]
            btn.isSelected = false
            self.isUnfold = false
            self.unfold(false)
        }
        self.resetStatus(self.isUnfold)
        //self.selectedIndex = button.tag
       
        if let target = self.delegate {
            target.jxDrawerView(drawerView: self, didSelectItemAt: button.tag)
        }
        if let block = self.clickBlock {
            block(self, button.tag)
        }
    }
    /// 开关事件
    /// - Parameter button: self
    @objc func clickAction(button : UIButton) {
            
        button.isSelected = !button.isSelected
        self.isUnfold = button.isSelected
        self.unfold(button.isSelected)
        
        self.resetStatus(self.isUnfold)
        //self.selectedIndex = button.tag
       
        if let target = self.delegate {
            target.jxDrawerView(drawerView: self, didSelectItemAt: button.tag)
        }
        if let block = self.unfoldBlock {
            block(self, button.isSelected)
        }
    }
    /// 开关状态切换
    /// - Parameter isOn: 开关
    @objc func resetStatus(_ isOn: Bool) {
        
        //状态 变化（字体颜色，大小，背景色等等）
        //let button = self.buttons[0]
        let button = self
        button.isSelected = isOn
        if let fontName = attribute.fontName {
            button.titleLabel?.font = UIFont(name: fontName, size: attribute.selectedFontSize)
        } else {
            button.titleLabel?.font = UIFont.systemFont(ofSize: attribute.selectedFontSize)
        }
        if isOn {
            button.backgroundColor = attribute.selectedBackgroundColor
        } else {
            button.backgroundColor = attribute.normalBackgroundColor
        }
        
        if attribute.selectedImage.isEmpty == false {
            button.setImage(UIImage(named: attribute.selectedImage), for: .selected)
        }
        if attribute.normalImage.isEmpty == false {
            button.setImage(UIImage(named: attribute.normalImage), for: .normal)
        }
    }
    /// 展开关闭动画
    /// - Parameter isOn: 开关
    func unfold(_ isOn: Bool) {
        if isOn {
            var rect = self.containerView.frame
            if unfoldDirection == .top {
                rect.size.height = self.totalWidth
                rect.origin.y = rect.origin.y - (self.totalWidth / CGFloat(self.titles.count)) * CGFloat(self.titles.count - 1)
            } else if unfoldDirection == .bottom {
                rect.size.height = self.totalWidth
            } else if unfoldDirection == .left {
                rect.size.width = self.totalWidth
                rect.origin.x = self.containerView.frame.maxX - self.totalWidth
            } else if unfoldDirection == .right {
                rect.size.width = self.totalWidth
            }
            //print(self.totalWidth,rect.origin.x,rect)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.frame = rect
            }) { (isFinish) in
                
            }
            
        } else {
            var rect = self.containerView.frame
            rect.size = CGSize(width: self.totalWidth / CGFloat(self.titles.count), height: self.totalWidth / CGFloat(self.titles.count))
            if unfoldDirection == .top {
                rect.origin.y = rect.origin.y + (self.totalWidth / CGFloat(self.titles.count)) * CGFloat(self.titles.count - 1)
            } else if unfoldDirection == .left {
                rect.origin.x = self.containerView.frame.maxX - self.totalWidth / CGFloat(self.titles.count)
            }
            //print(self.totalWidth,rect.origin.x,rect)
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.frame = rect
            }) { (isFinish) in
                
            }
        }
    }
}
