//
//  BaseViewModel.swift
//  ZPSY
//
//  Created by 杜进新 on 2017/9/21.
//  Copyright © 2017年 zhouhao. All rights reserved.
//

import Foundation

open class BaseViewModel {
    public let message = "参数或数据有误"
    
    /// 页码
    public var page : Int = 0
    /// 数据
    public var dataArray = [Any]()
    /// 数据接口
    ///
    /// - Parameters:
    ///   - url: URL
    ///   - param: 参数
    ///   - completion: 回调
    public func loadData(url:String, param:Dictionary<String,Any>?,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
    }
}
