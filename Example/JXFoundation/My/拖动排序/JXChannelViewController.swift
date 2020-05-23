//
//  JXChannelViewController.swift
//  Tomatos
//
//  Created by Admin on 5/6/20.
//

import UIKit
import JXFoundation

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class JXChannelViewController: JXBaseViewController {

    //collectionView
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets.init(top: 4, left: 16, bottom: 16, right: 4)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
//        if #available(iOS 10.0, *) {
//            layout.itemSize = UICollectionViewFlowLayout.automaticSize
//        }
        let width = (kScreenWidth - 20 - 4 * 3) / 4
        layout.itemSize = CGSize(width: width, height: 52)
        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: 38)
        //layout.estimatedItemSize = CGSize(width: width, height: 52)
        //layout.headerReferenceSize = UICollectionViewFlowLayoutAutomaticSize
     
        
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    var isEdit = false
    
    /// 前三个不可编辑
    var isCanEditNum = 2
    
    
    //data array
    var defaultArray = ["新闻","视频","热点","体育","游戏","关注","娱乐","直播","音乐台","会员专区"]
    var notDefaultArray = ["新闻1","视频1","热点1","体育1","游戏1","关注1","娱乐1","直播1","音乐台1","会员专区1"]
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "拖动排序"
        self.useLargeTitles = true
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(editChannels))
        
        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.collectionView.frame = CGRect(x: 0, y: self.navStatusHeight, width: view.bounds.width, height: kScreenHeight - self.navStatusHeight)
        self.view.addSubview(self.collectionView)
        self.collectionView.register(UINib(nibName: "ChannelReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIndentifierHeader)
        self.collectionView.register(UINib(nibName: "ChannelViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        let long = UILongPressGestureRecognizer(target: self, action: #selector(longPress(long:)))
        long.minimumPressDuration = 0.5
        self.collectionView.addGestureRecognizer(long)
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    // MARK: - Actions
    @objc func editChannels() {
        self.isEdit = !self.isEdit
        self.collectionView.reloadData()
    }
    @objc func longPress(long: UILongPressGestureRecognizer) {
        switch long.state {
        case UIGestureRecognizerState.began:
            if
                let indexPath = self.collectionView.indexPathForItem(at: long.location(in: self.collectionView)),
                /*默认位置不可被移动*/
                indexPath.section == 0,
                indexPath.item > isCanEditNum,
                let cell = self.collectionView.cellForItem(at: indexPath) {
                
                self.collectionView.bringSubviewToFront(cell)
                self.collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
            break
        case UIGestureRecognizerState.changed:
            if
               let indexPath = self.collectionView.indexPathForItem(at: long.location(in: self.collectionView)),
               /*默认位置不可被替换*/
               indexPath.section == 0,
               indexPath.item > isCanEditNum {
               
               self.collectionView.updateInteractiveMovementTargetPosition(long.location(in: self.collectionView))
            }
            //self.collectionView.updateInteractiveMovementTargetPosition(long.location(in: self.collectionView))
            break
        case UIGestureRecognizerState.ended:
            self.collectionView.endInteractiveMovement()
            break
        case UIGestureRecognizerState.cancelled:
            self.collectionView.cancelInteractiveMovement()
            break
        default:
            self.collectionView.cancelInteractiveMovement()
            break
        }
    }
}
// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension JXChannelViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.notDefaultArray.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.defaultArray.count
        } else {
            return self.notDefaultArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChannelViewCell
        if indexPath.section == 0 {
            cell.titleView.text = self.defaultArray[indexPath.item]
            cell.statusView.image = UIImage(named: "home_channel_delete")
            if indexPath.item > self.isCanEditNum {
                cell.statusView.isHidden = self.isEdit ? false : true
            } else {
                cell.statusView.isHidden = true
            }
        } else {
            cell.titleView.text = self.notDefaultArray[indexPath.item]
            cell.statusView.isHidden = false
            cell.statusView.image = UIImage(named: "home_channel_add")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIndentifierHeader, for: indexPath) as! ChannelReusableView
        if self.defaultArray.count > 0 && indexPath.section == 0 {
            reusableView.titleView.text = "我的频道"
            if self.isEdit {
                reusableView.detailView.text = "拖拽进行排序"
            } else {
                reusableView.detailView.text = "点击进入频道"
            }
        } else if self.notDefaultArray.count > 0 && indexPath.section == 1 {
            reusableView.titleView.text = "推荐频道"
            reusableView.detailView.text = "点击添加频道"
        }
        return reusableView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //删除
            if self.isEdit {
                //默认频道back
                if indexPath.item > isCanEditNum {
                    //非默认，移除
                    let element = self.defaultArray[indexPath.item]
                    self.notDefaultArray.append(element)
                    self.defaultArray.remove(at: indexPath.item)
                    
                    collectionView.reloadData()
                } else {
                    //固定频道，不响应
                }
            //返回
            } else {
                //back
            }
        } else {
            //添加
            let element = self.notDefaultArray[indexPath.item]
            self.defaultArray.append(element)
            self.notDefaultArray.remove(at: indexPath.item)
            
            collectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        //限定哪些可以移动
        if indexPath.section == 0 && self.isEdit == true  && indexPath.item > 2 {
            return true
        }
        return false
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let element = self.defaultArray[sourceIndexPath.item]
        self.defaultArray.remove(at: sourceIndexPath.item)
        
        if destinationIndexPath.section == 0 {
            //限定区域不能插入，以手势来限定，删除
            self.defaultArray.insert(element, at: destinationIndexPath.item)
        } else if destinationIndexPath.section == 1 {
            self.notDefaultArray.insert(element, at: destinationIndexPath.item)
        }
    }
}
