//
//  JXTestViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 5/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation


class JXTestViewController: JXBaseViewController, JXScrollCycleViewDelegate {
    func scrollCycleView(scrollCycleView: JXScrollCycleView, didSelectItemAt index: Int) {
        
    }
    
    func numberOfItems(in scrollCycleView: JXScrollCycleView) -> Int {
        return 3
    }
    
    func scrollCycleView(_ scrollCycleView: JXScrollCycleView, StringForItemAt indexPath: IndexPath) -> String {
        return ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        self.title = "分类"
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        
        view.addSubview(self.topBar)

        
        let moreButton = UIButton()
        moreButton.setTitle("查看全文", for: .normal)
        moreButton.setTitleColor(UIColor.red, for: .normal)
       
        moreButton.contentVerticalAlignment = .bottom;
        moreButton.tag = 996;
        self.view.addSubview(moreButton);
        
        moreButton.frame = CGRect(x: 0, y: 600, width: 375, height: 60)
        
        let layer = CAGradientLayer.init()
        layer.colors = [UIColor.black.cgColor, UIColor.rgbColor(rgbValue: 0x000000, alpha: 0).cgColor];
        layer.startPoint = CGPoint(x: 0, y: 0);
        layer.endPoint = CGPoint(x: 0, y: 1.0);
        layer.frame = moreButton.bounds;
        
        moreButton.layer.insertSublayer(layer, at: 0)
        //self.view.layer.addSublayer(layer)
        
        
        
        let button = UIButton()
        button.frame = CGRect(x: 170, y: 600 + 100, width: 40, height: 40)
        button.backgroundColor = UIColor.gray
        button.setTitle("查看", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(clickAction(button:)), for: .touchUpInside)
        self.view.addSubview(button);
        
    }
    
    @objc func clickAction(button: UIButton) {
        button.isSelected = !button.isSelected
        
        let sel = JXDropListView(frame: CGRect(x: kScreenWidth - 100 - 10, y: kNavStatusHeight, width: 100, height: 120), style: .list)
        sel.delegate = self
        sel.dataSource = self
        sel.backgroundColor = UIColor.rgbColor(rgbValue: 0x323245)

        sel.layer.cornerRadius = 2
        sel.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
        sel.layer.shadowOffset = CGSize(width: 0, height: 10)
        sel.layer.shadowRadius = 10
        sel.layer.shadowOpacity = 1

        sel.show()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        print("JXTestViewController deinit")
    }
    
    lazy var topBar: JXDrawerView = {
        let att = JXAttribute()
        att.selectedImage = "home_item_recharge"
        att.normalImage = "home_item_recharge"
        
        att.normalColor = UIColor.rgbColor(rgbValue: 0x999999)
        att.normalFontSize = 18
        att.selectedColor = UIColor.red
        att.backgroundColor = UIColor.blue
        att.normalBackgroundColor = UIColor.yellow
        att.selectedBackgroundColor = UIColor.red
        att.cornerRadius = 25
        att.selectedFontSize =  24
        att.sectionEdgeInsets = UIEdgeInsets.init(top: 5, left: 15, bottom: -5, right: -15)
        //att.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: -8, bottom: 0, right: 8)
        att.contentMarginEdge = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        
        att.minimumInteritemSpacing = 0
        //["home_item_recharge","home_item_wthdraw","home_item_exchange","home_item_promote"]
        //["😭","推荐","视频","热点","体育"]
        let topBar = JXDrawerView.init(frame: CGRect.init(x: 170, y: 300 , width: 50, height: 50), delegate: self, titles: ["home_item_recharge","home_item_recharge","home_item_wthdraw","home_item_exchange","home_item_promote"], contentType: .image, attribute: att)
        
        topBar.unfoldDirection = .left
        topBar.layer.cornerRadius = 25
        topBar.layer.masksToBounds = true
        return topBar
    }()
    open override var shouldAutorotate: Bool {
        return true
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    var additionArray : Array = ["发币","收币","钱包记录"]
}

extension JXTestViewController: JXDrawerViewDelegate {
    func jxDrawerView(drawerView: JXDrawerView, didSelectItemAt index: Int) {
        print(index)
    }
}
// MARK: JXDropListViewDelegate & JXDropListViewDataSource
extension JXTestViewController : JXDropListViewDelegate,JXDropListViewDataSource {
    func dropListView(listView: JXDropListView, didSelectRowAt row: Int, inSection section: Int) {
        print(row)
    }
    func dropListView(listView: JXDropListView, numberOfRowsInSection section: Int) -> Int {
        return additionArray.count
    }
    
    func dropListView(listView: JXDropListView, heightForRowAt row: Int) -> CGFloat {
        return 40
    }
    
    func dropListView(listView: JXDropListView, contentForRow row: Int, InSection section: Int) -> String {
        return additionArray[row]
    }
    
    
}
