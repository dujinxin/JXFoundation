//
//  JXDeviceViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 5/3/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId = "cellId"

class JXDeviceViewController: JXTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Device"
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
  
        self.tableView.frame = CGRect(x: 0, y: self.navStatusHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.navStatusHeight)

        self.tableView.register(UINib(nibName: "JXCommonCell", bundle: nil), forCellReuseIdentifier: cellId)

        
        
        self.dataArray = self.getDatas()
        
        
        //org.cocoapods.demo.JXFoundation-Example
   
        print(UIDevice.current.totalMemory)
        print(UIDevice.current.freeMemory)
        print(UIDevice.current.totalMemory1)
        print(UIDevice.current.freeMemory1)
        
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    func getDatas() -> Array<Dictionary<String, String>> {
        return [
            ["title": "名称", "description": UIDevice.current.name, "content": ""],
            ["title": "设备型号", "description": UIDevice.current.modelName, "content": ""],
            ["title": "本地化设备型号", "description": UIDevice.current.localizedModel, "content": "localized version of model"],
            ["title": "系统名称", "description": UIDevice.current.systemName, "content": "e.g. \("iOS"),\("MacOS"),\("WatchOS")"],
            ["title": "系统版本", "description": UIDevice.current.systemVersion, "content": "e.g. \("13.4.1")"],
            
            ["title": "运营商", "description": UIDevice.current.carrierName, "content": ""],
            ["title": "WI-FI地址", "description": UIDevice.current.wifiNetworkAddress(), "content": ""],
            ["title": "蜂窝网络地址", "description": UIDevice.current.mobileNetworkAddress(), "content": ""],
            //["title": "蓝牙地址", "description": "", "content": ""],
            //["title": "IMEI", "description": UIDevice.current.wifinameNetworkAddress(), "content": ""],
            ["title": "UUID", "description": UIDevice.current.uuid, "content": ""],
            
            ["title": "总容量", "description": "\(ByteCountFormatter.string(fromByteCount: Int64(UIDevice.current.totalMemory), countStyle: ByteCountFormatter.CountStyle.memory))", "content": ""],
            ["title": "可用容量", "description": "\(ByteCountFormatter.string(fromByteCount: Int64(UIDevice.current.freeMemory), countStyle: ByteCountFormatter.CountStyle.memory))", "content": ""]
        ]
    }
}
extension JXDeviceViewController {
    override func tableView(_ tvareView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! JXCommonCell
       
        let dict = self.dataArray[indexPath.row] as! Dictionary<String, String>
        cell.titleLabel.text = dict["title"]
        cell.extensionLabel.text = dict["description"]
        //cell.contentLabel.text = dict["content"]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
