//
//  JXActivityIndicatorButton.swift
//  JXFoundation_Example
//
//  Created by Admin on 6/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public enum JXPosition {
    case top
    case left
    case right
    case bottom
}

public class JXActivityIndicatorButton: JXView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.stackView)
        
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addSubview(self.stackView)
        
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        setNeedsUpdateConstraints()
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    public override func updateConstraints() {
        super.updateConstraints()
        addConstraint(.init(item: self.stackView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: self,
                            attribute: .centerX,
                            multiplier: 1.0,
                            constant: 0))
        addConstraint(.init(item: self.stackView,
                            attribute: .centerY,
                            relatedBy: .equal,
                            toItem: self,
                            attribute: .centerY,
                            multiplier: 1.0,
                            constant: 0))
    }
    //MARK:public properties & methods
    public var useActivityIndicatorView : Bool = true {
        didSet{
            if useActivityIndicatorView == false {
                self.stackView.removeArrangedSubview(self.activityIndicatorView)
            }
        }
    }
    
    public var position: JXPosition = .left {
        didSet {
            switch position {
            case .left, .right:
                self.stackView.axis = .horizontal
            default:
                self.stackView.axis = .vertical
            }
            
            switch position {
            case .bottom, .right:
                self.stackView.removeArrangedSubview(self.activityIndicatorView)
                self.stackView.addArrangedSubview(self.activityIndicatorView)
            default:
                self.stackView.removeArrangedSubview(self.activityIndicatorView)
                self.stackView.insertArrangedSubview(self.activityIndicatorView, at: 0)
            }
        }
    }
    public var space: CGFloat = 5.0 {
        didSet {
            if #available(iOS 11.0, *), self.stackView.arrangedSubviews.count > 0 {
                self.stackView.setCustomSpacing(space, after: self.stackView.arrangedSubviews[0])
            } else {
                self.stackView.spacing = space
            }
        }
    }
    public var normalTitle : String = "" {
        didSet{
            self.button.setTitle(normalTitle, for: .normal)
        }
    }
    public var selectedTitle : String = "" {
        didSet{
            self.button.setTitle(selectedTitle, for: .selected)
        }
    }
    public var style : UIActivityIndicatorView.Style = .white {
        didSet{
            self.activityIndicatorView.style = style
        }
    }
    public var clickBlock : JXClickBlock?
    //MARK:private properties & methods
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.addArrangedSubview(self.activityIndicatorView)
        stackView.addArrangedSubview(self.button)
      
        stackView.alignment = .center
        return stackView
    }()
    
    
    public lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside)
        return button
    }()
    public lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.style = .white
        return activity
    }()
    
    @objc func buttonAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        
        if btn.isSelected && self.useActivityIndicatorView {
            self.activityIndicatorView.startAnimating()
        } else {
            self.activityIndicatorView.stopAnimating()
        }
        if let block = self.clickBlock {
            block(self, btn.isSelected)
        }
    }
}
