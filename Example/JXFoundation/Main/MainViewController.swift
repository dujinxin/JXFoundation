//
//  MainViewController.swift
//  JXFoundation_Example
//
//  Created by 杜进新 on 2018/7/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class MainViewController: JXBaseViewController {
    
    var titles: Array<String> {
        return ["JXView","视频","热点","体育","游戏","关注","娱乐","直播","音乐台","会员专区"]
    }
    lazy var topBar: JXScrollTitleView = {
        let att = JXAttribute()
        att.normalColor = UIColor.rgbColor(rgbValue: 0x999999)
        att.normalFontSize = 18
        att.selectedColor = UIColor.red
        att.selectedFontSize =  24
        att.sectionEdgeInsets = UIEdgeInsets.init(top: 5, left: 15, bottom: -5, right: -15)
        //att.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: -8, bottom: 0, right: 8)
        att.contentMarginEdge = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        
        att.minimumInteritemSpacing = 0
        
        let topBar = JXScrollTitleView.init(frame: CGRect.init(x: 0, y: self.navStatusHeight , width: view.bounds.width, height: 44), delegate: self, titles: titles, attribute: att)
        //topBar.delegate = self
        topBar.backgroundColor = UIColor.groupTableViewBackground
        topBar.bottomLineView.frame = CGRect(x: 0, y: 0, width: 40, height: 2)
        topBar.bottomLineView.backgroundColor = .red
        topBar.selectedBackgroundView.backgroundColor = .white
        topBar.selectedBackgroundView.layer.cornerRadius = 17
        topBar.indicatorType = .backgroundTitleSize
        return topBar
    }()
    var horizontalView : JXScrollContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        self.title = "Home"
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        view.addSubview(self.topBar)
        
        
        var controllers = [UIViewController]()
        let frame = CGRect(x: 0, y: self.navStatusHeight + 44, width: kScreenWidth, height: kScreenHeight - self.navStatusHeight - 44 - kTabBarHeight)
        for i in 0..<titles.count {
            let title = titles[i]
            if i == 0 {
                let vc = JXViewController()
                vc.view.backgroundColor = UIColor.randomColor
                vc.title = title
                controllers.append(vc)
            } else {
                let vc = JXViewController()
                
                vc.view.backgroundColor = UIColor.randomColor
                vc.title = title
                controllers.append(vc)
            }
            
        }
        
        horizontalView = JXScrollContainerView(frame: frame, containers: controllers, parentViewController: self)
        horizontalView.scrollDirection = .vertical
        view.addSubview(self.horizontalView)
        
        
        self.topBar.selectedIndex = 0
        let indexPath = IndexPath.init(item: 0, section: 0)
        self.horizontalView.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
//        return false
//    }
}
extension MainViewController : JXScrollTitleViewDelegate {

    func jxScrollTitleView(scrollTitleView: JXScrollTitleView, didSelectItemAt index: Int) {
        let indexPath = IndexPath.init(item: index, section: 0)
        //开启动画会影响topBar的点击移动动画
        self.horizontalView.selectItem(at: indexPath, animated: false)
    }
}
extension MainViewController : JXScrollContainerViewDelegate {

    func scrollContainerViewDidScroll(scrollView:UIScrollView) {
        
    }
    func scrollContainerView(_: JXScrollContainerView, to indexPath: IndexPath) {
        if self.topBar.selectedIndex == indexPath.item {
            return
        }
        
        
        print(self.topBar.selectedIndex)
        if self.horizontalView.containerView.isDragging || self.horizontalView.containerView.isDecelerating {
            self.topBar.selectedIndex = indexPath.item
        }
    }
}
