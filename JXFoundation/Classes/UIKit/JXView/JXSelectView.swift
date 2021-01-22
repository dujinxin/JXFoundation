//
//  JXSelectView.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/25.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit


public enum JXSelectViewStyle : Int {
    case pick
    case list   //1.如果想要自定义cell，请注册继承JXSelectListViewCell的子类,标识符为reuseIdentifierCustom；否则使用默认样式。 2.高度分为固定高度和由内容自动撑开高度两种，前者适用通用，只是数据较多时，列表可滑动展示；后者则不可滑动，当然内容不能超过一屏
    
    case custom
}
public enum JXSelectViewShowPosition {
    case middle
    case bottom
}

public enum JXSelectViewListHeightStyle {
    case fixed    //固定高度
    case freedom  //内容自动撑开
}

private let reuseIdentifier = "reuseIdentifier"

private let topBarHeight : CGFloat = 49
private let animateDuration : TimeInterval = 0.3

public class JXSelectView: UIView {

    private var alertViewTopHeight : CGFloat = 0
    
    public var title : String?
    public var message : String?
    public var closeItemWidth : CGFloat = 44
    
    var actions : Array<String> = [String](){
        didSet{
            if actions.count > 5 {
                self.tableView.isScrollEnabled = true
                self.tableView.bounces = true
                self.tableView.showsVerticalScrollIndicator = true
            }else{
                self.tableView.isScrollEnabled = false
                self.tableView.bounces = false
                self.tableView.showsVerticalScrollIndicator = false
            }
            self.resetFrame()
        }
    }
    public lazy var attribute : JXAttribute = {
        let att = JXAttribute()
        //固定宽度270，居中
        if self.position == .middle {
            att.sectionEdgeInsets = UIEdgeInsets.init(top: 0, left: (kScreenWidth - 270) / 2, bottom: 0, right: -(kScreenWidth - 270) / 2)
        } else {
            att.sectionEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        }
        return att
    }()
    
