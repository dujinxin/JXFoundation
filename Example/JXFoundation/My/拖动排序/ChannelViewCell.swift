//
//  ChannelViewCell.swift
//  Tomatos
//
//  Created by Admin on 5/6/20.
//

import UIKit
import JXFoundation

class ChannelViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bgView: UIView!{
        didSet{
            bgView.layer.cornerRadius = 4
            bgView.layer.borderColor = UIColor.rgbColor(rgbValue: 0x979797).cgColor
            bgView.layer.borderWidth = 0
        }
    }
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var statusView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
