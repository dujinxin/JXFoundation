//
//  ChannelReusableView.swift
//  Tomatos
//
//  Created by Admin on 5/6/20.
//

import UIKit

class ChannelReusableView: UICollectionReusableView {

    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var detailView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
