//
//  MainEntryCell.swift
//  Tomatos
//
//  Created by Admin on 9/30/20.
//

import UIKit

class MainEntryCell: UICollectionViewCell {

    @IBOutlet weak var mainBgView: UIView!{
        didSet{
            mainBgView.layer.cornerRadius = 8
            mainBgView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
