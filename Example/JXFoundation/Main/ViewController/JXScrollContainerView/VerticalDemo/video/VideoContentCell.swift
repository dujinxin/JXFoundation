//
//  VideoContentCell.swift
//  Tomatos
//
//  Created by Admin on 9/30/20.
//

import UIKit

class VideoContentCell: UICollectionViewCell {

    @IBOutlet weak var mainBgView: UIView!{
        didSet{
            mainBgView.layer.cornerRadius = 8
            mainBgView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var mainImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}

class VideoRoundView: UIView {
    override func draw(_ rect: CGRect) {
     
        /// cornerRadius 圆角半径
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 4, height: 4))
        
        path.lineWidth = 2;//线宽
        path.lineCapStyle = .butt//端点样式
        path.lineJoinStyle = .miter//连接点样式

        UIColor.rgbColor(rgbValue: 0x45457d).setFill()//填充颜色
        path.fill()
        
    }
}
