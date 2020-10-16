//
//  TwoCategroyViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 9/28/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let reuseIdentifierOne = "reuseIdentifierOne"
private let reuseIdentifierTwo = "reuseIdentifierTwo"
private let reuseIdentifierThree = "reuseIdentifierThree"

class TwoCategroyViewController: JXBaseViewController {
    //tableview
    public lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect())
        
        table.backgroundColor = UIColor.clear
        table.separatorStyle = .singleLine
        //table.separatorColor = JXSeparatorColor
        table.delegate = self
        table.dataSource = self
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        table.estimatedRowHeight = 44
        table.rowHeight = UITableView.automaticDimension
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.sectionFooterHeight = UITableView.automaticDimension
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifierOne)
        
        return table
    }()
    //collectionView
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets.init(top: 4, left: 12, bottom: 12, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
//        if #available(iOS 10.0, *) {
//            layout.itemSize = UICollectionViewFlowLayout.automaticSize
//        }
        let width = kScreenWidth - kScreenWidth / 3
        layout.itemSize = CGSize(width: width - 12, height: 52)
        layout.headerReferenceSize = CGSize(width: width - 12, height: 38)
        
        //layout.estimatedItemSize = CGSize(width: width, height: 52)
        //layout.headerReferenceSize = UICollectionViewFlowLayoutAutomaticSize
     
        
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ChannelReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifierTwo)
        collectionView.register(UINib(nibName: "ChannelViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifierThree)
        
        return collectionView
    }()
    
    //data array
    var dataArray = [CategoryEntity]()
    
    
    /// 一级列表选中的行
    var selectRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "分类"
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        
        
        self.tableView.frame = CGRect(x: 0, y: self.navStatusHeight, width: kScreenWidth / 3, height: kScreenHeight - self.navStatusHeight - kTabBarHeight)
        self.view.addSubview(self.tableView)
        
        self.collectionView.frame = CGRect(x: kScreenWidth / 3, y: self.navStatusHeight, width: kScreenWidth - kScreenWidth / 3, height: kScreenHeight - self.navStatusHeight - kTabBarHeight)
        self.view.addSubview(self.collectionView)
        
        
        self.tableView.reloadData()
        self.collectionView.reloadData()
        
        self.tableView.selectRow(at: IndexPath(row: self.selectRow , section: 0), animated: true, scrollPosition: .middle)
        self.collectionView.scrollToItem(at: IndexPath(row: 0 , section: self.selectRow), at: .top, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - UITableViewDataSource & UITableViewDelegate
extension TwoCategroyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tvareView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierOne, for: indexPath)
        //cell.accessoryType = .disclosureIndicator
        
        let entity = self.dataArray[indexPath.row]
        cell.textLabel?.text = entity.title
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        
        if self.selectRow != indexPath.row {
            self.selectRow = indexPath.row
//            self.collectionView.reloadData()
        }
        
        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: indexPath.row), at: .top, animated: true)
        //self.tableView.scrollToRow(at: IndexPath(row: self.selectRow, section: 0), at: .top, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension TwoCategroyViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataArray.count > 0 {
            let entityOne = self.dataArray[section]
            return entityOne.list.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierThree, for: indexPath) as! ChannelViewCell
        let entityOne = self.dataArray[indexPath.section]
        let entityTwo = entityOne.list[indexPath.item]
        
        cell.titleView.text = entityTwo.title
        cell.statusView.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifierTwo, for: indexPath) as! ChannelReusableView
        
        let entityOne = self.dataArray[indexPath.section]
        
        reusableView.titleView.text = entityOne.title
        reusableView.detailView.text = entityOne.desc
        
        return reusableView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entityOne = self.dataArray[indexPath.section]
        let entityTwo = entityOne.list[indexPath.item]
        
        let v = JXNoticeView.init(text: entityTwo.desc ?? "")
        v.show()
    }
    //
    var _isScrollDown: Bool {
        return false
    }
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if !_isScrollDown && (collectionView.isDragging || collectionView.isDecelerating){
            self.tableView.selectRow(at: IndexPath(row: indexPath.section, section: 0), animated: true, scrollPosition: .middle)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if !_isScrollDown && (collectionView.isDragging || collectionView.isDecelerating){
            self.tableView.selectRow(at: IndexPath(row: indexPath.section , section: 0), animated: true, scrollPosition: .middle)
        }
    }
}
