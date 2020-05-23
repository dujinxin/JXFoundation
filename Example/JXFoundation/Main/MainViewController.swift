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
        
        let topBar = JXScrollTitleView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight + 60 , width: view.bounds.width, height: 44), delegate: self, titles: titles, attribute: att)
        //topBar.delegate = self
        topBar.backgroundColor = UIColor.groupTableViewBackground
        topBar.bottomLineView.frame = CGRect(x: 0, y: 0, width: 40, height: 2)
        topBar.bottomLineView.backgroundColor = .red
        topBar.lineType = .customSize
        return topBar
    }()
    var horizontalView : JXHorizontalView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        view.addSubview(self.topBar)
        
        
        var controllers = [UIViewController]()
        for title in titles {
            let vc = SubViewController()
            vc.view.backgroundColor = UIColor.randomColor
            vc.title = title
            controllers.append(vc)
        }
        
        horizontalView = JXHorizontalView(frame: CGRect(x: 0, y: kNavStatusHeight + 60 + 44, width: kScreenWidth, height: UIScreen.main.bounds.height - kNavStatusHeight - 52 - 44), containers: controllers, parentViewController: self)
        view.addSubview(self.horizontalView)
        
        
        
        self.topBar.selectedIndex = 1
        let indexPath = IndexPath.init(item: 1, section: 0)
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
        self.horizontalView.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
}
extension MainViewController : JXHorizontalViewDelegate {

    func horizontalViewDidScroll(scrollView:UIScrollView) {
        
    }
    func horizontalView(_: JXHorizontalView, to indexPath: IndexPath) {
        if self.topBar.selectedIndex == indexPath.item {
            return
        }
        self.topBar.selectedIndex = indexPath.item
        
        print(self.topBar.selectedIndex)
        
    }
}
