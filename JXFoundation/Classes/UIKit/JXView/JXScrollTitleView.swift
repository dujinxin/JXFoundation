//
//  JXScrollTitleView.swift
//  FBSnapshotTestCase
//
//  Created by Admin on 5/5/20.
//

import UIKit

public enum JXScrollTitleViewBottomLineType {
    case defalut          //隐藏
    case customSize       //自定义大小
    case titleSize        //跟随title
}

public protocol JXScrollTitleViewDelegate {
    func jxScrollTitleView(scrollTitleView : JXScrollTitleView,didSelectItemAt index: Int) -> Void
}

public class JXScrollTitleView: JXView {
    
    public var delegate : JXScrollTitleViewDelegate?
    public var selectedIndex = 0 {
        didSet{
            self.resetStatus(animateType: 0)
        }
    }
    public lazy var containerView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        return view
    }()
    public var lineType : JXScrollTitleViewBottomLineType = .defalut {
        didSet{
            self.bottomLineView.isHidden = lineType == .defalut ? true : false
        }
    }
    /// 底部线条，origin不起作用
    public lazy var bottomLineView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 60, height: 2)
        view.backgroundColor = UIColor.darkGray
        view.isHidden = true
        return view
    }()
    public init(frame: CGRect, delegate: JXScrollTitleViewDelegate, titles: Array<String>, attribute: JXAttribute) {
        super.init(frame: frame)
        
        self.delegate = delegate
        self.attribute = attribute
        self.titles = titles
        
        self.backgroundColor = attribute.backgroundColor
        
        self.addSubview(self.containerView)
        self.initSubViews(titles)
        self.containerView.addSubview(self.bottomLineView)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()

        self.containerView.frame = CGRect(x: attribute.sectionEdgeInsets.left, y: attribute.sectionEdgeInsets.top, width: bounds.width - attribute.sectionEdgeInsets.left - (-attribute.sectionEdgeInsets.right), height: bounds.height - attribute.sectionEdgeInsets.top - (-attribute.sectionEdgeInsets.bottom))
        
        
        
        
        self.totalWidth = 0
        
        
        self.rects.removeAll(keepingCapacity: true)
        for i in 0..<self.titles.count {
            let button = self.buttons[i]
            //let title = self.titles[i]
            
            var font : UIFont!
            if let fontName = attribute.fontName {
                font = UIFont(name: fontName, size: (selectedIndex == i) ? attribute.selectedFontSize : attribute.normalFontSize)
            } else {
                font = UIFont.systemFont(ofSize: (selectedIndex == i) ? attribute.selectedFontSize : attribute.normalFontSize)
            }
            button.titleLabel?.font = font
            
            //TODO:文本计算出来的尺寸并不能完整显示文本
            //let size = title.calculate(width: UIScreen.main.screenWidth, font: font)
            //let itemWidth = size.width + 4 + CGFloat(fabsf(Float(attribute.contentMarginEdge.left))) + CGFloat(fabsf(Float(attribute.contentMarginEdge.right)))
            
            let contentWidth = button.sizeThatFits(CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: self.containerView.bounds.height)).width
            let itemWidth = contentWidth + CGFloat(fabsf(Float(attribute.contentMarginEdge.left))) + CGFloat(fabsf(Float(attribute.contentMarginEdge.right)))
            let itemHeight = self.containerView.bounds.size.height - attribute.sectionEdgeInsets.top - (-attribute.sectionEdgeInsets.bottom)
            
            let rect = CGRect(x: self.totalWidth, y: attribute.sectionEdgeInsets.top, width: itemWidth, height: itemHeight)
            button.frame = rect
            button.contentEdgeInsets = attribute.contentEdgeInsets
            
            self.rects.append(rect)
            if i == self.titles.count - 1 {
                self.totalWidth += rect.width
            } else {
                self.totalWidth += (rect.width + attribute.minimumInteritemSpacing)
            }
            
            if i == selectedIndex && isFirstInit {
                isFirstInit = false
                
                var lineFrame = self.bottomLineView.frame
                lineFrame.origin.y = self.containerView.bounds.height - lineFrame.height
                if self.lineType == .customSize {
                    lineFrame.origin.x = (rect.size.width - lineFrame.width) / 2 + rect.origin.x
                } else if self.lineType == .titleSize {
                    lineFrame.origin.x = rect.origin.x
                    lineFrame.size.width = rect.size.width
                }
                self.bottomLineView.frame = lineFrame
            }
            
        }
        
        if self.totalWidth <= self.containerView.bounds.width {
            self.containerView.contentSize = self.containerView.bounds.size
        } else {
            self.containerView.contentSize = CGSize(width: self.totalWidth, height: bounds.height)
        }
    }
    //MARK:private properties & methods
    private var attribute: JXAttribute!
    private var titles = Array<String>()
    private var buttons = Array<UIButton>()
    private var rects = Array<CGRect>()
    private var totalWidth: CGFloat = 0
    private var isFirstInit: Bool = true
    
    private func initSubViews(_ titles: Array<String>) {
        
        for i in 0..<titles.count {
            let title = titles[i]
            
            let button = UIButton()
            button.setTitleColor(attribute.normalColor, for: .normal)
            button.setTitleColor(attribute.selectedColor, for: .selected)
            button.tag = i
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(tabButtonAction(button:)), for: .touchUpInside)
            button.contentEdgeInsets = attribute.contentEdgeInsets
            if i == selectedIndex {
                button.isSelected = true
                button.setTitle(title, for: .selected)
            }else{
                button.setTitle(title, for: .normal)
            }
            
            if let fontName = attribute.fontName {
                button.titleLabel?.font = UIFont(name: fontName, size: button.isSelected ? attribute.selectedFontSize : attribute.normalFontSize)
            } else {
                button.titleLabel?.font = UIFont.systemFont(ofSize: button.isSelected ? attribute.selectedFontSize : attribute.normalFontSize)
            }
            
            self.containerView.addSubview(button)
            self.buttons.append(button)
        }
    }
    
    @objc func tabButtonAction(button : UIButton) {
        
        self.selectedIndex = button.tag
       
        if let target = self.delegate {
            target.jxScrollTitleView(scrollTitleView: self, didSelectItemAt: button.tag)
        }
    }
    func resetStatus(animateType: Int) {
        
        //状态 变化（字体颜色，大小，背景色等等）
        let button = self.buttons[self.selectedIndex]
        button.isSelected = true
        if let fontName = attribute.fontName {
            button.titleLabel?.font = UIFont(name: fontName, size: attribute.selectedFontSize)
        } else {
            button.titleLabel?.font = UIFont.systemFont(ofSize: attribute.selectedFontSize)
        }
        self.buttons.forEach { (btn : UIButton) -> () in
            if (btn.tag != button.tag){
                btn.isSelected = false
                if let fontName = attribute.fontName {
                    button.titleLabel?.font = UIFont(name: fontName, size: attribute.normalFontSize)
                } else {
                    button.titleLabel?.font = UIFont.systemFont(ofSize: attribute.normalFontSize)
                }
            }
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        //底部条 动画
        let rect = self.rects[self.selectedIndex]
        UIView.animate(withDuration: 0.3, animations: {
            
            if self.lineType == .customSize {
                var lineFrame = self.bottomLineView.frame
                lineFrame.origin.x = (rect.size.width - lineFrame.width) / 2 + rect.origin.x
                self.bottomLineView.frame = lineFrame
            } else if self.lineType == .titleSize {
                var lineFrame = self.bottomLineView.frame
                lineFrame.origin.x = rect.origin.x
                lineFrame.size.width = rect.size.width
                self.bottomLineView.frame = lineFrame
            }
            
        }) { (finished) in
            
            
        }
        //scrollView 滚动动画
        let rectWithCenter = CGRect(x: button.center.x - self.containerView.bounds.width / 2, y: 0, width: self.containerView.bounds.width, height: self.containerView.bounds.height)
        self.containerView.scrollRectToVisible(rectWithCenter, animated: true)
    }
}
extension JXScrollTitleView: UIScrollViewDelegate {

}


