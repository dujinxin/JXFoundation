//
//  LiveItemViewCell.swift
//  Tomatos
//
//  Created by Admin on 9/30/20.
//

import UIKit

class LiveItemViewCell: UICollectionViewCell {

    @IBOutlet weak var LiveBgView: UIView!{
        didSet{
            LiveBgView.layer.cornerRadius = 8
            LiveBgView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var LiveNameLabel: UILabel!
    @IBOutlet weak var LiverNameLabel: UILabel!
    @IBOutlet weak var LiveNumberLabel: UILabel!
    @IBOutlet weak var LiveImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
