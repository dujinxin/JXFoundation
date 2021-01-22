//
//  JXViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 8/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId = "cellId"

class JXViewController: JXTableViewController {
    
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        print(self.view.frame,self.tableView.frame)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        self.dataArray = ["JXNoticeView","JXAlertView","JXSelectView","JXPlaceHolderView","JXInputTextView","JXScrollTitleView","JXScrollContainerView","JXAdvertiseView","JXGuideView","JXActivityIndicatorButtonView","JXAutoScrollView","JXDrawerView","JXGuideView","JXGuideView","JXGuideView","JXGuideView"]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override var useCustomNavigationBar : Bool{
        return false
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
extension JXViewController {
    override func tableView(_ tvareView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.dataArray[indexPath.row] as? String
        cell.contentView.backgroundColor = self.view.backgroundColor
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = self.dataArray[indexPath.row] as! String
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let notice = JXNoticeView(text: "温馨提示！")
                notice.show()
            case 1:
                let vc = UIStoryboard(name: "JXViewDemo", bundle: nil).instantiateViewController(withIdentifier: "alertVC")
                vc.title = title
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = UIStoryboard(name: "JXViewDemo", bundle: nil).instantiateViewController(withIdentifier: "JXSelectViewController")
                vc.title = title
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                let vc = JXFeedbackViewController()
                vc.title = title
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 4:
                let vc = UIStoryboard(name: "JXViewDemo", bundle: nil).instantiateViewController(withIdentifier: "JXInputViewController")
                vc.title = title
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 5:
                //let vc = OrderManagerViewController()
                let vc = JXScrollTitleViewController()
                vc.title = title
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 6:
                let vc = UIStoryboard(name: "JXViewDemo", bundle: nil).instantiateViewController(withIdentifier: "JXScrollContainerViewController") as! JXScrollContainerViewController
                vc.title = title
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 7:
                
                let vc = ViewController()
                vc.title = title
                vc.type = .ad
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 8:
                let vc = ViewController()
                vc.title = title
                vc.type = .guide
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 9:
                let vc = JXActivityIndicatorButtonViewController()
                vc.title = title
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 10:
                let vc = JXAutoScrollViewController()
                vc.title = title
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 11:
                let vc = JXDrawListViewController()
                vc.title = title
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 12:
                let vc = TestListController()
                vc.title = title
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 13:
                let vc = TestListController()
                vc.title = title
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 14:
                let vc = TestListController()
                vc.title = title
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
    
    func showInputView() {
        let inputTextView = JXInputTextView(frame: CGRect(x: 0, y: self.tableView.frame.height, width: view.bounds.width, height: 60), style: .hidden, completion:nil)
        inputTextView.sendBlock = { (_,object) in
            let notice = JXNoticeView(text: "发表成功")
            notice.show()
        }
        inputTextView.limitWords = 1000
        inputTextView.placeHolder = "写下你的评论吧~~🌹🌹🌹"
        inputTextView.show()
    }
}

