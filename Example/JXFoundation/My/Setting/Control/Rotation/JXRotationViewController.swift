//
//  JXRotationViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 11/4/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation
/**
 1.工程配置Deployment Info支持portrait，landscapeRight
 2.appDelegate中application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?)配置支持方向
 3.tabbar,navigationController所管理的控制器统一处理：
 tabbarController中:
 open override var shouldAutorotate: Bool {
     return self.selectedViewController.shouldAutorotate
 }
 open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
     return self.selectedViewController.supportedInterfaceOrientations
 }
 open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
     return self.selectedViewController.preferredInterfaceOrientationForPresentation
 }
 navigationController中:
 open override var shouldAutorotate: Bool {
     if let vc = self.visibleViewController {
         return vc.shouldAutorotate
     }
     return false
 }
 open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
     if let vc = self.visibleViewController {
         return vc.supportedInterfaceOrientations
     }
     return .portrait
 }
 open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
     if let vc = self.visibleViewController {
         return vc.preferredInterfaceOrientationForPresentation
     }
     return .portrait
 }
 4.单个控制器有特殊需求时shouldAutorotate，supportedInterfaceOrientations，preferredInterfaceOrientationForPresentation需要重写返回true，以及支持的方向
 当present时，重写前边提到的三个方法即可；
 当为push时，新打开的控制器并不会有方向的旋转。
 因为: shouldAutorotate和supportedInterfaceOrientations只有在设备发生改变时才会被调用，控制器初始化，以及进入的时候并不会触发
 preferredInterfaceOrientationForPresentation倒是可以触发，但是只对于present方式出来的模态视图起作用
 5.综合4所述，push方式还需要手动去触发设备的旋转方法
 override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     
     UIDevice.current.setValue(NSNumber.init(value: UIDeviceOrientation.unknown.rawValue), forKey: "orientation")
     UIDevice.current.setValue(NSNumber.init(value: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
     UIViewController.attemptRotationToDeviceOrientation()
 }
 6.当屏幕旋转后，有时候会发现，控制器中部分内容尺寸显示与当前屏幕不一致，这时需要在动态调整其frame或约束，viewDidLayoutSubviews方法会在屏幕发生旋转时被调用
 open override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
 
     self.defaultView.frame = view.bounds
     self.customNavigationBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: self.navStatusHeight)
     let y = self.useCustomNavigationBar ? self.navStatusHeight : 0
     self.tableView.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: (view.bounds.height - self.navStatusHeight))
 }
 */

private let cellId = "cellId"

class JXRotationViewController: JXTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "屏幕旋转"
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
extension JXRotationViewController {
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
