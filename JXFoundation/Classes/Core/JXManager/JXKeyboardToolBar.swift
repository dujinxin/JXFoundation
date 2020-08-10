//
//  JXKeyboardToolBar.swift
//  FBSnapshotTestCase
//
//  Created by 杜进新 on 2018/11/10.
//

import UIKit

private let keyWindowWidth : CGFloat = UIScreen.main.bounds.width
private let keyWindowHeight : CGFloat = UIScreen.main.bounds.height

public typealias KeyboardShowBlock = ((_ keyboardHeight: CGFloat, _ toolBarHeight: CGFloat, _ responderView: UIView)->())
public typealias KeyboardCloseBlock = (()->())

public protocol JXKeyboardTextFieldDelegate: AnyObject {
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}
public protocol JXKeyboardTextViewDelegate: AnyObject {
    func keyboardTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
}

public class JXKeyboardToolBar: UIView, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: public properties
    public var showBlock: KeyboardShowBlock?
    public var closeBlock: KeyboardCloseBlock?
    public weak var textFieldDelegate: JXKeyboardTextFieldDelegate?
    public weak var textViewDelegate: JXKeyboardTextViewDelegate?
    public var views: Array<UIView> = [] {
        didSet {
            if views.count > 1 {
                self.updown(true)
            } else {
                self.updown(false)
            }
        }
    }
    public var index: Int = 0
    
    public var text: String? {
        didSet {
            //self.textView.text = text
        }
    }
    public var useTitleNotice = false {
        didSet {
            self.titleItem.title = useTitleNotice == true ? placeHolder : ""
        }
    }
    public var placeHolder: String? {
        didSet {
            self.titleItem.title = placeHolder
        }
    }
    public var keyBoardHeight: CGFloat = 0
    public var topBarHeight: CGFloat = 49 {
        didSet {
            self.toolBar.frame = CGRect(x: toolEdgeInsets.left, y: toolEdgeInsets.top, width: keyWindowWidth - toolEdgeInsets.left - toolEdgeInsets.right, height: topBarHeight - toolEdgeInsets.top - toolEdgeInsets.bottom)
        }
    }
    
    public override var tintColor: UIColor! {
        didSet{
            self.toolBar.tintColor = tintColor
        }
    }
    //MARK:public methods
    
    //MARK: private properties
    private var textView : UIView!
    private var keyboardType: UIKeyboardType = .twitter
    private var keyboardRect = CGRect()
    private var animateDuration = 0.25
    private var isKeyboardChanged: Bool = true
    private var isKeyboardShow = false
    private var isUpDownShow : Bool = false
    
    private var upItem : UIBarButtonItem!
    private var downItem : UIBarButtonItem!
    private var titleItem : UIBarButtonItem!
    private var closeItem : UIBarButtonItem!
    
    public var toolEdgeInsets : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet{
            self.toolBar.frame = CGRect(x: toolEdgeInsets.left, y: toolEdgeInsets.top, width: UIScreen.main.bounds.width - toolEdgeInsets.left - toolEdgeInsets.right, height: topBarHeight - toolEdgeInsets.top - toolEdgeInsets.bottom)
        }
    }
    
    public lazy var toolBar: UIToolbar = {
        let tool = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 49))
        //tool.translatesAutoresizingMaskIntoConstraints = false
     
        //tool.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        var items = [UIBarButtonItem]()
        let titles = ["JXFoundationBarArrowUp","JXFoundationBarArrowDown",Bundle.main.jxLocalizedString(forKey: "Done")]
        
        
        
        guard let path = Bundle.init(for: type(of: self)).path(forResource: "JXFoundation", ofType: "bundle"), let bundle = Bundle.init(path: path) else {
            assertionFailure("获取JXFoundation bundle文件失败！")
            return tool
        }
        
        for i in 0..<3 {
            
            var item: UIBarButtonItem!
            if #available(iOS 13.0, *) {
                item = UIBarButtonItem.init(image: UIImage(named: titles[i], in: bundle, with: .none), style: .plain, target: self, action: #selector(changeResponder(_:)))
            } else {
                item = UIBarButtonItem.init(image: UIImage(named: titles[i], in: bundle, compatibleWith: nil), style: .plain, target: self, action: #selector(changeResponder(_:)))
            }
            item.isEnabled = true
            item.tag = i
            if i == 0 {
                self.upItem = item
            } else if i == 1 {
                self.downItem = item
            } else {
                let item = UIBarButtonItem(title: titles[i], style: .plain, target: self, action: #selector(changeResponder(_:)))
                item.tag = 2
                self.closeItem = item
            }
            items.append(item)
        }
        /**
             —————————————————————————————
             | 5 ↑ 5 ↓ ---title--- 完成 5 |
             —————————————————————————————
         */
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        space.width = 5
        
        let item = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        item.isEnabled = false
        self.titleItem = item
        
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        //tool.items = items
        tool.items = [space,self.upItem,space,self.downItem,flexibleSpace,self.titleItem,flexibleSpace,self.closeItem,space]
        
        return tool
    }()
    
    //MARK:system methods
    public init(frame: CGRect = CGRect(), views: Array<UIView> = []) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.groupTableViewBackground
        self.setKeyBoardObserver()
        self.addSubview(self.toolBar)
        self.views = views
        if views.count > 1 {
            self.updown(true)
        } else {
            self.updown(false)
        }
        self.setupDelegate()
        
        self.frame = CGRect(x: 0, y: keyWindowHeight, width: keyWindowWidth, height: topBarHeight)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.toolBar.frame = CGRect(x: toolEdgeInsets.left, y: toolEdgeInsets.top, width: keyWindowWidth - toolEdgeInsets.left - toolEdgeInsets.right, height: topBarHeight - toolEdgeInsets.top - toolEdgeInsets.bottom)
    }
    //MARK:private methods
    
    func setKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notify:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notify:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    func setupDelegate() {
        self.views.forEach { (v) in
            if v is UITextField, let textField = v as? UITextField{
                textField.delegate = self
            } else if v is UITextView, let textView = v as? UITextView{
                textView.delegate = self
            }
        }
    }
    @objc private func changeResponder(_ item: UIBarButtonItem) {
        if self.views.isEmpty { return }
        
        if item.tag == 2 {
            
            let v = self.views[self.index]
            if v is UITextField, let textField = v as? UITextField, textField.isFirstResponder == true {
                textField.resignFirstResponder()
            } else if v is UITextView, let textView = v as? UITextView, textView.isFirstResponder == true {
                textView.resignFirstResponder()
            }
            //关闭block
            if let block = self.closeBlock {
                block()
            }
        } else {
            if isUpDownShow == false {
                return
            }
         
            if item.tag == 0 {
                self.index -= 1
            } else if item.tag == 1 {
                self.index += 1
            }
            let v = self.views[self.index]
            if v is UITextField, let textField = v as? UITextField, textField.isFirstResponder == false {
          
                textField.becomeFirstResponder()
            } else if v is UITextView, let textView = v as? UITextView, textView.isFirstResponder == false {
                
                textView.becomeFirstResponder()
            }
        }
        
    }
    func updown(_ isShow: Bool) {
        self.isUpDownShow = isShow
        if isShow {
            self.upItem?.isEnabled = true
            self.downItem?.isEnabled = true
        } else {
            self.upItem?.isEnabled = false
            self.downItem?.isEnabled = false
        }
    }
    func updateStates(editViewAtIndex index: Int) {
       
        if self.isUpDownShow == false {
            return
        }
        if index == 0 {
            self.upItem?.isEnabled = false
            self.downItem?.isEnabled = true
        } else if index == self.views.count - 1 {
            self.downItem?.isEnabled = false
            self.upItem?.isEnabled = true
        } else {
            self.downItem?.isEnabled = true
            self.upItem?.isEnabled = true
        }
    }
    
    
}
extension JXKeyboardToolBar {
    func didBeginEditing(_ view: UIView) {
        
        self.textView = view
        
        guard let currentIndex = self.views.firstIndex(of: view) else {
            return
        }
        self.index = currentIndex
        
        self.updateStates(editViewAtIndex: currentIndex)
        
        if let v = view as? UITextField {
            self.titleItem.title = Bundle.main.jxLocalizedString(forKey: "\(self.placeHolder ?? v.placeholder ?? "")")
            
            self.isKeyboardChanged = !(self.keyboardType == v.keyboardType)
            self.keyboardType = v.keyboardType
        } else if let v = view as? UITextView {
            self.titleItem.title = Bundle.main.jxLocalizedString(forKey: "\(self.placeHolder ?? "")")
            
            self.isKeyboardChanged = !(self.keyboardType == v.keyboardType)
            self.keyboardType = v.keyboardType
        }
        
        if self.isKeyboardChanged == false, let block = self.showBlock {
            block(self.keyboardRect.height, self.topBarHeight, view)
        }
    }
    //直接切换第一响应者，并且键盘类型没有变化的话，不会发送这个通知
    //解决方法：
    //配合代理方法 textFieldDidBeginEditing & textViewDidBeginEditing 来保证每次切换输入框都会有回调
    //首先，第一次弹出键盘，
         //ps:一定会调用，所以第一次在通知里回调
    //以后，使用代理还是通知来回调，要根据键盘类型是否变化来决定
         //ps:假如键盘无变化，那上次拿到的键盘高度也是无变化的，所以不会有先回调，后取值，导致回调传值错误的问题.
         //ps:假如键盘有变化，那么使用通知，要重新获取键盘高度
    @objc func keyboardWillShow(notify:Notification) {
        print("JXKeyboardToolBar.Keyboard = ","show")
        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        self.animateDuration = animationDuration
        self.keyboardRect = rect
       
        if let block = self.showBlock {
            block(self.keyboardRect.height, self.topBarHeight, self.textView)
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.frame = CGRect(x: 0, y: keyWindowHeight - self.topBarHeight - self.keyboardRect.height, width: keyWindowWidth, height: self.topBarHeight + self.keyboardRect.height)
        }) { (finish) in
            //
        }
    }
    @objc func keyboardWillHide(notify:Notification) {
        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        self.isKeyboardChanged = true
        self.keyboardRect = rect
        UIView.animate(withDuration: animationDuration, animations: {
            self.frame = CGRect.init(x: 0, y: keyWindowHeight, width: keyWindowWidth, height: self.topBarHeight + self.keyboardRect.height)
        }) { (finish) in
            
        }
    }
    @objc func keyboardDidShow(notify:Notification) {
        self.isKeyboardShow = true
    }
    @objc func keyboardDidHide(notify:Notification) {
        self.isKeyboardShow = false
    }
}
//MARK:UITextFieldDelegate
extension JXKeyboardToolBar {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.didBeginEditing(textField)
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let delegate = self.textFieldDelegate else { return true }
        return delegate.keyboardTextFieldShouldReturn(textField)
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let delegate = self.textFieldDelegate else { return true }
        return delegate.keyboardTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}
//MARK:UITextViewDelegate
extension JXKeyboardToolBar {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.didBeginEditing(textView)
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let delegate = self.textViewDelegate else { return true }
        return delegate.keyboardTextView(textView, shouldChangeTextIn: range, replacementText: text)
    }
}
