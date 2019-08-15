//
//  CountDown.swift
//  JXFoundation_Example
//
//  Created by 杜进新 on 2018/11/5.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class CountDown: NSObject {

    lazy var timer: DispatchSourceTimer = {
        let queue = DispatchQueue.global(qos: .default)
        let t = DispatchSource.makeTimerSource(flags: [], queue: queue)
        return t
    }()
    lazy var formatter: DateFormatter = {
        let format = DateFormatter()
        return format
    }()
    var tableView : UITableView?
    var dataArray : Array<Int>?
    
    var count : Int = 0
    
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(setupLess), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    init(tableView: UITableView, data: Array<Int>) {
        super.init()
        self.tableView = tableView
        self.dataArray = data
        NotificationCenter.default.addObserver(self, selector: #selector(setupLess), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.countDown()
    }
    
    @objc func setupLess() {
        
    }
    func countDown() {
        
        self.timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: 1)
        self.timer.setEventHandler {
            DispatchQueue.main.async {
                self.count += 1
                
                self.dataArray?.forEach({ (secouds) in
                    var num = secouds
                    num -= 1
                    if let index = self.dataArray?.firstIndex(of: secouds) {
                        self.dataArray?[index] = num
                    }
                })
                self.tableView?.visibleCells.forEach({ (cell) in
                    cell.contentView.subviews.forEach({ (view) in
                        if view.tag == 1314, let label = view as? UILabel {
                            let timeNum = self.dataArray?[cell.tag] ?? 0
                            label.text = self.getCountDownStr(timeInterval: timeNum)
                        }
                    })
                })
            }
        }
        self.timer.resume()
    }
    func countDown(indexPath: IndexPath) -> String {
        let timeNum = self.dataArray?[indexPath.row] ?? 0
        return self.getCountDownStr(timeInterval: timeNum)
    }
    func getCountDownStr(timeInterval: Int) -> String {
        if timeInterval <= 0 {
            return "完毕"
        }
        let days = timeInterval / (3600 * 24)
        let hours = (timeInterval - days * 24 * 3600) / 3600
        let minutes = (timeInterval - days * 24 * 3600 - hours * 3600) / 60
        let seconds = timeInterval - days * 24 * 3600 - hours * 3600 - minutes * 60
        
        
        if days > 0 {
            return String(format: "%zd天 %zd小时 %zd分 %zd秒", days,hours,minutes,seconds)
        } else {
            if hours > 0 {
                return String(format: "%zd小时 %zd分 %zd秒", hours,minutes,seconds)
            } else {
                if minutes > 0 {
                    return String(format: "%zd分 %zd秒", minutes,seconds)
                } else {
                    return String(format: "%zd秒", seconds)
                }
            }
        }
    }
    deinit {
        timer.cancel()
    }
}
