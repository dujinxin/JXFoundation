//
//  UIImageView+Extension.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/7/19.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit
//import SDWebImage

extension UIImageView {
    
    func jx_setImage(obj:Any?) {
        guard let obj = obj else {
            return
        }
        if obj is UIImage {
            self.image = obj as? UIImage
        }
        
        if obj is String {
            let objStr = obj as! String
            if objStr.isEmpty == true {
                return
            }
            if objStr.hasPrefix("http") {
                jx_setImage(with: objStr, placeholderImage: nil)
            }else{
                self.image = UIImage(named: objStr)
            }
        }
    }
    
    func jx_setImage(with urlStr:String, placeholderImage: UIImage?,radius:CGFloat = 0){
        
        guard let _ = URL(string: urlStr) else {
            self.image = placeholderImage
            return
        }
//        self.sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { (image, error, _, url) in
//            if
//                let image = image,
//                radius > 0{
//                
//                self.image = UIImage.image(originalImage: image, rect: self.bounds, radius: radius)
//            }
//        }
    }
    
}
