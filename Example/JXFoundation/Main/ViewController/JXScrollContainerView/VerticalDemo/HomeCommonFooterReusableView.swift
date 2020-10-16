//
//  HomeCommonFooterReusableView.swift
//  Tomatos
//
//  Created by Admin on 9/30/20.
//

import UIKit

class HomeCommonFooterReusableView: UICollectionReusableView {

    @IBOutlet weak var footerBgView: UIView!
    @IBOutlet weak var footerButton: UIButton!{
        didSet{
            footerBgView.layer.cornerRadius = 8
            footerBgView.layer.masksToBounds = true
            
            let layer = CAGradientLayer.init()
            layer.colors = [UIColor.rgbColor(rgbValue:  0xa7a7dc).cgColor, UIColor.rgbColor(rgbValue: 0x414179).cgColor];
            layer.startPoint = CGPoint(x: 0, y: 0);
            layer.endPoint = CGPoint(x: 0, y: 1);
            layer.frame = footerButton.bounds;
            footerButton.layer.insertSublayer(layer, at: 0)
        }
    }
    
    var footerBlock : (()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func footerAction(_ sender: UIButton) {
        if let block = self.footerBlock {
            block()
        }
    }
    
    
}
