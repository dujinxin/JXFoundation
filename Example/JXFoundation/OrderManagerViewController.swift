//
//  OrderManagerViewController.swift
//  JXView_Example
//
//  Created by 杜进新 on 2018/6/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class OrderManagerViewController: UIViewController,JXTopBarViewDelegate,JXHorizontalViewDelegate{
    
    var topBar : JXTopBarView?
    var horizontalView : JXHorizontalView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "订单管理"
        
        topBar = JXTopBarView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight, width: view.bounds.width, height: 44), titles: ["待付款","待发货","待收货","待评价"])
        topBar?.delegate = self
        topBar?.isBottomLineEnabled = true
        view.addSubview(topBar!)
        
        horizontalView = JXHorizontalView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight + 44, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - 44), containers: [UIViewController(),UIViewController(),UIViewController(),UIViewController()], parentViewController: self)
        view.addSubview(horizontalView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension OrderManagerViewController {
    func jxTopBarView(topBarView: JXTopBarView, didSelectTabAt index: Int) {
        let indexPath = IndexPath.init(item: index, section: 0)
        //开启动画会影响topBar的点击移动动画
        self.horizontalView?.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: false)
    }
    func horizontalViewDidScroll(scrollView:UIScrollView) {
        var frame = self.topBar?.bottomLineView.frame
        let offset = scrollView.contentOffset.x
        frame?.origin.x = (offset / UIScreen.main.screenWidth ) * (UIScreen.main.screenWidth / CGFloat((self.topBar?.titles.count)!))
        self.topBar?.bottomLineView.frame = frame!
    }
    func horizontalView(_: JXHorizontalView, to indexPath: IndexPath) {
        //
        if self.topBar?.selectedIndex == indexPath.item {
            return
        }
        resetTopBarStatus(index: indexPath.item)
    }
    
    func resetTopBarStatus(index:Int) {
        
        self.topBar?.selectedIndex = index
        self.topBar?.subviews.forEach { (v : UIView) -> () in
            
            if (v is UIButton){
                let btn = v as! UIButton
                if (v.tag != self.topBar?.selectedIndex){
                    btn.isSelected = false
                }else{
                    btn.isSelected = !btn.isSelected
                }
            }
        }
    }
}
