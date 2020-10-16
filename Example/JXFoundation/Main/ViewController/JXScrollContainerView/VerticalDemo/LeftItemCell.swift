//
//  LeftItemCell.swift
//  Tomatos
//
//  Created by Admin on 9/29/20.
//

import UIKit

class LeftItemCell: UITableViewCell {

    @IBOutlet weak var itemBackView: UIView!{
        didSet{
            itemBackView.layer.cornerRadius = 8
            itemBackView.layer.masksToBounds = true
            
            let layer = CAGradientLayer.init()
            layer.colors = [UIColor.rgbColor(rgbValue: 0xa7a7dc).cgColor, UIColor.rgbColor(rgbValue: 0x414179).cgColor];
            layer.startPoint = CGPoint(x: 0, y: 0);
            layer.endPoint = CGPoint(x: 0, y: 1);
            layer.frame = itemBackView.bounds;
            itemBackView.layer.insertSublayer(layer, at: 0)
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textLabelView: UILabel!
    
    var imageStr: String? {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        itemBackView.backgroundColor = UIColor.rgbColor(rgbValue: 0x3F3F68)
        textLabelView.textColor = UIColor.rgbColor(rgbValue: 0x7E7EB6)
        textLabelView.font = UIFont(name: "PingFangSC-Regular", size: 10)
        iconImageView.image = UIImage(named: (imageStr ?? "") + "normal")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected {
            itemBackView.backgroundColor = UIColor.rgbColor(rgbValue:  0xA7A7DC)
            textLabelView.textColor = UIColor.rgbColor(rgbValue: 0xffffff)
            textLabelView.font = UIFont(name: "PingFangSC-Regular", size: 12)
            iconImageView.image = UIImage(named: (imageStr ?? "") + "selected")
        } else {
            itemBackView.backgroundColor = UIColor.rgbColor(rgbValue: 0x3F3F68)
            textLabelView.textColor = UIColor.rgbColor(rgbValue: 0x7E7EB6)
            textLabelView.font = UIFont(name: "PingFangSC-Regular", size: 10)
            iconImageView.image = UIImage(named: (imageStr ?? "") + "normal")
        }
    }
    
}
