//
//  SubViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 5/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId = "cellId"

class SubViewController: JXTableViewController {
    
    override var title: String?{
        didSet{
            let moreButton = UIButton()
            moreButton.setTitle(title, for: .normal)
            moreButton.setTitleColor(UIColor.red, for: .normal)
            moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
            moreButton.contentVerticalAlignment = .bottom;
            moreButton.tag = 996;
            //self.view.addSubview(moreButton);
             
            moreButton.frame = CGRect(x: 0, y: 300 - 60, width: 375, height: 60)
            
            let layer = CAGradientLayer.init()
            layer.colors = [UIColor.black.cgColor, UIColor.rgbColor(rgbValue: 0x000000, alpha: 0).cgColor];
            layer.startPoint = CGPoint(x: 0, y: 0);
            layer.endPoint = CGPoint(x: 0, y: 1.0);
            layer.frame = moreButton.bounds;
            
            moreButton.layer.insertSublayer(layer, at: 0)
        }
    }
    
    var frame : CGRect? {
        didSet{
            self.tableView.frame = frame ?? CGRect()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - self.navStatusHeight)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        self.dataArray = ["device","隐私","数据存储","device","隐私","数据存储","device","隐私","数据存储","device","隐私","数据存储","device","隐私","数据存储","device","隐私","数据存储","device","隐私","数据存储","device","隐私","数据存储","device","隐私","数据存储"]
        
        self.tableView.bounces = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override var useCustomNavigationBar : Bool{
        return false
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.defaultView.frame = view.bounds
        self.tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
    override func refresh() {
        let _ = JXFoundationHelper.shared.countDown(timeOut: 1, process: { (a) in
            print(a)
        }) {
            self.refreshControl.endRefreshing()
            //self.tableView.setContentOffset(CGPoint(x: 0, y: -self.navStatusHeight), animated: true)
        }
    }
    override func resetView(status: JXNetworkStatus) {
        if status == .unavailable {
            
        } else {
            
            if status == .wifi {
                
            } else {
                
            }
        }
    }
}
extension SubViewController {
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
            self.navigationController?.pushViewController(JXDeviceViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(JXPrivateViewController(), animated: true)
        case 2:
            self.navigationController?.pushViewController(JXDataViewController(), animated: true)
        default:
            print(indexPath.row)
        }
    }
}
extension SubViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //super.scrollViewDidScroll(scrollView)
        print("subTableView",scrollView.contentOffset)
        if let block = self.scrollViewDidScrollBlock {
            block(scrollView)
        }
    }
}
extension SubViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
