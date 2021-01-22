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
    var controllers: Array<UIViewController>?
    lazy var horizontalView : JXScrollContainerView = {
        var controllers = [UIViewController]()
        for title in titles {
            let vc = SubViewController()
            vc.view.backgroundColor = UIColor.randomColor
            vc.title = title
            controllers.append(vc)
        }
        self.controllers = controllers
        let horizontalView = JXScrollContainerView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: UIScreen.main.bounds.height - self.navStatusHeight), containers: controllers, parentViewController: self)
        //view.addSubview(self.horizontalView)
        return horizontalView
    }()
    ///背景图片
    public lazy var backgroundImage: UIImageView = {
        let v = UIImageView()
        v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavStatusHeight)
        v.backgroundColor = UIColor.clear
        
        let path = Bundle.main.path(forResource: "樱花", ofType: ".jpg")!
        let url = URL(fileURLWithPath: path)
        guard
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else { return v}
        v.image = image
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的"
        self.useLargeTitles = false
        print("self.navStatusHeight = ",self.navStatusHeight)
        
        

        self.customNavigationBar.barTintColor = UIColor.blue
        if #available(iOS 13.0, *) {
            self.customNavigationBar.standardAppearance.backgroundColor = UIColor.yellow
            self.customNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:  UIColor.rgbColor(rgbValue: 0x000000), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34)]
        } else {
            
            self.customNavigationBar.barTintColor = UIColor.yellow
        }
       
        //self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        //self.customNavigationBar.backgroundImage.image = image
        self.customNavigationBar.useCustomBackgroundView = true
        
        self.customNavigationBar.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8)
        //self.customNavigationBar.removeFromSuperview()
        
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        self.tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        //self.tableView.scrollsToTop = false
        //self.tableView.isScrollEnabled = false
        self.tableView.tableHeaderView = self.customNavigationBar
        self.customNavigationBar.insertSubview(self.backgroundImage, belowSubview: self.customNavigationBar.backgroundView)
        //self.tableView.tableHeaderView = self.backgroundImage
        
        //self.beginRefreshing()
        
        self.topBar.selectedIndex = 1
        let indexPath = IndexPath.init(item: 1, section: 0)
        self.horizontalView.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
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
    override var useRefreshControl : Bool {
        return false
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
    
    //MARK: ssss
    
    
    ///外层scrollView距顶部的高度
    var mainScrollTopConstraintHeight: CGFloat = kNavStatusHeight
    ///是否滑动到初始位置（原点），刚开始一定处于原点
    var isScrollToOrigin: Bool = true
    ///外层是否可以滑动
    var isMainScrollEnabled: Bool = true
    ///内层是否可以滑动
    var isSubScrollEnabled: Bool = false
    
    ///外层刷新
    var isMainScrollRefresh: Bool = false {
        didSet {
            isSubScrollRefresh = !isMainScrollRefresh
        }
    }
    ///内层刷新
    var isSubScrollRefresh: Bool = true {
        didSet {
            isMainScrollRefresh = !isSubScrollRefresh
        }
    }
    
    
    func mainScrollViewDidScroll(_ scrollView: UIScrollView) {
        print("mainTableView",scrollView.contentOffset)
        
        // 获取mainScrollView偏移量
        let offsetY = scrollView.contentOffset.y
        // 临界点
        let origin_y = self.tableView.frame.origin.y + self.tableView.rectForRow(at: IndexPath(row: 0, section: 0)).origin.y - mainScrollTopConstraintHeight //self.tableView.rect(forSection: 0).origin.y - kNavStatusHeight
        print("mainTableView rectForRow.origin.y origin_y ",self.tableView.rectForRow(at: IndexPath(row: 0, section: 0)).origin.y,origin_y)
        // 根据偏移量判断是否上滑到临界点
        if offsetY >= origin_y {
            self.isScrollToOrigin = true
        } else {
            self.isScrollToOrigin = false
        }
        
        //到达原点，固定外层scrollView，使内层scrollView滑动
        if self.isScrollToOrigin {
            scrollView.contentOffset = CGPoint(x: 0, y: origin_y)
            self.isMainScrollEnabled = false
            self.isSubScrollEnabled = true
        } else {
            if self.isMainScrollEnabled {
                // 未达到临界点，mainTableView可滑动，需要重置所有listScrollView的位置
                self.subScrollViewOffsetFixed()
            }else {
                // 未到达临界点，mainScrollView不可滑动，固定mainScrollView的位置
                self.mainScrollViewOffsetFixed()
            }
        }
        self.mainTableViewDidScroll(scrollView, isMainCanScroll: self.isMainScrollEnabled)
    }
    func subScrollViewDidScroll(_ scrollView: UIScrollView) {
        print("subTableView",scrollView.contentOffset)
        
        if self.isScrollToOrigin {
            return
        }
        
        // 获取listScrollView偏移量
        let offsetY = scrollView.contentOffset.y
        //let trans = scrollView.
        
        if offsetY <= 0 {
            if isMainScrollRefresh {
                
            } else {
                self.isMainScrollEnabled = true
                self.isSubScrollEnabled = false
                
                if scrollView.isDecelerating {
                    return
                }
                scrollView.showsVerticalScrollIndicator = false
            }
        } else {
            if self.isSubScrollEnabled {
                scrollView.showsVerticalScrollIndicator = true
                
                if true {
                    // 临界点
                    let origin_y = self.tableView.frame.origin.y + self.tableView.rectForRow(at: IndexPath(row: 0, section: 0)).origin.y - mainScrollTopConstraintHeight
                    self.tableView.contentOffset = CGPoint(x: 0, y: origin_y)
                } else {
                    if self.tableView.contentOffset.y == 0 {
                        self.isMainScrollEnabled = true
                        self.isSubScrollEnabled = true
                        if scrollView.isDecelerating {
                            return
                        }
                        scrollView.contentOffset = .zero
                        scrollView.showsVerticalScrollIndicator = false
                    } else {//恢复外层scrollView为起始位置
                        // 临界点
                        let origin_y = self.tableView.frame.origin.y + self.tableView.rectForRow(at: IndexPath(row: 0, section: 0)).origin.y - mainScrollTopConstraintHeight
                        self.tableView.contentOffset = CGPoint(x: 0, y: origin_y)
                    }
                }
                
            } else {
                if scrollView.isDecelerating {
                    return
                }
                scrollView.contentOffset = .zero
            }
        }
        
    }
    func mainTableViewDidScroll(_ scrollView: UIScrollView, isMainCanScroll: Bool) {
        // 导航栏显隐
        let offsetY = scrollView.contentOffset.y
        
        // 0-200 0
        // 200 - KDYHeaderHeight - kNavbarHeight 渐变从0-1
        // > kDYHeaderHeight - kNavBarHeight 1
//        var alpha: CGFloat = 0
//        if offsetY < 200 {
//            alpha = 0
//        } else if offsetY > (kDYHeaderHeight - GKPage_NavBar_Height) {
//            alpha = 1
//        } else {
//            alpha = (offsetY - 200) / (kDYHeaderHeight - GKPage_NavBar_Height - 200)
//        }
//        self.gk_navBarAlpha = alpha
//        self.titleView.alpha = alpha
        
        self.headerViewScrollViewDidScroll(scrollView, offsetY: offsetY)
    }
    public func headerViewScrollViewDidScroll(_ scrollView: UIScrollView, offsetY: CGFloat) {
        var frame = self.customNavigationBar.backgroundImage.frame

//        // 左右放大
//        if offsetY <= 0 {
//            // 上下放大
//            frame.size.height -= offsetY
//            frame.origin.y = offsetY
//
//            frame.size.width = frame.size.height * self.customNavigationBar.backgroundImage.frame.size.width / self.customNavigationBar.backgroundImage.frame.size.height
//            frame.origin.x = (self.view.frame.size.width - frame.size.width) / 2
//        }
//
//        self.customNavigationBar.backgroundImage.frame = frame
        var rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavStatusHeight)
        
        let yOffset = scrollView.contentOffset.y
        if yOffset <= 0 {
            //var rect = self.backgroundImage.frame
            //var rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavStatusHeight)
            rect.origin.y = yOffset
            rect.size.height -= CGFloat(yOffset)
            //rect.size.height += CGFloat(abs(yOffset))
            rect.size.width = rect.size.height * (kScreenWidth / self.backgroundImage.frame.height)
            rect.origin.x = (self.backgroundImage.frame.width - rect.size.width) / 2
            
        }else{
            
        }
        self.backgroundImage.frame = rect
        
        if yOffset >= -self.navStatusHeight {
            //self.customNavigationBar.barTintColor = UIColor.orange
            self.customNavigationBar.alpha = 1
        } else if yOffset <= -self.navStatusHeight{
            self.customNavigationBar.alpha = 0
        } else {
            self.customNavigationBar.alpha = abs(abs(yOffset) - self.navStatusHeight) / kNavStatusHeight
        }
    }
    func mainScrollViewOffsetFixed() {
        
    }
    func subScrollViewOffsetFixed() {
        self.controllers?.forEach({ (vc) in
            if let controller = vc as? JXScrollViewController {
                controller.scrollView?.contentOffset = .zero
                controller.scrollView?.showsVerticalScrollIndicator = false
            }
        })
    }
}
extension JXUserViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kScreenHeight - self.navStatusHeight
        //return kScreenHeight - 44 - self.navStatusHeight
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
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return self.topBar
//    }
    
}

