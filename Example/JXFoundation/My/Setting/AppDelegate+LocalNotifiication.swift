//
//  LocalNotifiication.swift
//  JXFoundation_Example
//
//  Created by Admin on 7/13/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import UserNotifications
import JXFoundation

extension AppDelegate {
    func notifications_application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
//        if let locals = application.scheduledLocalNotifications, locals.isEmpty == false {
//            print(locals)
//            let notice = JXNoticeView.init(text: locals.description)
//            notice.show()
//        }
//        if
//            let launchOptions = launchOptions,
//            let local = launchOptions[UIApplication.LaunchOptionsKey.localNotification] as? UILocalNotification {
//            print(local)
//
//            let notice = JXNoticeView.init(text: local.description)
//            notice.show()
//        }
         
        let category = UIUserNotificationCategory()
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound ], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        
        return true
        
        
    
    }
    
    func createNotification(_ notifi: UILocalNotification?) {
        
        if let notifi = notifi {
            UIApplication.shared.scheduleLocalNotification(notifi)
        } else {
            let notifi = UILocalNotification()
            notifi.fireDate = Date(timeIntervalSinceNow: 60)
            notifi.timeZone = TimeZone.current
            notifi.alertTitle = "title"
            notifi.alertBody = "body"
            notifi.soundName = UILocalNotificationDefaultSoundName
            notifi.alertAction = "open application"
            notifi.applicationIconBadgeNumber = 1
            notifi.userInfo = ["id": 1, "name": "name1", "type": 1]
            UIApplication.shared.scheduleLocalNotification(notifi)
        }
    }
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        //application.cancelLocalNotification(notification)
        
        guard let userInfo = notification.userInfo else { return }
        
        guard
            let type = userInfo["type"] as? Int else {
            return
        }
        //自定义操作
        switch type {
        case 0:
            print(type)
        default:
            print(type)
        }
    }
}
