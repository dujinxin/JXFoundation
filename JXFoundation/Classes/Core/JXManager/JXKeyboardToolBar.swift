//
//  JXKeyboardToolBar.swift
//  FBSnapshotTestCase
//
//  Created by 杜进新 on 2018/11/10.
//

import UIKit

private let keyWindowWidth : CGFloat = UIScreen.main.bounds.width
private let keyWindowHeight : CGFloat = UIScreen.main.bounds.height

public protocol JXKeyboardTextFieldDelegate: AnyObject {
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}
public protocol JXKeyboardTextViewDelegate: AnyObject {
    func keyboardTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
}

public class JXKeyboardToolBar: UIView, UITextFieldDelegate, UITextViewDelegate {
    
    public typealias KeyboardShowBlock = ((_ keyboardHeight: CGFloat, _ toolBarHeight: CGFloat, _ responderView: UIView)->())
    public typealias KeyboardCloseBlock = (()->())
    
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
    private var keyboardRect = CGRect()
    private var animateDuration = 0.25
    private var isKeyboardShow = false
    private var isUpDownShow : Bool = false
    
    public var upItem : UIBarButtonItem!
    public var downItem : UIBarButtonItem!
    public var titleItem : UIBarButtonItem!
    public var closeItem : UIBarButtonItem!
    
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
        let titles = ["↑","↓","完成"]
        for i in 0..<3 {
            
            let item = UIBarButtonItem(title: titles[i], style: UIBarButtonItem.Style.plain, target: self, action: #selector(changeResponder(_:)))
            item.isEnabled = true
            item.tag = i
            if i == 0 {
                self.upItem = item
            } else if i == 1 {
                self.downItem = item
            } else {
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
            self.upItem?.title = "↑"
            self.downItem?.title = "↓"
            self.upItem?.isEnabled = true
            self.downItem?.isEnabled = true
        } else {
            self.upItem?.title = ""
            self.downItem?.title = ""
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
    
    func beginEditing(_ view: UIView) {
        guard let currentIndex = self.views.firstIndex(of: view) else {
            return
        }
        self.index = currentIndex
        self.textView = self.views[currentIndex]
        
        self.updateStates(editViewAtIndex: currentIndex)
        
        if let v = self.textView as? UITextField {
            self.titleItem.title = self.placeHolder ?? v.placeholder
        } else if let _ = self.textView as? UITextView {
            self.titleItem.title = self.placeHolder ?? ""
        }
        
        
//        if let block = self.showBlock {
//            block(self.keyboardRect.height, self.topBarHeight, self.views[currentIndex])
//        }
    }
}
extension JXKeyboardToolBar {
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
        self.beginEditing(textField)
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
        self.beginEditing(textView)
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let delegate = self.textViewDelegate else { return true }
        return delegate.keyboardTextView(textView, shouldChangeTextIn: range, replacementText: text)
    }
}
