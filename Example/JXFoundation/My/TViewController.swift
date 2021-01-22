//
//  TViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 12/21/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId = "cellId"

class TViewController: JXTableViewController {
    var titles: Array<String> {
        return ["新闻","视频","热点","体育","游戏","关注","娱乐","直播","音乐台","会员专区"]
    }
    lazy var topBar: JXScrollTitleView = {
        let att = JXAttribute()
        att.normalColor = UIColor.rgbColor(rgbValue: 0x999999)
        att.normalFontSize = 18
        att.selectedColor = UIColor.red
        att.selectedFontSize =  24
        att.sectionEdgeInsets = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: -15)
        //att.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: -8, bottom: 0, right: 8)
        att.contentMarginEdge = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
        
        att.minimumInteritemSpacing = 0
        
        let topBar = JXScrollTitleView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight , width: view.bounds.width, height: 44), delegate: self, titles: titles, attribute: att)
        //topBar.delegate = self
        topBar.backgroundColor = UIColor.groupTableViewBackground
        topBar.bottomLineView.frame = CGRect(x: 0, y: 0, width: 40, height: 2)
        topBar.bottomLineView.backgroundColor = .red
        topBar.indicatorType = .lineCustomSize
        return topBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的"
        self.useLargeTitles = true
        print(self.navStatusHeight)
        
        self.customNavigationBar.removeFromSuperview()
        self.customNavigationBar.barTintColor = UIColor.blue
        if #available(iOS 13.0, *) {
            self.customNavigationBar.standardAppearance.backgroundColor = UIColor.yellow
        } else {
            self.customNavigationBar.barTintColor = UIColor.yellow
        }
       
        let path = Bundle.main.path(forResource: "樱花", ofType: ".jpg")!
        let url = URL(fileURLWithPath: path)
        guard
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else { return }
        
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        self.customNavigationBar.backgroundImage.image = image
        self.customNavigationBar.useCustomBackgroundView = true
        self.customNavigationBar.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8)
        
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.tableHeaderView = self.customNavigationBar
        
        
        
        self.beginRefreshing()
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.defaultView.frame = view.bounds
        self.customNavigationBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: self.navStatusHeight)
        let y: CGFloat = 0
        self.tableView.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: (view.bounds.height - y))
    }
    override var useCustomNavigationBar : Bool{
        return true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var useRefreshControl : Bool {
        return true
    }
    override func refresh() {
        super.refresh()
        let _ = JXFoundationHelper.shared.countDown(timeOut: 1, process: { (a) in
            print(a)
        }) {
            self.dataArray = ["通用","个人中心","拖动排序","其他","个人中心","拖动排序","其他","个人中心","拖动排序","其他","个人中心","拖动排序","其他","个人中心","拖动排序","其他","个人中心","拖动排序","其他"]
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            //self.tableView.setContentOffset(CGPoint(x: 0, y: -self.navStatusHeight), animated: true)
        }
    }
}
extension TViewController {
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
            let vc = JXSettingViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = JXUserViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = JXChannelViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = JXTestViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            print(indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 + kNavStatusHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44 + kNavStatusHeight))
        v.addSubview(self.topBar)
        return v
    }
}
extension TViewController : JXScrollTitleViewDelegate {

    func jxScrollTitleView(scrollTitleView: JXScrollTitleView, didSelectItemAt index: Int) {
        let indexPath = IndexPath.init(item: index, section: 0)
        //开启动画会影响topBar的点击移动动画
        //self.horizontalView.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
}
