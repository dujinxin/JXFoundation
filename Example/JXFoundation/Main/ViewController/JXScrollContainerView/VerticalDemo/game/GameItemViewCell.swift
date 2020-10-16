//
//  GameItemViewCell.swift
//  Tomatos
//
//  Created by Admin on 9/30/20.
//

import UIKit

class GameItemViewCell: UICollectionViewCell {

    @IBOutlet weak var gameBgView: UIView!{
        didSet{
            gameBgView.layer.cornerRadius = 12
            gameBgView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
