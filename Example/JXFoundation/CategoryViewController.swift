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
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
            self.navigationItem.title = "分类"
        } else {
            // Fallback on earlier versions
        }
        
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

        let offset = scrollView.contentOffset.x
        
        let count = CGFloat(self.topBar.titles.count)
        let x : CGFloat = (UIScreen.main.screenWidth / count  - self.topBar.bottomLineSize.width) / 2 + (offset / UIScreen.main.screenWidth ) * ((UIScreen.main.screenWidth / count))

        self.topBar.bottomLineView.frame.origin.x = x
        
    }
    func horizontalView(_: JXHorizontalView, to indexPath: IndexPath) {
        
        self.topBar.scrollToItem(at: indexPath)
    }
}
