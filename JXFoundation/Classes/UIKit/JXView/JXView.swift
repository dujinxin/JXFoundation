//
//  JXView.swift
//  Star
//
//  Created by 杜进新 on 2018/5/31.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

open class JXView: UIView {
    
    public typealias JXSelectedBlock = ((_ view: UIView, _ index: Int) -> ())
    public typealias JXClickBlock = ((_ view: UIView,_ object: Any) -> ())
    
}
open class JXButton: UIButton {
    
    public typealias JXSelectedBlock = ((_ view: UIView, _ index: Int) -> ())
    public typealias JXClickBlock = ((_ view: UIView,_ object: Any) -> ())
    
}
open class JXLabel: UILabel {
    
    public typealias JXSelectedBlock = ((_ view: UIView, _ index: Int) -> ())
    public typealias JXClickBlock = ((_ view: UIView,_ object: Any) -> ())
    
}
open class JXImageView: UIImageView {
    
    public typealias JXSelectedBlock = ((_ view: UIView, _ index: Int) -> ())
    public typealias JXClickBlock = ((_ view: UIView,_ object: Any) -> ())
    
}

open class JXTableViewCell: UITableViewCell {
    
    public typealias JXSelectedBlock = ((_ view: UIView, _ index: Int) -> ())
    public typealias JXClickBlock = ((_ view: UIView,_ object: Any) -> ())
    
}

open class JXCollectionViewCell: UICollectionViewCell {
    
    public typealias JXSelectedBlock = ((_ view: UIView, _ index: Int) -> ())
    public typealias JXClickBlock = ((_ view: UIView,_ object: Any) -> ())
    
}

open class JXCollectionReusableView: UICollectionReusableView {
    
    public typealias JXSelectedBlock = ((_ view: UIView, _ index: Int) -> ())
    public typealias JXClickBlock = ((_ view: UIView,_ object: Any) -> ())
    
}

open class JXTableView: UITableView,UIGestureRecognizerDelegate {
    
    public typealias JXSelectedBlock = ((_ view: UIView, _ index: Int) -> ())
    public typealias JXClickBlock = ((_ view: UIView,_ object: Any) -> ())
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
