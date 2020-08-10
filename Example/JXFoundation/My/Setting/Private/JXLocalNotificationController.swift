//
//  JXLocalNotificationController.swift
//  JXFoundation_Example
//
//  Created by Admin on 7/13/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId = "cellId"

class JXLocalNotificationController: JXTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "本地通知"
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        self.tableView.frame = CGRect(x: 0, y: self.navStatusHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        self.dataArray = ["注册一个本地通知"]
    }
    
    override var useCustomNavigationBar : Bool{
        return true
    }
}
extension JXLocalNotificationController {
    override func tableView(_ tvareView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.dataArray[indexPath.row] as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.saveNormalImage()
        case 1:
            self.savGifImage()
        case 2:
            self.saveVideo()
        default:
            print(indexPath.row)
        }
    }
}
extension JXLocalNotificationController {
    func saveNormalImage() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.createNotification(nil)
        self.showNotice("创建成功！请等待推送！")
    }
    func savGifImage() {
        let path = Bundle.main.path(forResource: "撒娇", ofType: ".gif")!
        
        UIImage.saveImage(path: path, isCreateAlbum: true, albumName: "图片") { (isSuc, msg) in
            let notice = JXNoticeView.init(text: msg)
            notice.show()
        }
    }
    func saveVideo() {
        let path = Bundle.main.path(forResource: "视频", ofType: ".mp4")!
        
        UIImage.saveVideo(path: path, isCreateAlbum: true, albumName: "视频") { (isSuc, msg) in
            let notice = JXNoticeView.init(text: msg)
            notice.show()
        }
    
    }
}
