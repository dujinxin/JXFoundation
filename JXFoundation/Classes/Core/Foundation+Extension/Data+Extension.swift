//
//  Data+Extension.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/12/5.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import Foundation

public extension Data{
    /// 保存数据
    ///
    /// - Parameters:
    ///   - data: 数据
    ///   - name: 数据名称
    static func insert(data: Data, name: String) ->Bool {
        return FileManager.insert(data: data, toFile: name)
    }
    /// 修改数据
    ///
    /// - Parameters:
    ///   - data: 图片
    ///   - name: 数据名称
    /// - Returns: 操作结果
    static func update(data: Data, name: String) ->Bool {
        return FileManager.update(inFile: data, name: name)
    }
    /// 获取数据
    ///
    /// - Parameters:
    ///   - data: 数据
    ///   - name: 数据名称
    static func select(name: String) -> Data? {
        let data = FileManager.select(fromFile: name) as? Data
        return data
    }
    /// 移除数据
    ///
    /// - Parameter name: 数据名称
    static func delete(name: String) -> Bool{
        return FileManager.delete(fromFile: name)
    }
}