    public var delegate : JXSelectViewDelegate?
    public var style : JXSelectViewStyle = .custom
    public var position : JXSelectViewShowPosition = .middle {
        didSet{
            //固定宽度270，居中
            if position == .middle {
                self.attribute.sectionEdgeInsets = UIEdgeInsets.init(top: 0, left: (kScreenWidth - 270) / 2, bottom: 0, right: -(kScreenWidth - 270) / 2)
            } else {
                self.attribute.sectionEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    /// 选项列表高度类型
    public var listHeightStyle : JXSelectViewListHeightStyle = .fixed
    /// 固定高度 listHeightStyle 为.fixed 起作用
    public var fixedHeight : CGFloat = 400
    /// 选项列表高度
    public var listHeight : CGFloat = 44
    /// 选中的行
    public var selectRow : Int = -1
    /// 内容高度
    public var contentHeight : CGFloat = 0 {
        didSet{
            //self.resetFrame(height: contentHeight)
        }
    }
    /// 背景是否可以点击消失
    public var isShadowBgViewEnabled : Bool = true
    /// 选择后是否自动消失
    public var isAutoDismiss : Bool = true
    /// 是否可以滚动
    public var isScrollEnabled : Bool = false {
        didSet{
            if isScrollEnabled == true {
                self.tableView.isScrollEnabled = true
                self.tableView.bounces = true
                self.tableView.showsVerticalScrollIndicator = true
            }else{
                self.tableView.isScrollEnabled = false
                self.tableView.bounces = false
                self.tableView.showsVerticalScrollIndicator = false
            }
        }
    }
    
    //MARK: subViews
    var topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private var titleItem : UILabel!
    private var closeItem : UIButton!
    
    public var toolEdgeInsets : UIEdgeInsets = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 0) {
        didSet{
            self.toolBar.frame = CGRect(x: toolEdgeInsets.left, y: toolEdgeInsets.top, width: UIScreen.main.bounds.width - toolEdgeInsets.left - toolEdgeInsets.right, height: topBarHeight - toolEdgeInsets.top - toolEdgeInsets.bottom)
        }
    }
    
    /**
        —————————————————————————————
        | left ---title--- x right |
        —————————————————————————————
    */
    ///toolBar 如果想要title居中，请自行调整toolEdgeInsets，closeWidth，或者直接修改titleItem和closeItem的frame
    public lazy var toolBar: UIView = {
        let tool = UIView(frame: CGRect(x: toolEdgeInsets.left, y: toolEdgeInsets.top, width: UIScreen.main.bounds.width - toolEdgeInsets.left - toolEdgeInsets.right, height: topBarHeight - toolEdgeInsets.top - toolEdgeInsets.bottom))
        tool.backgroundColor = UIColor.clear
        //tool.backgroundColor = UIColor.green
        
        let titles = [self.title ?? ""," ✕ "]
        
        for i in 0..<2 {
            
            if i == 0 {
                let lab = UILabel()
                //lab.backgroundColor = UIColor.blue
                lab.textAlignment = .center
                lab.font = UIFont.systemFont(ofSize: 16)
                lab.textColor = .darkText
                lab.text = titles[i]
                self.titleItem = lab
                tool.addSubview(lab)
            } else {
                let btn = UIButton()
                //btn.backgroundColor = UIColor.red
                btn.setTitle(titles[i], for: UIControl.State.normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                btn.setTitleColor(UIColor.darkText, for: .normal)
                btn.addTarget(self, action: #selector(tapClick), for: UIControl.Event.touchUpInside)
                
                self.closeItem = btn
                tool.addSubview(btn)
            }
        }
        
        return tool
    }()
    ///主内容视图
    private var contentView : UIView?
    ///自定义视图
    public var customView: UIView? {
        didSet{
            self.contentView = customView
            self.contentHeight = customView?.frame.height ?? 0
        }
    }
    ///.list 视图
    lazy var tableView : UITableView = {
        let table = UITableView.init(frame: CGRect.init(), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        table.bounces = false
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.separatorStyle = .none
        table.register(JXSelectListViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return table
    }()
    ///背景视图
    public lazy var backgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy private var bgWindow : UIWindow = {
        let window = UIWindow()
        window.frame = UIScreen.main.bounds
        window.windowLevel = UIWindow.Level.alert + 1
        window.backgroundColor = UIColor.clear
        window.isHidden = false
        return window
    }()
    
    lazy private var bgView : UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = UIColor.black
        view.alpha = 0
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    //MARK: init methods
    public init(frame: CGRect, style:JXSelectViewStyle) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.style = style
        self.addSubview(self.backgroundView)
        if style == .list {
            self.contentView = self.tableView
            self.contentHeight = fixedHeight
        } else if style == .custom {
            //在customView中设定
        } else if style == .pick {
            self.contentView = self.tableView
            self.contentHeight = frame.height
        }
        
    }
    public init(frame: CGRect, customView: UIView) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.addSubview(self.backgroundView)
        self.style = .custom
        self.contentView = customView
        
        self.contentHeight = customView.frame.height
        
    }
  
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    //MARK: public methods
    func resetFrame(height: CGFloat = 0.0) {
        var totalHeight : CGFloat = 0
        var contentHeight : CGFloat = 0
        
        if height > 0 {
            contentHeight = height
        } else {
            if style == .list{
                
                if listHeightStyle == .fixed {
                    contentHeight = self.fixedHeight
                } else {
                    if let delegate = self.delegate {
                        contentHeight = listHeight * CGFloat(delegate.jxSelectView?(self, numberOfRowsInSection: 0) ?? 0)
                    }
                }
                contentHeight = contentHeight == 0 ? totalHeight : self.fixedHeight
            } else if style == .pick {
                
            } else {
                contentHeight = self.customView?.frame.height ?? 0
            }
            
        }
        totalHeight = contentHeight
        
        let width = kScreenWidth - CGFloat(fabsf(Float(attribute.sectionEdgeInsets.left))) - CGFloat(fabsf(Float(attribute.sectionEdgeInsets.right)))
        //topBarView frame
        if self.attribute.topBarStyle > 0 {
            self.topBarView.frame = CGRect(x: 0, y: 0, width: width, height: topBarHeight)
            
            if self.topBarView.superview == nil {
                self.addSubview(self.topBarView)
                if self.toolBar.superview == nil {
                    self.topBarView.addSubview(self.toolBar)
                }
                if self.attribute.topBarStyle == 1 {
                    self.toolBar.frame = CGRect(x: toolEdgeInsets.left, y: toolEdgeInsets.top, width: width - toolEdgeInsets.left - toolEdgeInsets.right, height: topBarHeight - toolEdgeInsets.top - toolEdgeInsets.bottom)
                    self.titleItem.frame = CGRect(x: 0, y: 0, width: self.toolBar.bounds.width - closeItemWidth, height: self.toolBar.bounds.height)
                    self.closeItem.frame = CGRect(x: self.titleItem.bounds.width, y: 0, width: closeItemWidth, height: self.toolBar.bounds.height)
                }
            }
            
            alertViewTopHeight = self.topBarView.bounds.height
            totalHeight += self.topBarView.bounds.height
        }
        if self.attribute.isUseBottomArea == true && self.position == .bottom {
            totalHeight += kBottomMaginHeight
        }
        //self frame
        self.frame = CGRect(x: self.attribute.sectionEdgeInsets.left, y: 0, width: width, height: totalHeight)
        //backgroundView frame
        self.backgroundView.frame = self.bounds
        //contentView frame
        self.contentView?.frame = CGRect(x: CGFloat(fabsf(Float(attribute.contentMarginEdge.left))), y: alertViewTopHeight + CGFloat(fabsf(Float(attribute.contentMarginEdge.top))), width: width - CGFloat(fabsf(Float(attribute.contentMarginEdge.left))) - CGFloat(fabsf(Float(attribute.contentMarginEdge.right))), height: contentHeight - CGFloat(fabsf(Float(attribute.contentMarginEdge.top))) - CGFloat(fabsf(Float(attribute.contentMarginEdge.bottom))))
    }
    
    public func reloadData() {
        if self.style == .list {
            self.tableView.reloadData()
        } else if self.style == .pick {
            
        } else {
            
        }
    }
    public func show() {
        self.show(inView: self.bgWindow)
    }
    
    public func show(inView view: UIView? ,animate: Bool = true) {
        
        self.addSubview(self.contentView!)
        self.resetFrame(height: contentHeight)
        
        
        let superView : UIView
        
        if let v = view {
            superView = v
        } else {
            superView = self.bgWindow
        }
       
        let center = superView.center
        
        if position == .bottom {
            var frame = self.frame
            frame.origin.y = superView.frame.height
            self.frame = frame
        } else {
            self.center = center
        }
        if isShadowBgViewEnabled {
            superView.addSubview(self.bgView)
        }
        
        superView.addSubview(self)
        superView.isHidden = false
        
        if animate {
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: .curveEaseIn, animations: {
                self.bgView.alpha = 0.5
                if self.position == .bottom {
                    var frame = self.frame
                    frame.origin.y = superView.frame.height - self.frame.height
                    self.frame = frame
                }else{
                    self.center = center
                }
            }, completion: { (finished) in
                if self.style == .list {
                    self.tableView.reloadData()
                } else if self.style == .pick {

                }
            })
        }
    }
    public func dismiss(animate:Bool = true) {
        
        if animate {
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: .curveEaseOut, animations: {
                self.bgView.alpha = 0.0
                if self.position == .bottom {
                    var frame = self.frame
                    frame.origin.y = self.superview!.frame.height
                    self.frame = frame
                }else{
                    self.center = self.superview!.center
                }
            }, completion: { (finished) in
                self.clearInfo()
            })
        }else{
            self.clearInfo()
        }
    }
    
    fileprivate func clearInfo() {
        bgView.removeFromSuperview()
        self.removeFromSuperview()
        bgWindow.isHidden = true
        
    }
    @objc func clickAction(item: UIBarButtonItem) {
        switch item.tag {
        case 0:
            self.dismiss()
        case 1:
            ()
        case 2:
            self.dismiss()
        default:
            ()
        }
    }
    @objc func tapClick() {
        self.dismiss()
    }
    fileprivate func viewDisAppear(row:Int) {
//        if self.delegate != nil && selectRow >= 0{
//            self.delegate?.jxSelectView(self, didSelectRowAt: row)
//        }
        self.dismiss()
    }
}
extension JXSelectView : UITableViewDelegate,UITableViewDataSource {
    
    ///注册自定义list内容，二选一 ,标识符设置为 reuseIdentifierCustom
    public func register(_ nib: UINib?, _ cellClass: AnyClass?, forCellReuseIdentifier identifier: String = "reuseIdentifierCustom") {
        if let nib = nib {
            self.tableView.register(nib, forCellReuseIdentifier: identifier)
        } else  if let cellClass = cellClass {
            self.tableView.register(cellClass.self, forCellReuseIdentifier: identifier)
        } else {
            assertionFailure("nib 或 cellClass 必须有一个不为空")
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let delegate = self.delegate {
            return delegate.jxSelectView?(self, numberOfRowsInSection: section) ?? actions.count
        }
        return 0
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let delegate = self.delegate {
            return delegate.jxSelectView?(self, heightForRowAt: indexPath) ?? listHeight
        }
        return listHeight
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCustom") {
            if let delegate = self.delegate {
                return  delegate.jxSelectView?(tableView, cellForRowAt: indexPath) ?? cell
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! JXSelectListViewCell
            if let delegate = self.delegate {
                cell.titleLabel.text = delegate.jxSelectView?(self, StringForRowAt: indexPath) ?? ""
            }
            return cell
        }
    
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        if isUseTopBar {
//            selectRow = indexPath.row
//        }else{
//            self.viewDisAppear(row: indexPath.row)
//        }
        
        //self.delegate?.willPresentJXSelectView!(self)
        self.delegate?.jxSelectView(self, clickButtonAtIndex: indexPath.row)
        if isAutoDismiss {
            self.dismiss()
        }
        
        //self.delegate?.didPresentJXSelectView!(self)
    }
}

open class JXSelectListViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgbColor(rgbValue: 0x333333)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.separatorView)
        self.layoutSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = CGRect.init(x: 15, y: 0, width: self.bounds.width - 30, height: self.bounds.height)
        self.separatorView.frame = CGRect.init(x: 0, y: self.bounds.height - 0.5, width: self.bounds.width, height: 0.5)
    }
}

@objc public protocol JXSelectViewDelegate {
    
    func jxSelectView(_ selectView: JXSelectView, clickButtonAtIndex index:Int)
    @objc optional func jxSelectView(_ selectView: JXSelectView, numberOfRowsInSection section: Int) -> Int
    @objc optional func jxSelectView(_ selectView: JXSelectView, heightForRowAt indexPath: IndexPath) -> CGFloat
    @objc optional func jxSelectView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> JXSelectListViewCell
    @objc optional func jxSelectView(_ selectView: JXSelectView, StringForRowAt indexPath: IndexPath) -> String
    
    @objc optional func jxSelectViewCancel(_ :JXSelectView)
    @objc optional func willPresentJXSelectView(_ :JXSelectView)
    @objc optional func didPresentJXSelectView(_ :JXSelectView)
    
}
