//
//  JXAttribute.swift
//  JXFoundation
//
//  Created by Admin on 5/17/20.
//

import UIKit

public enum JXTopBarStyle {
    case none
    case toolbar
    case custom
}

public class JXAttribute: NSObject {
    
    //MARK:color
    public var normalColor = UIColor.darkGray
    public var highlightedColor = UIColor.black
    public var selectedColor = UIColor.darkText
    public var backgroundColor = UIColor.clear
    public var normalBackgroundColor = UIColor.clear
    public var selectedBackgroundColor = UIColor.clear
    public var separatorColor = UIColor.darkGray
    
    //MARK:image
    public var normalImage = ""
    public var highlightedImage = ""
    public var selectedImage = ""
    
    //MARK:font
    public var fontName : String?
    public var normalFontSize : CGFloat = 14 {
        didSet{
            highlightedFontSize = normalFontSize
            selectedFontSize = normalFontSize
        }
    }
    public var highlightedFontSize : CGFloat = 14
    public var selectedFontSize : CGFloat = 14
    
    //MARK:size
    public var itemSize: CGSize = CGSize()
    public var minimumInteritemSpacing : CGFloat = 0
    /// 内容距边框的距离，非负数
    public var contentMarginEdge : UIEdgeInsets =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    /// 内容距边框的距离，带符号
    public var contentEdgeInsets : UIEdgeInsets =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    public var sectionEdgeInsets : UIEdgeInsets =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    //MARK:layer
    public var cornerRadius : CGFloat = 0
    public var borderWidth : CGFloat = 0
    public var borderColor : CGColor = UIColor.clear.cgColor
    
    //MARK:布局
    ///是否使用顶部工具栏：0不使用，1toolbar，2自定义
    public var topBarStyle : Int = 0
    ///是否在X系列底部布局
    public var isUseBottomArea : Bool = false
    
    
    public override init() {
        normalColor = UIColor.darkGray
        highlightedColor = UIColor.black
        selectedColor = UIColor.darkText
        separatorColor = UIColor.darkGray
        backgroundColor = UIColor.clear
        
        normalFontSize = 14
        highlightedFontSize = 14
        selectedFontSize = 14
    }
}
