//
//  Bundle+Extension.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/7/13.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import Foundation

extension Bundle {
    /// 工程名称
    var bundleName: String {
        return (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""
    }
    /// 版本号
    var version: String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
}
