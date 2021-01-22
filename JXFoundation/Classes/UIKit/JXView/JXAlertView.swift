//
//  JXAlertView.swift
//  Tomatos
//
//  Created by Admin on 6/2/20.
//

import UIKit

public class JXAlertView: UIView {
    
    @IBOutlet public weak var shadowView: UIView!
    
    @IBOutlet public weak var contentView: UIView!{
        didSet{
            contentView.layer.cornerRadius = 8
            contentView.layer.masksToBounds = true
            contentView.backgroundColor = UIColor.white
        }
    }
    @IBOutlet public weak var topStackView: UIStackView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var contentLabel: UILabel!
    
    @IBOutlet public weak var buttonStackView: UIStackView!
    @IBOutlet public weak var cancelButton: JXActivityIndicatorButton!{
        didSet{
            cancelButton.layer.cornerRadius = 4
            cancelButton.layer.masksToBounds = true

            cancelButton.normalTitle = ""
            cancelButton.useActivityIndicatorView = false
            cancelButton.backgroundColor = UIColor.rgbColor(rgbValue: 0xcecece)
            cancelButton.clickBlock = {(_,_) in

                if let block = self.cancelBlock {
                    block()
                }
                self.dismiss()
            }
        }
    }
    @IBOutlet public weak var confirmButton: JXActivityIndicatorButton! {
        didSet{
            confirmButton.layer.cornerRadius = 4
            confirmButton.layer.masksToBounds = true

            confirmButton.normalTitle = ""
            confirmButton.position = .left
            confirmButton.style = .white
            confirmButton.useActivityIndicatorView = false
            confirmButton.backgroundColor = UIColor.systemPink

            confirmButton.clickBlock = {(_,_) in

                if let block = self.nextBlock {
                    block()
                    return
                }
                if let block = self.confirmBlock {
                    block()
                }
                self.dismiss()
            }
        }
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    public class func initWithTitle(_ title: String?, content: String?, cancelTitle: String = "", confirmTitle: String) -> JXAlertView {
        
        guard let alert = Bundle.init(for: self).loadNibNamed("JXAlertView", owner: nil, options: nil)?.last as? JXAlertView else {
            assertionFailure("JXAlertView nib 文件缺失")
            return JXAlertView()
        }
        
        alert.titleLabel.text = title
        alert.contentLabel.text = content
        
        if let title = title, title.isEmpty == true {
            alert.topStackView.removeArrangedSubview(alert.titleLabel)
        }
        if let content = content, content.isEmpty == true {
            alert.topStackView.removeArrangedSubview(alert.contentLabel)
        }
        
        alert.cancelButton.normalTitle = cancelTitle
        alert.confirmButton.normalTitle = confirmTitle
        
        if cancelTitle.isEmpty == true {
            alert.cancelButton.isHidden = true
            alert.buttonStackView.removeArrangedSubview(alert.cancelButton)
        }
        return alert
    }
    
    public override class func awakeFromNib() {
        
    }
    
    @IBOutlet weak var actiontop: NSLayoutConstraint!
    @IBOutlet weak var actionLeading: NSLayoutConstraint!
    @IBOutlet weak var actionTrailing: NSLayoutConstraint!
    @IBOutlet weak var actionBottom: NSLayoutConstraint!
    
    //MARK:public properties & methods
    /// contentMarginEdge:  default（16，16，16，16）
    public var contentMarginEdge: UIEdgeInsets = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16) {
        didSet{
            self.actiontop.constant = CGFloat(fabsf(Float(contentMarginEdge.top)))
            self.actionLeading.constant = CGFloat(fabsf(Float(contentMarginEdge.left)))
            self.actionBottom.constant = CGFloat(fabsf(Float(contentMarginEdge.bottom)))
            self.actionTrailing.constant = CGFloat(fabsf(Float(contentMarginEdge.right)))
        }
    }
    
    public var attribute : JXAttribute? {
        didSet{
            guard let attribute = attribute else { return }
            self.buttonStackView.spacing = attribute.minimumInteritemSpacing
            self.contentMarginEdge = attribute.contentMarginEdge
        }
    }
    public var useActivityIndicatorView: Bool = false {
        didSet{
            self.confirmButton.useActivityIndicatorView = useActivityIndicatorView
        }
    }
    @objc public var cancelBlock : (()->())?
    @objc public var confirmBlock : (()->())?
    @objc public var nextBlock : (()->())?
    
    @objc public func show() {
        self.showInView(nil)
    }
    @objc public func showInView(_ view: UIView?) {
        if let _ = self.superview {
            self.removeFromSuperview()
        }
        if let view = view {
            view.addSubview(self)
            self.center = view.center;
        } else {
            UIApplication.shared.keyWindow?.addSubview(self)
            self.center = UIApplication.shared.keyWindow?.center ?? CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        }
        self.shadowView.alpha = 0
        self.contentView.transform = self.contentView.transform.scaledBy(x: 0.1,y: 0.1)
        UIView.animate(withDuration: 0.3, animations: {
            
            self.contentView.transform = CGAffineTransform.identity
            self.shadowView.alpha = 0.4
        }) { (isFinish) in
            
        }
    }
    public func dismiss() {
        if let _ = self.superview {
            UIView.animate(withDuration: 0.3, animations: {
                
                self.contentView.transform = self.contentView.transform.scaledBy(x: 0.1,y: 0.1)
                self.shadowView.alpha = 0.0
            }) { (isFinish) in
                if isFinish { self.removeFromSuperview() }
            }
        }
    }
}



