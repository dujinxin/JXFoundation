//
//  JXAlbumViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 6/24/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId = "cellId"

class JXAlbumViewController: JXTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "相册"
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        self.tableView.frame = CGRect(x: 0, y: self.navStatusHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        self.dataArray = ["保存图片到相册","保存GIF图片到相册","保存视频到相册"]
    }
    
    override var useCustomNavigationBar : Bool{
        return true
    }
}
extension JXAlbumViewController {
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
extension JXAlbumViewController {
    func saveNormalImage() {
        let path = Bundle.main.path(forResource: "樱花", ofType: ".jpg")!
        let url = URL(fileURLWithPath: path)
        guard
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else { return }
        
        UIImage.saveImage(image: image, isCreateAlbum: true, albumName: "图片") { (isSuc, msg) in
            let notice = JXNoticeView.init(text: msg)
            notice.show()
        }
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
