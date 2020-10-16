//
//  MainContentCell.swift
//  Tomatos
//
//  Created by Admin on 9/30/20.
//

import UIKit

class MainContentCell: UICollectionViewCell {

    @IBOutlet weak var mainBgView: UIView!{
        didSet{
            mainBgView.layer.cornerRadius = 8
            mainBgView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainIconView: UIImageView!
    
    //zone_video_icon
    //zone_image_icon
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
