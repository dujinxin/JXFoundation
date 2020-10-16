//
//  MainController.swift
//  Tomatos
//
//  Created by Admin on 9/30/20.
//

import UIKit
import JXFoundation

private let reuseIdentifierItem1 = "reuseIdentifierItem1"
private let reuseIdentifierItem2 = "reuseIdentifierItem2"
private let reuseIdentifierHeader = "reuseIdentifierHeader"
private let reuseIdentifierFooter = "reuseIdentifierFooter"

class MainController: UIViewController {
    
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
        collectionView.register(UINib(nibName: "MainHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifierHeader)
        collectionView.register(UINib(nibName: "HomeCommonFooterReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseIdentifierFooter)
        collectionView.register(UINib(nibName: "MainContentCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifierItem1)
        collectionView.register(UINib(nibName: "MainEntryCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifierItem2)
        
        return collectionView
    }()
    
    //data array
    var dataArray = [Any]()
    
    /// 一级列表选中的行
    var selectRow = 0
    
    var secondTitles: Array<String> {
        return ["热门榜单","每日签到"]
    }
    var secondImages: Array<String> {
        return ["home_main_rank","home_main_sign"]
    }
    
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
extension MainController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 9
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierItem1, for: indexPath) as! MainContentCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierItem2, for: indexPath) as! MainEntryCell
            cell.mainImageView.image = UIImage(named: self.secondImages[indexPath.item])
            cell.mainTextLabel.text = self.secondTitles[indexPath.item]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 0 {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifierHeader, for: indexPath) as! MainHeaderReusableView
            reusableView.headerBlock = {
                print(indexPath)
            }
            
            return reusableView
        } else if kind == UICollectionView.elementKindSectionFooter && indexPath.section == 1  {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseIdentifierFooter, for: indexPath) as! HomeCommonFooterReusableView
            reusableView.footerButton.setTitle("进入社区", for: .normal)
            reusableView.footerBlock = {
                print(indexPath)
            }
            return reusableView
        } else {
            return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets.init(top: 12, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets.init(top: 12, left: 0, bottom: 12, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = (kScreenWidth - 84 - 12 - 12 * 2) / 3
            return CGSize(width: width, height: width * 116 / 85)
        } else {
            let width = (kScreenWidth - 84 - 12 - 12) / 2
            return CGSize(width: width, height: width * 78.0 / 134.0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: self.view.bounds.width, height: 48)
        }
        return CGSize()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: self.view.bounds.width, height: 62)
        }
        return CGSize()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