extension JXUserViewController {
    override open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.mainScrollViewDidScroll(scrollView)
    }
}
extension JXUserViewController : JXScrollTitleViewDelegate {

    func jxScrollTitleView(scrollTitleView: JXScrollTitleView, didSelectItemAt index: Int) {
        let indexPath = IndexPath.init(item: index, section: 0)
        //开启动画会影响topBar的点击移动动画
        self.horizontalView.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
}
extension JXUserViewController : JXScrollContainerViewDelegate,JXScrollContainerViewDataSource {

    func scrollContainerViewDidScroll(scrollView: UIScrollView) {
        
    }
    func scrollContainerView(_: JXScrollContainerView, to indexPath: IndexPath) {
        if self.topBar.selectedIndex == indexPath.item {
            return
        }
        self.topBar.selectedIndex = indexPath.item
        
        print(self.topBar.selectedIndex)
    }
    func scrollContainerView(_ scrollContainerView: JXScrollContainerView, viewForItemAt indexPath: IndexPath) -> UIView {
        print(scrollContainerView.classForCoder)
        print(controllers)
        print(indexPath)
        if let controllers = self.controllers, controllers.count > indexPath.item, let vc = controllers[indexPath.item] as? SubViewController {
            print(vc)
            vc.scrollViewDidScrollBlock = {[weak self](sView) in
                
                self?.subScrollViewDidScroll(sView)
            }
            return vc.view
        }
        return UIView()
    }
}
