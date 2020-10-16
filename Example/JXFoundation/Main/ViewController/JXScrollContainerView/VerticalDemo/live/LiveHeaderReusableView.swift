//
//  LiveHeaderReusableView.swift
//  Tomatos
//
//  Created by Admin on 9/30/20.
//

import UIKit

class LiveHeaderReusableView: UICollectionReusableView {

    @IBOutlet weak var liveHeaderBgView: UIView!{
        didSet{
            liveHeaderBgView.layer.cornerRadius = 8
            liveHeaderBgView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var liverBgView: UIView!
    @IBOutlet weak var liverImageView1: UIView!{
        didSet{
            liverImageView1.layer.cornerRadius = 12
            liverImageView1.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var liverImageView2: UIView!{
        didSet{
            liverImageView2.layer.cornerRadius = 12
            liverImageView2.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var liverImageView3: UIView!{
        didSet{
            liverImageView3.layer.cornerRadius = 12
            liverImageView3.layer.masksToBounds = true
        }
    }
    
    
    @IBOutlet weak var viewerBgView: UIView!
    @IBOutlet weak var viewerImageView1: UIView!{
        didSet{
            viewerImageView1.layer.cornerRadius = 12
            viewerImageView1.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var viewerImageView2: UIView!{
        didSet{
            viewerImageView2.layer.cornerRadius = 12
            viewerImageView2.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var viewerImageView3: UIView!{
        didSet{
            viewerImageView3.layer.cornerRadius = 12
            viewerImageView3.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
