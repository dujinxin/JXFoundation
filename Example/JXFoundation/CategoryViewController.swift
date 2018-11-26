//
//  CategoryViewController.swift
//  JXFoundation_Example
//
//  Created by 杜进新 on 2018/7/25.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class CategoryViewController: UIViewController {
    
    var topBar : JXBarView!
    var horizontalView : JXHorizontalView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "分类"
        
        topBar = JXBarView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight, width: view.bounds.width, height: 44), titles: ["新闻","视频","热点","体育"])
        topBar.delegate = self
        topBar.backgroundColor = UIColor.orange
        topBar.bottomLineSize = CGSize(width: 60, height: 2)
        topBar.bottomLineView.backgroundColor = .red
        topBar.isBottomLineEnabled = true
        let att = JXAttribute()
        att.normalColor = UIColor.rgbColor(rgbValue: 0x999999)
        att.selectedColor = UIColor.red
        att.font = UIFont.systemFont(ofSize: 18)
        topBar.attribute = att
        view.addSubview(topBar)
        
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.randomColor
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.randomColor
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.randomColor
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor.randomColor
        
        horizontalView = JXHorizontalView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight + 44, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - 44), containers: [vc1,vc2,vc3,vc4], parentViewController: self)
        view.addSubview(horizontalView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension CategoryViewController : JXBarViewDelegate {

    func jxBarView(barView: JXBarView, didClick index: Int) {
        let indexPath = IndexPath.init(item: index, section: 0)
        //开启动画会影响topBar的点击移动动画
        self.horizontalView?.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: false)
    }
}
extension CategoryViewController : JXHorizontalViewDelegate {

    func horizontalViewDidScroll(scrollView:UIScrollView) {
//        var frame = self.topBar?.bottomLineView.frame
//        let offset = scrollView.contentOffset.x
//        frame?.origin.x = (offset / kScreenWidth ) * (kScreenWidth / CGFloat((self.topBar?.titles.count)!))
//        self.topBar?.bottomLineView.frame = frame!
        
        let offset = scrollView.contentOffset.x
        var x : CGFloat
        let count = CGFloat(self.topBar.titles.count)
//        if itemSize.width * count >= self.bounds.width {
//            x = (itemSize.width  - self.bottomLineSize.width) / 2 + (offset / kScreenWidth ) * (itemSize.width * count)
//        } else {
            x = (kScreenWidth / count  - self.topBar.bottomLineSize.width) / 2 + (offset / kScreenWidth ) * ((kScreenWidth / count))
//        }
        self.topBar.bottomLineView.frame.origin.x = x
    }
    func horizontalView(_: JXHorizontalView, to indexPath: IndexPath) {
        if self.topBar.selectedIndex == indexPath.item {
            return
        }
        
//        self.topBar.containerView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
        self.topBar.scrollToItem(at: indexPath)
//        self.topBar.containerView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//        self.topBar.containerView.reloadItems(at: [indexPath])
    }
}
