//
//  JXBarView.swift
//  FBSnapshotTestCase
//
//  Created by 杜进新 on 2018/7/25.
//

import UIKit

private let reuseIdentifier = "Cell"

@objc public protocol JXBarViewDelegate {
    func jxBarView(barView: JXBarView, didClick index: Int) -> Void
    @objc optional func jxBarView(_ : JXBarView, to indexPath: IndexPath) -> Void
    @objc optional func jxBarViewDidScroll(scrollView: UIScrollView) -> Void
}

public class JXBarView: UIView {
    
    public var titles = Array<String>()
    public var delegate : JXBarViewDelegate?
    public var selectedIndex = 0
    
    public var attribute = TopBarAttribute()
    
    
    public var bottomLineWidth : CGFloat = 0
    public var isBottomLineEnabled : Bool = false {
        didSet{
            if isBottomLineEnabled {
                let indexPath = IndexPath(item: self.selectedIndex, section: 0)
                self.containerView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                
                addSubview(self.bottomLineView)
                self.bottomLineView.frame = CGRect(x: CGFloat(self.selectedIndex) * self.bottomLineWidth, y: self.bounds.height - 1, width: self.bottomLineWidth, height: 1)
            }
        }
    }
    public lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    public var itemSize: CGSize = CGSize(){
        didSet{
            let count = CGFloat(self.titles.count)
            if itemSize.width * count > self.bounds.width {
                self.containerView.bounces = true
                self.containerView.isScrollEnabled = true
            } else {
                self.containerView.bounces = false
                self.containerView.isScrollEnabled = false
            }
        }
    }
    public lazy var containerView: UICollectionView = {
        
        let flowlayout = UICollectionViewFlowLayout.init()
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: CGRect(origin: CGPoint(), size: CGSize(width: self.bounds.width, height: self.bounds.height)), collectionViewLayout: flowlayout)
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        return collectionView
    }()
    public init(frame: CGRect, titles: Array<String>) {
        super.init(frame: frame)
        if titles.count > 0 {
            self.bottomLineWidth = frame.width / CGFloat(titles.count)
        }
        
        self.titles = titles
        self.addSubview(self.containerView)
        self.containerView.reloadData()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
        self.bottomLineView.frame = CGRect(x: 0, y: self.bounds.height - 1, width: bottomLineWidth, height: 1)
    }
    func clickItem(index: Int) {

        selectedIndex = index

        UIView.animate(withDuration: 0.3, animations: {
            self.bottomLineView.frame = CGRect(x: CGFloat(index) * self.bottomLineWidth, y: self.bounds.height - 1, width: self.bottomLineWidth, height: 1)
        }) { (finished) in
            //
        }
        if self.delegate != nil {
            self.delegate?.jxBarView(barView: self, didClick: index)
        }
    }
}
extension JXBarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //DataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = containerView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCell
        if titles.count > indexPath.item {
            cell.titleView.text = titles[indexPath.item]
            cell.attribute = self.attribute
        }
        return cell
    }
    //DelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.titles.count > 0 {
            let count = CGFloat(self.titles.count)
            if itemSize.width * count > self.bounds.width {
                return itemSize
            } else {
                let size = CGSize(width: self.bounds.width / CGFloat(self.titles.count), height: self.bounds.height)
                return size
            }
        }
        return itemSize
    }
    //delegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCell
        cell.attribute = attribute
        
        clickItem(index: indexPath.item)
        //delegate
        
        //block
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCell
        cell.attribute = attribute
    }
    //scrollView
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.delegate != nil {
            self.delegate?.jxBarViewDidScroll!(scrollView: self.containerView)
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let page = offset / self.frame.size.width
        let indexPath = IndexPath.init(item: Int(page), section: 0)

        self.containerView.reloadItems(at: [indexPath as IndexPath])

        if self.delegate != nil{
            self.delegate?.jxBarView!(self, to: indexPath)
        }
    }
}
class ItemCell: UICollectionViewCell {
    lazy var titleView: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        return label
    }()
    var title: String? = "" {
        didSet {
            self.titleView.text = title
        }
    }
    var attribute: TopBarAttribute? {
        didSet {
            if isSelected {
                self.titleView.textColor = attribute?.highlightedColor
            } else {
                self.titleView.textColor = attribute?.normalColor
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.titleView.center = self.contentView.center
        self.titleView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
}
