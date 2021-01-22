//
//  JXPortraitViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 11/4/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId = "cellId"

class JXPortraitViewController: JXTableViewController {
    
    //子类重写返回按钮 backItem里， 事件默认为pop，可以自定义
    override var backItem: UIBarButtonItem {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 10, y: 7, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "icon_back_light")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.tintColor = (self.preferredStatusBarStyle == .default) ? UIColor.darkText : UIColor.white
        //leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24)
        //leftButton.setTitle("up", for: .normal)
        leftButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let item = UIBarButtonItem(customView: leftButton)
        return item
    }
    @objc func backAction() {
        
//        if let vc = self.presentingViewController {
//            vc.dismiss(animated: true, completion: nil)
//        } else {
            self.navigationController?.popViewController(animated: true)
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "portrait"
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        self.dataArray = ["push landscapeRight","push portrait","present landscapeRight","present portrait"]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.setValue(NSNumber.init(value: UIDeviceOrientation.unknown.rawValue), forKey: "orientation")
        UIDevice.current.setValue(NSNumber.init(value: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    override var useCustomNavigationBar : Bool{
        return true
    }
}
extension JXPortraitViewController {
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
            let vc = JXlandscapeRightViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            self.navigationController?.pushViewController(JXPortraitViewController(), animated: true)
        case 2:
            let vc = JXlandscapeRightViewController()
            vc.modalPresentationStyle = .fullScreen
            let nvc = JXNavigationController(rootViewController: vc)
            nvc.modalPresentationStyle = .fullScreen
            self.present(nvc, animated: true, completion: nil)
        case 3:
            let vc = JXNavigationController(rootViewController: JXPortraitViewController())
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        default:
            print(indexPath.row)
        }
        
    }
}

