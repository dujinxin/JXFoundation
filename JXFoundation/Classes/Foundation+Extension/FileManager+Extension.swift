//
//  FileManager+Extension.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/12/6.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import Foundation

let dataPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

//MARK:保存到文件中
public extension FileManager{
    
    /// 保存数据到文件中
    ///
    /// - Parameters:
    ///   - data: 数据
    ///   - name: 数据名称
    /// - Returns: 操作结果
    public static func insert(data: Data, toFile name: String) -> Bool{
        let newPath = dataPath + "/\(name)"
        let dataPathUrl = URL.init(fileURLWithPath: newPath)
        
        do {
            try data.write(to: dataPathUrl)
        } catch let error {
            print(error.localizedDescription)
        }
        return !FileManager.default.fileExists(atPath: newPath)
    }
    /// 修改文件中的数据
    ///
    /// - Parameters:
    ///   - data: 数据
    ///   - name: 数据名称
    /// - Returns: 操作结果
    public static func update(inFile data: Data, name: String) -> Bool {
        let newPath = dataPath + "/\(name)"
        let dataPathUrl = URL.init(fileURLWithPath: newPath)
        if FileManager.default.fileExists(atPath: newPath) == false {
            return false
        }
        
        do {
            try data.write(to: dataPathUrl)
        } catch let error {
            print(error.localizedDescription)
        }
        return !FileManager.default.fileExists(atPath: newPath)
    }
    /// 获取文件中的数据
    ///
    /// - Parameters:
    ///   - name: 数据名称
    /// - Returns: 操作结果
    public static func select(fromFile name: String) -> Any? {
        let newPath = dataPath + "/\(name)"
        let dataPathUrl = URL.init(fileURLWithPath: newPath)
        
        var data : Data?
        do {
            data = try Data.init(contentsOf: dataPathUrl)
        } catch let error {
            print(error.localizedDescription)
        }
        return data
    }
    /// 移除文件中数据
    ///
    /// - Parameter name: 数据名称
    /// - Returns: 操作结果
    public static func delete(fromFile name: String) -> Bool{
        let newPath = dataPath + "/\(name)"
        
        do {
            try FileManager.default.removeItem(atPath: newPath)
        } catch let error {
            print(error.localizedDescription)
        }
        return !FileManager.default.fileExists(atPath: newPath)
    }
}
