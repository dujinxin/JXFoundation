//
//  MainHeaderReusableView.swift
//  Tomatos
//
//  Created by Admin on 9/30/20.
//

import UIKit

class MainHeaderReusableView: UICollectionReusableView {

    @IBOutlet weak var mainBgView: UIView!{
        didSet{
            mainBgView.layer.cornerRadius = 8
            mainBgView.layer.masksToBounds = true
            
            mainBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerAction)))
        }
    }
    @IBOutlet weak var hotIconImageView: UIImageView!
    @IBOutlet weak var hotTitleImageView: UIImageView!
    @IBOutlet weak var moreLabel: UILabel!
    var headerBlock : (()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc func headerAction() {
        if let block = self.headerBlock {
            block()
        }
    }
    
}
