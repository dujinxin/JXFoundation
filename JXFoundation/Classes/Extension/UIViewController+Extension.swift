//
//  UIViewController+Extension.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/7/14.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

extension UIViewController {
    /// 获取当前栈顶控制器
    var currentViewController: UIViewController? {
        if let rootVc = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
            let vc = rootVc.topViewController{
            
            return vc
        }else{
            return nil
        }
    }
    /// 获取当前显示的控制器，包括模态视图
    var visibleViewController: UIViewController? {
        if let topVC = currentViewController,
            let vc = topVC.navigationController?.visibleViewController
        {
            return vc
        }
        return nil
    }
}
