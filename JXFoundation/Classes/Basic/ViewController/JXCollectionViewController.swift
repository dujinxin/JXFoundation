//
//  JXCollectionViewController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

open class JXCollectionViewController: JXScrollViewController {

    open override var scrollView: UIScrollView? {
        return self.collectionView
    }
    //collectionView
    public lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets.init(top: 0.5, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0.5
        layout.minimumInteritemSpacing = 0.5
        
        if #available(iOS 10.0, *) {
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        layout.estimatedItemSize = CGSize(width: UIScreen.main.screenWidth / 3, height: UIScreen.main.screenHeight / 3)
        
        //        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        //        layout.headerReferenceSize = UICollectionViewFlowLayoutAutomaticSize
        //        layout.footerReferenceSize = UICollectionViewFlowLayoutAutomaticSize
        
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    //data array
    public var dataArray = NSMutableArray()
    public var page : Int = 1
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if self.useCustomNavigationBar {
            if #available(iOS 11.0, *) {
                self.collectionView.contentInsetAdjustmentBehavior = .never
            } else {
                self.automaticallyAdjustsScrollViewInsets = false
            }
        }
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.defaultView.frame = view.bounds
        self.customNavigationBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: self.navStatusHeight)
        let y = self.navStatusHeight
        self.collectionView.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: (view.bounds.height - y))
    }
}
extension JXCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
