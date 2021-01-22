//
//  JXAutoScrollView.swift
//  JXFoundation_Example
//
//  Created by Admin on 9/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public protocol JXAutoScrollViewDelegate {
    func jxAutoScrollView(autoScrollView : JXAutoScrollView,didSelectItemAt index: Int) -> Void
}

public class JXAutoScrollView: UIView {

    public lazy var containerView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        //view.delegate = self
        return view
    }()
    //MARK: private properties
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(attribute.normalColor, for: .normal)
        button.setTitleColor(attribute.selectedColor, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: attribute.normalFontSize)
        button.tag = 0
        button.addTarget(self, action: #selector(tabButtonAction(button:)), for: .touchUpInside)
        button.contentEdgeInsets = attribute.contentEdgeInsets
        return button
    }()
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(attribute.normalColor, for: .normal)
        button.setTitleColor(attribute.selectedColor, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: attribute.normalFontSize)
        button.tag = 1
        button.addTarget(self, action: #selector(tabButtonAction(button:)), for: .touchUpInside)
        button.contentEdgeInsets = attribute.contentEdgeInsets
        return button
    }()
    lazy var displayLink: CADisplayLink = {
        let link = CADisplayLink(target: self, selector: #selector(scrollWithAnimate))
        link.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        return link
    }()
    var attribute: JXAttribute = JXAttribute() {
        didSet{
            self.backgroundColor = attribute.backgroundColor
            self.leftButton.titleLabel?.font = UIFont.systemFont(ofSize: attribute.normalFontSize)
            self.rightButton.titleLabel?.font = UIFont.systemFont(ofSize: attribute.normalFontSize)
        }
    }
    var currentIndex = 0
    
    //MARK: public properties & methods
    /// NSString || NSSAttrbuteString
    var titles: Array<Any> = Array<Any>() {
        didSet{
            initSubViews(titles)
        }
    }
    /// delegate : JXScrollTitleViewDelegate
    public var delegate : JXAutoScrollViewDelegate?
    /// 回调
    public var clickBlock : ((_ view: UIView, _ index: Int) -> ())?
    public var selectedIndex = 0 {
        didSet{
            //self.resetStatus(animateType: 0)
        }
    }
    
    public var buttons = Array<UIButton>()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// 创建一个滑动视图
    /// - Parameters:
    ///   - frame: frame
    ///   - delegate: 代理
    ///   - titles: 标题集合 String  || NSAttributedString
    ///   - attribute: 常用属性设置
    public init(frame: CGRect, delegate: JXAutoScrollViewDelegate, titles: Array<Any>, attribute: JXAttribute) {
        super.init(frame: frame)
        
        self.titles = titles
        self.delegate = delegate
        self.attribute = attribute
        
        
        self.backgroundColor = attribute.backgroundColor
        
        self.addSubview(self.containerView)
        
        self.initSubViews(titles)
    }
    /// 创建一个滑动视图
    /// - Parameters:
    ///   - frame: frame
    ///   - titles: 标题集合 String  || NSAttributedString
    ///   - attribute: 常用属性设置
    ///   - clickBlock: 回调
    @objc public init(frame: CGRect, titles: Array<Any>, attribute: JXAttribute, clickBlock: ((_ view: UIView,_ index: Int) -> ())?) {
        super.init(frame: frame)
        
        self.titles = titles
        self.clickBlock = clickBlock
        self.attribute = attribute
        
        self.backgroundColor = attribute.backgroundColor
        
        self.addSubview(self.containerView)
        self.initSubViews(titles)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()

        self.containerView.frame = CGRect(x: attribute.sectionEdgeInsets.left, y: attribute.sectionEdgeInsets.top, width: bounds.width - attribute.sectionEdgeInsets.left - (-attribute.sectionEdgeInsets.right), height: bounds.height - attribute.sectionEdgeInsets.top - (-attribute.sectionEdgeInsets.bottom))
        
        if titles.count == 0 {
            return
        } else if titles.count == 1 {
            if let _ = self.leftButton.superview {} else {
                self.containerView.addSubview(self.leftButton)
            }
            self.containerView.contentSize = frame.size
        } else {
            if let _ = self.leftButton.superview {} else {
                self.containerView.addSubview(self.leftButton)
            }
            if let _ = self.rightButton.superview {} else {
                self.containerView.addSubview(self.rightButton)
            }
            self.setButtonTitle(self.rightButton, titles[1])
            
            self.containerView.contentSize = CGSize(width: frame.size.width * 2, height: frame.size.height)
        }
        
        self.setButtonTitle(self.leftButton, titles[0])
        self.leftButton.frame = CGRect(x: 0, y: 0, width: self.containerView.bounds.width, height: self.containerView.bounds.height)
        self.rightButton.frame = CGRect(x: self.containerView.bounds.width, y: 0, width: self.containerView.bounds.width, height: self.containerView.bounds.height)
        
    }
    
    //MARK: private methods
    @objc func tabButtonAction(button : UIButton) {
        
        self.selectedIndex = button.tag
       
        if let target = self.delegate {
            target.jxAutoScrollView(autoScrollView: self, didSelectItemAt: button.tag)
        }
        if let block = self.clickBlock {
            block(self, self.selectedIndex)
        }
    }
    private func initSubViews(_ titles: Array<Any>) {
        
        if titles.count == 0 {
            return
        } else if titles.count == 1 {
            if let _ = self.leftButton.superview {} else {
                self.containerView.addSubview(self.leftButton)
            }
            self.containerView.contentSize = frame.size
        } else {
            if let _ = self.leftButton.superview {} else {
                self.containerView.addSubview(self.leftButton)
            }
            if let _ = self.rightButton.superview {} else {
                self.containerView.addSubview(self.rightButton)
            }
            self.setButtonTitle(self.rightButton, titles[1])
            
            self.containerView.contentSize = CGSize(width: frame.size.width * 2, height: frame.size.height)
        }
        self.setButtonTitle(self.leftButton, titles[0])
    }
    /// 切换视图赋值
    /// - Parameters:
    ///   - button: 视图
    ///   - title: String  || NSAttributedString
    func setButtonTitle(_ button: UIButton ,_ title: Any) {
        if title is String {
            button.setTitle(title as? String, for: .normal)
        } else {
            button.setAttributedTitle(title as? NSAttributedString, for: .normal)
        }
    }
    /// 切换方法
    @objc func scrollWithAnimate() {
        var offset = self.containerView.contentOffset
        offset.x += 1
        self.containerView.contentOffset = offset
        
        if offset.x == self.containerView.bounds.width {
            self.containerView.setContentOffset(CGPoint(), animated: false)
            
            if currentIndex == self.titles.count - 1 {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
            
            //设置左边
            self.leftButton.tag = currentIndex
            self.setButtonTitle(self.leftButton, titles[currentIndex])
        
            //设置右边
            if currentIndex + 1 >= titles.count {
                self.rightButton.tag = 0
                self.setButtonTitle(self.rightButton, titles[0])
            } else {
                self.rightButton.tag = currentIndex + 1
                self.setButtonTitle(self.rightButton, titles[currentIndex + 1])
            }
        }
    }
    //MARK: public methods
    @objc public func beginScroll() {
        if self.titles.count < 2 || self.containerView.contentSize.width <= self.containerView.bounds.width {
            return
        }
        self.displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    @objc public func stopScroll() {
        self.displayLink.remove(from: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
}
