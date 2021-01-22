//
//  LanuchViewController.swift
//  Tomatos
//
//  Created by Admin on 1/14/21.
//

import UIKit
import JXFoundation

class LanuchViewController: UIViewController {

    @IBOutlet weak var loadingView: UIView!
    
    /// 控制多次弹窗问题
    var isShowAlert = false
    
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.lanuchData()
        //LanuchManager.shared.testSwitch = true
    }
    @objc func lanuchData() {
        LanuchManager.shared.reStartLanuch(completion: { (isSuc, msg) in
            if isSuc, let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as? JXTabbarViewController {
                appDelegate.window?.rootViewController = tabVC
                print("gotoTabVC")
            } else {
                self.showCustomAlert(msg)
            }
        }) {
            self.showCustomAlert(nil)
        }
    }
    func showCustomAlert(_ msg: String?) {
        if isShowAlert {
            return
        }
        self.isShowAlert = !self.isShowAlert
        
        self.loadingView.isHidden = true
        let alert = JXAlertView.initWithTitle("提示", content: msg ?? "数据加载失败，请稍后重试", cancelTitle: "稍后", confirmTitle: "重试")
        alert.contentLabel.textAlignment = .center
        let attribute = JXAttribute()
        attribute.contentMarginEdge = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        attribute.minimumInteritemSpacing = 16
        alert.attribute = attribute
        alert.confirmBlock = {
            self.isShowAlert = false
            self.loadingView.isHidden = false
            //LanuchManager.shared.testSwitch = false
            self.lanuchData()
        }
        alert.cancelBlock = {
            self.isShowAlert = false
            //exit(0)
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as? JXTabbarViewController {
                appDelegate.window?.rootViewController = tabVC
                print("gotoTabVC")
            }
        }
        alert.show()
    }
}
