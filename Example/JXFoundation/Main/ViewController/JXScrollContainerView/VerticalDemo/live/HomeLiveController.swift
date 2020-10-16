//
//  HomeLiveController.swift
//  Tomatos
//
//  Created by Admin on 9/30/20.
//

import UIKit
import JXFoundation

private let reuseIdentifierItem = "reuseIdentifierItem"
private let reuseIdentifierHeader = "reuseIdentifierHeader"
private let reuseIdentifierFooter = "reuseIdentifierFooter"

class HomeLiveController: UIViewController {
    
    //collectionView
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets.init(top: 12, left: 0, bottom: 12, right: 0)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        let width = (kScreenWidth - 84 - 12 - 12) / 2
        layout.itemSize = CGSize(width: width, height: width)
//        layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
//        layout.estimatedItemSize = CGSize(width: width, height: width)
        layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 48)
        layout.footerReferenceSize = CGSize(width: self.view.bounds.width, height: 62)
        
//        layout.headerReferenceSize = UICollectionViewFlowLayoutAutomaticSize
//        layout.footerReferenceSize = UICollectionViewFlowLayoutAutomaticSize
        
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "LiveHeaderReusableView", bundle: nil), forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifierHeader)
        collectionView.register(UINib(nibName: "HomeCommonFooterReusableView", bundle: nil), forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseIdentifierFooter)
        collectionView.register(UINib(nibName: "LiveItemViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifierItem)
        
        return collectionView
    }()
    
    //data array
    var dataArray = [Any]()
    
    /// 一级列表选中的行
    var selectRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.frame = self.view.bounds
        self.collectionView.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 84 - 12, height: kScreenHeight - (kNavStatusHeight + 10) - 44)
        self.view.addSubview(self.collectionView)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension HomeLiveController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.dataArray.count > 0 {
//            let entityTwo = self.dataArray[self.selectRow]
//            let entityThree = entityTwo.list[section]
//            return entityThree.list.count
//        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierItem, for: indexPath) as! LiveItemViewCell
//        let entityOne = self.dataArray[self.selectRow]
//        let entityTwo = entityOne.list[indexPath.section]
//        let entityThree = entityTwo.list[indexPath.item]
//
//        cell.titleView.text = entityThree.title
//        cell.statusView.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifierHeader, for: indexPath) as! LiveHeaderReusableView
            
            
            return reusableView
        } else {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseIdentifierFooter, for: indexPath) as! HomeCommonFooterReusableView
            reusableView.footerBlock = {
                print(indexPath)
            }
            return reusableView
        }
        
//
//        let entityOne = self.dataArray[self.selectRow]
//        let entityTwo = entityOne.list[indexPath.section]
//
//        reusableView.titleView.text = entityTwo.title
//        reusableView.detailView.text = entityTwo.desc
//
//
//
//        reusableView.clickBlock = {[weak self](index) in
//
//
//            let vc = TwoCategroyViewController()
//            vc.selectRow = indexPath.section
//            entityOne.list.forEach { (e: CategoryEntity) in
//                vc.dataArray.append(e)
//            }
//
//            self?.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let entityOne = self.dataArray[self.selectRow]
//        let entityTwo = entityOne.list[indexPath.section]
//        let entityThree = entityTwo.list[indexPath.item]
//
//        let v = JXNoticeView.init(text: entityThree.desc ?? "")
//        v.show()
    }
}
