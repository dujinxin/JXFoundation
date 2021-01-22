//
//  CommonManager.swift
//  Star
//
//  Created by 杜进新 on 2018/5/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

/// 打印信息
///
/// - Parameters:
///   - msg: 要输出的信息
///   - file: 文件名
///   - line: 方法所在行数
///   - function: 方法名称
public func prints<T>(_ msg:T, file: String = #file, line: Int = #line, function: String = #function) {
    
    if JXFoundationHelper.shared.isShowLog {
        let fileName = (file as NSString).lastPathComponent.components(separatedBy: ".")[0]
        Swift.print(fileName,msg, separator: " ", terminator: "\n")
    }
    //print("[\(Date(timeIntervalSinceNow: 0))]",msg, separator: " ", terminator: "\n")
    //print("\(Date(timeIntervalSinceNow: 0)) <\(fileName) \(line) \(function)>\n\(msg)", separator: "", terminator: "\n")
}

open class JXFoundationHelper {
    public static let shared = JXFoundationHelper()
    
    open var isShowLog : Bool = false
    open var isDebug : Bool = false
    
    private init() {}
    /// 倒计时
    ///
    /// - Parameters:
    ///   - timeOut: 倒计时长(执行次数)
    ///   - timeInterval: 倒计时间间隔(每次调用间隔)
    ///   - process:未完成时的回调
    ///   - completion: 完成回调
    public func countDown(timeOut: Int, timeInterval: Double = 1, process: @escaping ((_ currentTime: Int)->()), completion: @escaping (()->())) -> DispatchSourceTimer{
        
        var timeOut1 = timeOut
        let queue = DispatchQueue.global(qos: .default)
        let source_timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        source_timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: timeInterval)
        source_timer.setEventHandler {
            if timeOut1 <= 0 {
                source_timer.cancel()
                DispatchQueue.main.async {
                    completion()
                }
            } else {
                let seconds = timeOut1 % (timeOut + 1)
                DispatchQueue.main.async {
                    process(seconds)
                }
                timeOut1 -= 1
            }
        }
        source_timer.resume()
        return source_timer
    }
   
    /// 校验字符串
    ///
    /// - Parameters:
    ///   - string: 需要校验的字符串
    ///   - predicateStr: 正则
    ///   - emptyMsg: 空字串提示
    ///   - formatMsg: 格式错误提示
    /// - Returns: 结果
    public func validate(_ string: String?, predicateStr: String, emptyMsg: String?, formatMsg: String) -> Bool{
        guard let str = string, str.isEmpty == false else {
//            let notice = JXNoticeView.init(text: emptyMsg ?? formatMsg)
//            notice.show()
            return false
        }
        if predicateStr.isEmpty {
            return true
        }
        if !String.validate(str, predicateStr: predicateStr) {
//            let notice = JXNoticeView.init(text: formatMsg)
//            notice.show()
            return false
        } else {
            return true
        }
    }
    
    /// 根据权重值获取数组下标，进而选择
    /// - Parameter weights: 升序排列
    /// - Returns: 数组下标
    func getIndexOfArray(weights: Array<UInt>) -> Int {
        if weights.count == 0 {
            assertionFailure("权重值不可为空")
        }
        //只有一个元素，那么那么直接返回即可
        if weights.count == 1 {
            return 0
        }
        //多个元素，需要根据权重来随机取值
        
        //权重值总和（分母）
        let sumWeight = weights.reduce(0) { (result, a) in
            return result + a
        }
        if sumWeight == 0 {
            assertionFailure("权重值不可为0")
        }
        var index = -1
        //依次根据权重（概率）：单个权重（分子） / 总的权重和（分母），取值，取到则停止
        //1.每个元素被参与得额概率一样为：1/weights.count
        //2.每个元素被被选中的概率为：权重/ 总的权重
        let indexRandom = Int(arc4random_uniform(UInt32(weights.count)))
        let weightRandom = arc4random_uniform(UInt32(sumWeight))
        let weightValue = weights[indexRandom]//权重值
        
        //举例：[2,1,4],概率为2/7，1/7，4/7，对应随机值为：0,1; 0; 0,1,2,3.
        if weightRandom < weightValue {
            index = indexRandom
        }
        //没有获取到下标值，那么继续
        if index == -1 {
            return getIndexOfArray(weights: weights)
        }
        return index
    }
}
