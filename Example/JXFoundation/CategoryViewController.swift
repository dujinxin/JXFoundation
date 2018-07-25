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
    
    var topBar : JXBarView?
    var horizontalView : JXHorizontalView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "分类"
        
        topBar = JXBarView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight, width: view.bounds.width, height: 44), titles: ["新闻","视频","热点"])
        topBar?.delegate = self
        topBar?.isBottomLineEnabled = true
        view.addSubview(topBar!)
        
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.randomColor
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.randomColor
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.randomColor
        
        
        horizontalView = JXHorizontalView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight + 44, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - 44), containers: [vc1,vc2,vc3], parentViewController: self)
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
        self.horizontalView?.containerView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
    }
}
extension CategoryViewController : JXHorizontalViewDelegate {

    func horizontalViewDidScroll(scrollView:UIScrollView) {
        var frame = self.topBar?.bottomLineView.frame
        let offset = scrollView.contentOffset.x
        frame?.origin.x = (offset / kScreenWidth ) * (kScreenWidth / CGFloat((self.topBar?.titles.count)!))
        self.topBar?.bottomLineView.frame = frame!
    }
    func horizontalView(_: JXHorizontalView, to indexPath: IndexPath) {
        if self.topBar?.selectedIndex == indexPath.item {
            return
        }
        self.topBar?.containerView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}
