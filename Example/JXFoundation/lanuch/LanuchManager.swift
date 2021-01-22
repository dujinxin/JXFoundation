//
//  LanuchManager.swift
//  Tomatos
//
//  Created by Admin on 1/14/21.
//

import UIKit
import JXFoundation

class LanuchManager: NSObject {

    public static let shared = LanuchManager()
    
    override init() {
        
    }
    
    //let service = WTService()
    /// 请求队列（目前为3个）
    var requestNumber: Int = 0
    /// 请求次数，最大3次
    var requestTimes: Int = 0
    /// 测试开关
    var testSwitch: Bool = false
    /// 计时器
    var timer: DispatchSourceTimer?
    /// 请求时间限制
    var countDown: Int = 20
    
    func reStartLanuch(completion: @escaping ((_ isSuc: Bool, _ msg: String)->()), timeout: @escaping (()->())) {
        //重置请求次数，时间限制
        self.requestTimes = 0
        self.countDown = 20
        self.startLanuch(completion: completion, timeout: timeout)
    }
    func startLanuch(completion: @escaping ((_ isSuc: Bool, _ msg: String)->()), timeout: @escaping (()->())) {
        if requestTimes >= 3 {
            completion(false, "数据加载失败，请稍后重试")
            return
        }
        self.requestTimes += 1
        
        self.timer = self.countDown(timeOut: countDown, process: { (process) in
            if self.countDown > 0 {
                self.countDown -= 1
            }
        }, completion: timeout)
        self.loadData(completion: completion, timeout: timeout)
        
    }
    /// 倒计时
    ///
    /// - Parameters:
    ///   - timeOut: 倒计时长(执行次数)
    ///   - timeInterval: 倒计时间间隔(每次调用间隔)
    ///   - process:未完成时的回调
    ///   - completion: 完成回调
    func countDown(timeOut: Int, timeInterval: Double = 1, process: @escaping ((_ currentTime: Int)->()), completion: @escaping (()->())) -> DispatchSourceTimer {
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
    func loadData(completion: @escaping ((_ isSuc: Bool, _ msg: String)->()), timeout: @escaping (()->())) {
        self.requestNumber = 0
                        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "label", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)

        //self.getUserInfo(group, queue: queue)
        self.getTestInfo(group, queue: queue)
        self.getTestInfo(group, queue: queue)
        self.getTestInfo(group, queue: queue)
        
        group.notify(queue: queue) {
            self.getMemberInfo(completion, timeout: timeout)
        }
    }
    /// 获取初始化信息
    /// - Parameters:
    ///   - group: <#group description#>
    ///   - queue: <#queue description#>
    func getUserInfo(_ group: DispatchGroup, queue: DispatchQueue) {
        
//        group.enter()
//        queue.async(group: group, execute: DispatchWorkItem.init(block: { [weak self] in
//            self?.service.getUserInfo { (error, isSuc) in
//                defer { group.leave() }
//                if let _ = error {
//
//                } else {
//                    self?.requestNumber += 1
//                }
//            }
//        }))
    }
    func getTestInfo(_ group: DispatchGroup, queue: DispatchQueue) {
        group.enter()
        queue.async(group: group, execute: DispatchWorkItem.init(block: { [weak self] in
            let _ = JXFoundationHelper.shared.countDown(timeOut: 1, process: { (a) in
                print(a)
            }) {
                defer { group.leave() }
                self?.requestNumber += 1
                print(Date())
            }
        }))
    }
    
    /// 获取用户信息
    /// - Parameters:
    ///   - group: <#group description#>
    ///   - queue: <#queue description#>
    func getMemberInfo(_ completion: @escaping(((_ isSuc: Bool, _ msg: String)->())), timeout: @escaping (()->())) {
//        guard let memberId = GVUserDefaults.standard()?.memberid else { return }
//        let service = WTUserService()
//        service.getMemberinfo(memberId) { [weak self] (error) in
//
//            print("LanuchManager",LanuchManager.shared.requestNumber,LanuchManager.shared.requestTimes)
//            if self?.requestNumber ?? 0 < 3 {
//                if self?.countDown ?? 0 <= 0 {
//                    completion(false, "数据加载失败，请稍后重试")
//                } else {
//                    self?.startLanuch(completion: completion, timeout: timeout)
//                }
//            } else {
//                if let _ = error {
//
//                    if self?.countDown ?? 0 <= 0 {
//                        //优先执行倒计时回调，
//                    } else {
//                        self?.timer?.cancel()
//                        completion(false, "数据加载失败，请稍后重试")
//                    }
//                } else {
//                    if self?.testSwitch == false {
//                        TOTCheckVideoViews.share().requestInitLookTimesModel()
//                        XHLaunchAdManager.share()?.loadAdvertData()
//                        WLiveManager.update()
//                        self?.timer?.cancel()
//                        completion(true, "")
//                        NotificationCenter.default.post(name: NSNotification.Name.init("UpdateMemberInfoSuccess"), object: nil)
//                    } else {
//                        completion(false, "数据加载失败，请稍后重试")
//                    }
//                }
//            }
//        }
    }
    func getMemberTestInfo(_ completion: @escaping(((_ isSuc: Bool, _ msg: String)->())), timeout: @escaping (()->())) {
        let _ = JXFoundationHelper.shared.countDown(timeOut: 1, process: { (a) in
            print(a)
        }) { [weak self] in
            print("LanuchManager",LanuchManager.shared.requestNumber,LanuchManager.shared.requestTimes)
            if self?.requestNumber ?? 0 < 3 {
                if self?.countDown ?? 0 <= 0 {
                    completion(false, "数据加载失败，请稍后重试")
                } else {
                    self?.startLanuch(completion: completion, timeout: timeout)
                }
            } else {
                if self?.countDown ?? 0 <= 0 {
                    //优先执行倒计时回调，
                } else {
                    self?.timer?.cancel()
                    completion(true, "")
                    NotificationCenter.default.post(name: NSNotification.Name.init("UpdateMemberInfoSuccess"), object: nil)
                }
            }
        }
    }
}
