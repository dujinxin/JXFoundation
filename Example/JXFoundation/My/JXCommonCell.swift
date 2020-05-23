//
//  JXCommonCell.swift
//  JXFoundation_Example
//
//  Created by Admin on 5/3/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class JXCommonCell: UITableViewCell {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var extensionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
