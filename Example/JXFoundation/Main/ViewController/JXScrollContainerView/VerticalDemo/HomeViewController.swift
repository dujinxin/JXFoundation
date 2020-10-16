//
//  JXVerticallyViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 9/28/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class HomeViewController: JXBaseViewController {
    
    var selectedIndex: Int = 0
    
    var titles: Array<String> {
        return ["直播","社区","短片","棋牌竞技","对战平台","真人游戏","捕鱼达人"]
    }
    var images: Array<String> {
        return ["home_item_live_","home_item_tomato_","home_item_video_","home_item_game_","home_item_temp_","home_item_people_","home_item_fish_"]
    }
    
    //topView left items
    public lazy var topView : UIView = {
        
        let topView = UIView(frame: CGRect(x: 84, y: kNavStatusHeight + 10, width: kScreenWidth - 84, height: 44))
        let titles = ["充值","提现","转账","分红"]
        let images = ["home_item_recharge","home_item_wthdraw","home_item_exchange","home_item_promote"]
        for i in 0..<titles.count {
            let title = titles[i]
            let image = images[i]
            let space = (topView.bounds.width - 61 * 4 - 12) / 3
            let button = UIButton()
            button.backgroundColor = UIColor.rgbColor(rgbValue: 0x45457d)
            button.frame = CGRect(x: (61.0 + space) * CGFloat(i), y: 0, width: 61, height: 36)
            button.setTitleColor(UIColor.white, for: .normal)
            button.tag = i
            button.setTitle(title, for: .normal)
            button.setImage(UIImage(named: image), for: .normal)
            button.addTarget(self, action: #selector(tabButtonAction(button:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 12)
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            topView.addSubview(button)
        }
        
        return topView
    }()
    //tableview left items
    public lazy var tableView : UITableView = {
        
        let table = UITableView.init(frame: CGRect(x: 0, y: kNavStatusHeight + 10, width: 84, height: self.view.bounds.height - (kNavStatusHeight + 10)), style: .plain)
        
        table.backgroundColor = UIColor.clear
        table.separatorStyle = .none
        //table.separatorColor = JXSeparatorColor
        table.delegate = self
        table.dataSource = self
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        table.estimatedRowHeight = 72
        table.rowHeight = UITableView.automaticDimension
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        table.showsVerticalScrollIndicator = false
        table.tableFooterView = UIView()
        table.register(UINib(nibName: "LeftItemCell", bundle: nil), forCellReuseIdentifier: "LeftItemCell")
        
        
        return table
    }()
    //contentView
    var horizontalView : JXScrollContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.rgbColor(rgbValue: 0x1f1932)
        
        
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.clear
        self.customNavigationBar.separatorView.backgroundColor = UIColor.clear
        
        view.addSubview(self.tableView)
        view.addSubview(self.topView)
        
        
        var controllers = [UIViewController]()
        let frame = CGRect(x: 84, y: self.topView.frame.maxY, width: kScreenWidth - 84 - 12, height: kScreenHeight - self.topView.frame.maxY)
        for i in 0..<titles.count {
            if i == 0 {
                let vc = HomeLiveController()
                vc.view.backgroundColor = UIColor.rgbColor(rgbValue: 0x1f1932)
                controllers.append(vc)
            } else if i == 1 {
                let vc = MainController()
                vc.view.backgroundColor = UIColor.rgbColor(rgbValue: 0x1f1932)
                controllers.append(vc)
            } else if i == 2 {
                let vc = VideoViewController()
                vc.view.backgroundColor = UIColor.rgbColor(rgbValue: 0x1f1932)
                controllers.append(vc)
            } else {
                let vc = HomeGameController()
                vc.view.backgroundColor = UIColor.rgbColor(rgbValue: 0x1f1932)
                controllers.append(vc)
            }
        }
        
        horizontalView = JXScrollContainerView(frame: frame, containers: controllers, parentViewController: self)
        horizontalView.scrollDirection = .vertical
        horizontalView.containerView.bounces = false
        view.addSubview(self.horizontalView)
        
        let indexPath = IndexPath.init(item: 0, section: 0)
        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        self.horizontalView.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredVertically, animated: false)
        self.tableView(self.tableView, didSelectRowAt: indexPath)
        
        //self.tableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var useCustomNavigationBar: Bool {
        return true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func tabButtonAction(button : UIButton) {
        
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tvareView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftItemCell", for: indexPath) as! LeftItemCell
        cell.imageStr = self.images[indexPath.row]
        cell.textLabelView.text = self.titles[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell_c = cell as! LeftItemCell
        cell_c.imageStr = self.images[indexPath.row]
        cell_c.textLabelView.text = self.titles[indexPath.row]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        print("tableView",indexPath)
        self.selectedIndex = indexPath.row

        let indexPath = IndexPath.init(item: indexPath.row, section: 0)
        self.horizontalView.scrollToItem(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension HomeViewController : JXScrollContainerViewDelegate {

    func scrollContainerViewDidScroll(scrollView: UIScrollView) {
        
    }
    func scrollContainerView(_: JXScrollContainerView, to indexPath: IndexPath) {
        if self.selectedIndex == indexPath.item {
            return
        }
//        if self.horizontalView.containerView.isDragging || self.horizontalView.containerView.isDecelerating {
//            self.selectedIndex = indexPath.item
//
//            self.tableView.selectRow(at: IndexPath(row: self.selectedIndex, section: 0), animated: true, scrollPosition: .middle)
//        }
        
        if
            horizontalView.containerView.isDragging || horizontalView.containerView.isDecelerating {
            
            self.selectedIndex = indexPath.item
            
            self.tableView.selectRow(at: IndexPath(row: self.selectedIndex, section: 0), animated: true, scrollPosition: .middle)
        }
    }
}
