//
//  JXTestViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 5/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation


class JXTestViewController: JXBaseViewController {
    
    var topBar : JXBarView!
    var horizontalView : JXHorizontalView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        self.title = "分类"
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        topBar = JXBarView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight + 60 , width: view.bounds.width, height: 44), titles: ["新闻","视频","热点","体育","游戏","关注","娱乐","直播","音乐台","会员专区"])
        topBar.delegate = self
        topBar.backgroundColor = UIColor.orange
        topBar.bottomLineSize = CGSize(width: 60, height: 2)
        topBar.bottomLineView.backgroundColor = .red
        topBar.isBottomLineEnabled = true
        let att = JXAttribute()
        att.normalColor = UIColor.rgbColor(rgbValue: 0x999999)
        att.selectedColor = UIColor.red
        att.normalFontSize = 18
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

        horizontalView = JXHorizontalView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight + 60 + 44, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - 52 - 44), containers: [vc1,vc2,vc3,vc4], parentViewController: self)
        view.addSubview(horizontalView!)
        
        
        let moreButton = UIButton()
        moreButton.setTitle("查看全文", for: .normal)
        moreButton.setTitleColor(UIColor.red, for: .normal)
       
        moreButton.contentVerticalAlignment = .bottom;
        moreButton.tag = 996;
        self.view.addSubview(moreButton);
        
        moreButton.frame = CGRect(x: 0, y: 300 - 60, width: 375, height: 60)
        
        let layer = CAGradientLayer.init()
        layer.colors = [UIColor.black.cgColor, UIColor.rgbColor(rgbValue: 0x000000, alpha: 0).cgColor];
        layer.startPoint = CGPoint(x: 0, y: 0);
        layer.endPoint = CGPoint(x: 0, y: 1.0);
        layer.frame = moreButton.bounds;
        
        moreButton.layer.insertSublayer(layer, at: 0)
        //self.view.layer.addSublayer(layer)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension JXTestViewController : JXBarViewDelegate {

    func jxBarView(barView: JXBarView, didClick index: Int) {
        let indexPath = IndexPath.init(item: index, section: 0)
        //开启动画会影响topBar的点击移动动画
        self.horizontalView?.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: false)
        
        print("did click \(index)")
    }
}
extension JXTestViewController : JXHorizontalViewDelegate {

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

