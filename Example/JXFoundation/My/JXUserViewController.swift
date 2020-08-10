//
//  JXUserViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 6/18/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId = "cellId"

class JXUserViewController: JXTableViewController {
    
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
        
        let topBar = JXScrollTitleView.init(frame: CGRect.init(x: 0, y: 0 , width: view.bounds.width, height: 44), delegate: self, titles: titles, attribute: att)
        //topBar.delegate = self
        topBar.backgroundColor = UIColor.groupTableViewBackground
        topBar.bottomLineView.frame = CGRect(x: 0, y: 0, width: 40, height: 2)
        topBar.bottomLineView.backgroundColor = .red
        topBar.indicatorType = .lineCustomSize
        return topBar
    }()
    lazy var horizontalView : JXHorizontalView = {
        var controllers = [UIViewController]()
        for title in titles {
            let vc = SubViewController()
            vc.view.backgroundColor = UIColor.randomColor
            vc.title = title
            controllers.append(vc)
        }
        
        let horizontalView = JXHorizontalView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: UIScreen.main.bounds.height - self.navStatusHeight - 44), containers: controllers, parentViewController: self)
        //view.addSubview(self.horizontalView)
        return horizontalView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的"
        self.useLargeTitles = true
        print(self.navStatusHeight)
        self.tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.scrollsToTop = false
        //self.tableView.isScrollEnabled = false

        self.customNavigationBar.barTintColor = UIColor.blue
        if #available(iOS 13.0, *) {
            self.customNavigationBar.standardAppearance.backgroundColor = UIColor.yellow
            self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:  UIColor.rgbColor(rgbValue: 0x000000), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34)]
        } else {
            
            self.customNavigationBar.barTintColor = UIColor.yellow
        }
       
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        self.customNavigationBar.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8)
        self.customNavigationBar.removeFromSuperview()
        
        self.tableView.tableHeaderView = self.customNavigationBar
        
        
        //self.beginRefreshing()
        
        self.topBar.selectedIndex = 1
        let indexPath = IndexPath.init(item: 1, section: 0)
        self.horizontalView.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
    }
    override var useCustomNavigationBar : Bool{
        return true
    }
    override var useRefreshControl : Bool {
        return true
    }
    override func refresh() {
        super.refresh()
        let _ = JXFoundationHelper.shared.countDown(timeOut: 1, process: { (a) in
            print(a)
        }) {
            self.dataArray = ["通用","拖动排序","其他"]
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            //self.tableView.setContentOffset(CGPoint(x: 0, y: -self.navStatusHeight), animated: true)
        }
    }
}
extension JXUserViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kScreenHeight - 44 - self.navStatusHeight
    }
    override func tableView(_ tvareView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.removeAllSubView()
        self.horizontalView.frame = cell.contentView.bounds;
        cell.contentView.addSubview(self.horizontalView)
                
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.topBar
    }
    
}
extension JXUserViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("tableView",scrollView.contentOffset)
        
        guard let subVC = self.horizontalView.containers[self.horizontalView.currentPage] as? SubViewController else {
            return
        }
        if subVC.tableView.contentOffset.y > 0 {
            self.tableView.contentOffset = CGPoint(x: 0, y: self.navStatusHeight)
        }
        if scrollView.contentOffset.y < self.navStatusHeight {
            subVC.tableView.contentOffset = CGPoint()
        }
        if scrollView.contentOffset.y > self.navStatusHeight && subVC.tableView.contentOffset.y == 0 {
            self.tableView.contentOffset = CGPoint(x: 0, y: self.navStatusHeight)
        }
        
    }
}
extension JXUserViewController : JXScrollTitleViewDelegate {

    func jxScrollTitleView(scrollTitleView: JXScrollTitleView, didSelectItemAt index: Int) {
        let indexPath = IndexPath.init(item: index, section: 0)
        //开启动画会影响topBar的点击移动动画
        self.horizontalView.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
}
extension JXUserViewController : JXHorizontalViewDelegate {

    func horizontalViewDidScroll(scrollView: UIScrollView) {
        
    }
    func horizontalView(_: JXHorizontalView, to indexPath: IndexPath) {
        if self.topBar.selectedIndex == indexPath.item {
            return
        }
        self.topBar.selectedIndex = indexPath.item
        
        print(self.topBar.selectedIndex)
        
    }
}
