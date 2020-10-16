//
//  CategoryViewController.swift
//  JXFoundation_Example
//
//  Created by 杜进新 on 2018/7/25.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let reuseIdentifierOne = "reuseIdentifierOne"
private let reuseIdentifierTwo = "reuseIdentifierTwo"
private let reuseIdentifierThree = "reuseIdentifierThree"

class CategoryViewController: JXBaseViewController {
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
        
        
     
        self.handleData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleData() {
            
        guard
            let path = Bundle.main.path(forResource: "JXFoundation", ofType: "json"),
            let string = try? String.init(contentsOf: URL(fileURLWithPath: path)),
            let data = string.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed,.mutableContainers,.mutableContainers]),
            let jsonArray = json as? Array<Any>  else {
                return
        }
        
//        jsonArray.forEach { (itemOne) in
//            guard let dictOne = itemOne as? Dictionary<String, Any> else {
//                return
//            }
//            let entityOne = CategoryEntity()
//            entityOne.setValuesForKeys(dictOne)
//
//            if let subOne = dictOne["sub"] as? Array<Any> {
//                subOne.forEach { (itemTwo) in
//                    guard let dictTwo = itemTwo as? Dictionary<String, Any> else {
//                        return
//                    }
//                    let entityTwo = CategoryEntity()
//                    entityTwo.setValuesForKeys(dictTwo)
//
//                    if let subTwo = dictTwo["sub"] as? Array<Any> {
//                        subTwo.forEach { (itemThree) in
//                            guard let dictThree = itemThree as? Dictionary<String, Any> else {
//                                return
//                            }
//                            let entityThree = CategoryEntity()
//                            entityThree.setValuesForKeys(dictThree)
//
//
//
//                            entityTwo.list.append(entityThree)
//                        }
//                    }
//
//                    entityOne.list.append(entityTwo)
//                }
//            }
//
//
//            self.dataArray.append(entityOne)
//        }
        
        jsonArray.forEach { (itemOne) in
            guard let dictOne = itemOne as? Dictionary<String, Any> else {
                return
            }
            let entityOne = CategoryEntity()
            entityOne.setValuesForKeys(dictOne)
            
            let entityOne_copy = self.handleDictionary(dict: dictOne, to: entityOne)
            
            self.dataArray.append(entityOne_copy)
        }
        
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    /// 递归处理子类嵌套数据
    /// - Parameters:
    ///   - dict: <#dict description#>
    ///   - entity: <#entity description#>
    /// - Returns: <#description#>
    func handleDictionary(dict: Dictionary<String, Any>, to entity: CategoryEntity) -> CategoryEntity {
        if let arr = dict["sub"] as? Array<Any> {
            arr.forEach { (item) in
                guard let subDict = item as? Dictionary<String, Any> else {
                    return
                }
                let subEntity = CategoryEntity()
                subEntity.setValuesForKeys(subDict)
                
                let subEntity_copy = self.handleDictionary(dict: subDict, to: subEntity)
                

                entity.list.append(subEntity_copy)
            }
        }
        return entity
    }
    
}
// MARK: - UITableViewDataSource & UITableViewDelegate
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if self.selectRow != indexPath.row {
            self.selectRow = indexPath.row
            self.collectionView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension CategoryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.dataArray.count > 0 {
            let entity = self.dataArray[self.selectRow]
            return entity.list.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataArray.count > 0 {
            let entityTwo = self.dataArray[self.selectRow]
            let entityThree = entityTwo.list[section]
            return entityThree.list.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierThree, for: indexPath) as! ChannelViewCell
        let entityOne = self.dataArray[self.selectRow]
        let entityTwo = entityOne.list[indexPath.section]
        let entityThree = entityTwo.list[indexPath.item]
        
        cell.titleView.text = entityThree.title
        cell.statusView.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifierTwo, for: indexPath) as! ChannelReusableView
        
        let entityOne = self.dataArray[self.selectRow]
        let entityTwo = entityOne.list[indexPath.section]
        
        reusableView.titleView.text = entityTwo.title
        reusableView.detailView.text = entityTwo.desc
        
        
        
        reusableView.clickBlock = {[weak self](index) in
            
            
            let vc = TwoCategroyViewController()
            vc.selectRow = indexPath.section
            entityOne.list.forEach { (e: CategoryEntity) in
                vc.dataArray.append(e)
            }
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        return reusableView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entityOne = self.dataArray[self.selectRow]
        let entityTwo = entityOne.list[indexPath.section]
        let entityThree = entityTwo.list[indexPath.item]
        
        let v = JXNoticeView.init(text: entityThree.desc ?? "")
        v.show()
    }
}
extension CategoryViewController {

}

class CategoryEntity: BaseModel {
    @objc var title: String?
    @objc var desc: String?
    @objc var list = Array<CategoryEntity>()
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
