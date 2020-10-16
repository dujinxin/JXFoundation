//
//  ChannelReusableView.swift
//  Tomatos
//
//  Created by Admin on 5/6/20.
//

import UIKit

class ChannelReusableView: UICollectionReusableView {

    @IBOutlet weak var mainView: UIView! {
        didSet{
            mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickAction(tap:))))
        }
    }

    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var detailView: UILabel!
    
    var clickBlock : ((_ index: Int)->())?
    
    @objc func clickAction(tap: UITapGestureRecognizer) {
        if let block = self.clickBlock, let v = tap.view {
            block(v.tag)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
