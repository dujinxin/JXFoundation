//
//  JXScrollCycleView.swift
//  JXFoundation_Example
//
//  Created by Admin on 10/16/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

private let reuseIdentifier = "Cell"

public enum JXScrollCycleViewScrollDirection {
    case horizontal
    case vertical
}

enum JXScrollCycleViewDragDirection {
    case left
    case right
    case top
    case bottom
}

public protocol JXScrollCycleViewDelegate {
    func scrollCycleView(scrollCycleView : JXScrollCycleView,didSelectItemAt index: Int) -> Void
    
    func numberOfItems(in scrollCycleView: JXScrollCycleView) -> Int
    //func scrollCycleView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func scrollCycleView(_ scrollCycleView: JXScrollCycleView, StringForItemAt indexPath: IndexPath) -> String
}

public class JXScrollCycleView: UIView {

    //MARK: private properties
    public lazy var containerView: UICollectionView = {
        
        let flowlayout = UICollectionViewFlowLayout.init()
        if self.attribute.itemSize.width == 0 {
            flowlayout.itemSize = self.bounds.size
        } else {
            flowlayout.itemSize = self.attribute.itemSize
        }
        flowlayout.scrollDirection = .horizontal
        //flowlayout.scrollDirection = .vertical
        
        flowlayout.minimumLineSpacing  = 0.0
        flowlayout.minimumInteritemSpacing = 0.0
        flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //flowlayout.headerReferenceSize = CGSize.init(width: self.rect.size.width, height: 44)
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowlayout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
      
        collectionView.backgroundColor = UIColor.brown
        //collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(UINib(nibName: "LiveItemViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        return collectionView
    }()
    lazy var timer: Timer = {
        let t = Timer(timeInterval: self.scrollInterval, target: self, selector: #selector(scrollWithAnimate), userInfo: nil, repeats: true)
        RunLoop.current.add(t, forMode: .common)
        return t
    }()
    var attribute: JXAttribute = JXAttribute() {
        didSet{
            self.backgroundColor = attribute.backgroundColor
        }
    }
    var currentIndex = 0
    var maxSection = 3
    var dragDirection : JXScrollCycleViewDragDirection = .left
    //MARK: public properties & methods
    /// NSString || NSSAttrbuteString
    
    /// delegate : JXScrollTitleViewDelegate
    public var delegate : JXScrollCycleViewDelegate?
    /// 回调
    public var clickBlock : ((_ view: UIView, _ index: Int) -> ())?
    public var selectedIndex = 0 {
        didSet{
            //self.resetStatus(animateType: 0)
        }
    }
    public var scrollInterval : TimeInterval = 2
    public var scrollDirection : JXScrollCycleViewScrollDirection = .horizontal {
        didSet{
            guard let collectionViewLayout : UICollectionViewFlowLayout = self.containerView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            collectionViewLayout.scrollDirection = (scrollDirection == .horizontal) ? .horizontal : .vertical
            self.containerView.collectionViewLayout = collectionViewLayout
            self.scrollToItem(at: IndexPath(item: 0, section: 1), animated: false)
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// 创建一个滑动视图
    /// - Parameters:
    ///   - frame: frame
    ///   - delegate: 代理
    ///   - titles: 标题集合 String  || NSAttributedString
    ///   - attribute: 常用属性设置
    public init(frame: CGRect, delegate: JXScrollCycleViewDelegate, attribute: JXAttribute) {
        super.init(frame: frame)
        
        self.delegate = delegate
        self.attribute = attribute
        
        
        self.backgroundColor = attribute.backgroundColor
        
        self.addSubview(self.containerView)
        self.containerView.scrollToItem(at: IndexPath(item: 0, section: 1), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    deinit {
        self.timer.invalidate()
        print("JXScrollCycleView deinit")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()

        self.containerView.frame = CGRect(x: attribute.sectionEdgeInsets.left, y: attribute.sectionEdgeInsets.top, width: bounds.width - attribute.sectionEdgeInsets.left - (-attribute.sectionEdgeInsets.right), height: bounds.height - attribute.sectionEdgeInsets.top - (-attribute.sectionEdgeInsets.bottom))
        
    }
    
    //MARK: private methods
    
    /// 切换视图赋值
    /// - Parameters:
    ///   - button: 视图
    ///   - title: String  || NSAttributedString
    func setButtonTitle(_ button: UIButton ,_ title: Any) {
        if title is String {
            button.setTitle(title as? String, for: .normal)
        } else {
            button.setAttributedTitle(title as? NSAttributedString, for: .normal)
        }
    }
    /// 切换方法
    @objc func scrollWithAnimate() {
        guard let delegate = self.delegate else {
            return
        }
        let count = delegate.numberOfItems(in: self)
        self.isAutoScrolling = true
        
        if currentIndex == count - 1 {
            currentIndex = 0
            let indexPath = IndexPath(item: currentIndex, section: 1)
            self.scrollToItem(at: indexPath, animated: true)
        } else {
            currentIndex += 1
            let indexPath = IndexPath(item: currentIndex, section: 1)
            self.scrollToItem(at: indexPath, animated: true)

            if currentIndex == count - 1 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25 ) {
                    if self.scrollDirection == .horizontal {
                        self.containerView.setContentOffset(CGPoint(x: Int(self.containerView.bounds.width) * (count - 1), y: 0), animated: false)
                    } else {
                        self.containerView.setContentOffset(CGPoint(x: 0, y: Int(self.containerView.bounds.height) * (count - 1)), animated: false)
                    }
                }
            }
        }
    }
    public func scrollToItem(at indexPath: IndexPath, animated: Bool) {
        let scrollPosition = self.scrollDirection == .horizontal ? UICollectionView.ScrollPosition.centeredHorizontally : UICollectionView.ScrollPosition.centeredVertically //UICollectionView.ScrollPosition.centeredVertically 用这个有问题，因为是从中间滚动，所以会影响分页，导致显示一屏显示两页
        self.containerView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        //print(indexPath)
    }

    //MARK: public methods
    ///是否为用户拖拽
    var isUserDraging = false
    ///是否正在自动滚动
    var isAutoScrolling = false
    
    @objc func start() {
        if let delegate = self.delegate, delegate.numberOfItems(in: self) <= 1 {
            return
        }
        self.timer.fireDate = Date(timeIntervalSinceNow: self.scrollInterval)
    }
    @objc func stop() {
        self.isAutoScrolling = false
        self.timer.invalidate()
    }
    @objc func pause() {
        self.isAutoScrolling = false
        self.timer.fireDate = Date.distantFuture
    }
    
}
// MARK: - UIScrollViewDelegate
extension JXScrollCycleView : UIScrollViewDelegate {
    /// 1 scrollViewDidScroll, 2 scrollViewDidEndDecelerating
    func resetContentOffset(scrollView: UIScrollView, status: Int) {
        
        guard let delegate = self.delegate else {
            return
        }
        let count = delegate.numberOfItems(in: self)
        if count < 2 {
            return
        }
        
        var index = 0
        if self.scrollDirection == .horizontal {
//            let contentOffset_mid = scrollView.contentOffset.x + (status == 1 ? 0 : self.frame.size.width / 2)
//            index = Int(contentOffset_mid / self.frame.size.width)
            index = Int(scrollView.contentOffset.x / self.containerView.frame.size.width)
            
        } else {
            index = Int(scrollView.contentOffset.y / self.containerView.frame.size.height)
        }
        //当前显示IndexPath [1,max],向左或下拖拽，需要切换到 [0,max]；向右或上拖拽，则无需处理
        if index == (count * 2 - 1) {
            currentIndex = count - 1
            
            if self.scrollDirection == .horizontal {
                if self.dragDirection == .left {
                    self.containerView.contentOffset = CGPoint(x: Int(self.containerView.bounds.width) * currentIndex, y: 0)
                } else {
                    
                }
            } else {
                self.containerView.contentOffset = CGPoint(x: 0, y: Int(self.containerView.bounds.height) * currentIndex)
            }
        //当前显示IndexPath [1,0], 向左或下拖拽，无需处理；向右或上拖拽，需要切换到 [2,0]
        } else if index == count {
            currentIndex = 0
            
            if self.scrollDirection == .horizontal {
                if self.dragDirection == .left {
                    
                } else {
                    //self.containerView.contentOffset = CGPoint(x: Int(self.containerView.bounds.width) * count * 2, y: 0)
                    //self.containerView.contentOffset = CGPoint(x: Int(self.containerView.bounds.width) * count * 2, y: 0)
                }
                //self.containerView.contentOffset = CGPoint(x: Int(self.containerView.bounds.width) * count, y: 0)
            } else {
                self.containerView.contentOffset = CGPoint(x: 0, y: Int(self.containerView.bounds.width) * count)
            }
            //
        }
//        else if (index < count && index >= 0) {
//            currentIndex = index
//            if self.scrollDirection == .horizontal {
//                self.containerView.contentOffset = CGPoint(x: Int(self.containerView.bounds.width) * (count + index), y: 0)
//            } else {
//                self.containerView.contentOffset = CGPoint(x: 0, y: Int(self.containerView.bounds.width) * count)
//            }
//        }
        else {
            currentIndex = Int(index) - count
        }
        if !(scrollView.isDragging && scrollView.isDecelerating) && !self.isAutoScrolling && !self.isUserDraging {
            self.start()
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            self.pause()
            print("scrollViewDidScroll",scrollView.isDragging,scrollView.isDecelerating)
            
            self.resetContentOffset(scrollView: scrollView, status: 1)
        }
    }
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDecelerating")
        
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        
        self.resetContentOffset(scrollView: scrollView, status: 2)
        
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        self.isUserDraging = true
        self.pause()
    }
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("scrollViewWillEndDragging")
        
        if self.scrollDirection == .horizontal {
            self.dragDirection = velocity.x > 0 ? .left : .right
        } else {
            self.dragDirection = velocity.y > 0 ? .bottom : .top
        }
        
        print(velocity)
        
//        guard let delegate = self.delegate else {
//            return
//        }
//        let count = delegate.numberOfItems(in: self)
//        if count < 2 {
//            return
//        }
//
//        var index = 0
//        if self.scrollDirection == .horizontal {
//            index = Int(scrollView.contentOffset.x / self.frame.size.width)
//        } else {
//            index = Int(scrollView.contentOffset.y / self.frame.size.height)
//        }
//        //当前显示IndexPath [1,max],需要切换到 [0,max]
//        if index == (count - 1) {
//            currentIndex = count - 1
//
//            if self.scrollDirection == .horizontal {
//                self.containerView.contentOffset = CGPoint(x: Int(self.containerView.bounds.width) * (count * 2 - 1), y: 0)
//
//            } else {
//                self.containerView.contentOffset = CGPoint(x: 0, y: Int(self.containerView.bounds.height) * (count * 2 - 1))
//            }
//
//
//        //当前显示IndexPath [2,min], 需要切换到 [1,min]
//        } else if index == count * 2 {
//            currentIndex = 0
//
//            if self.scrollDirection == .horizontal {
//                self.containerView.contentOffset = CGPoint(x: Int(self.containerView.bounds.width) * count, y: 0)
//            } else {
//                self.containerView.contentOffset = CGPoint(x: 0, y: Int(self.containerView.bounds.width) * count)
//            }
//        } else {
//            currentIndex = Int(index) - count
//        }
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        self.isUserDraging = false
        self.start()
    }
}
// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension JXScrollCycleView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let delegate = self.delegate else {
            return 1
        }
        if delegate.numberOfItems(in: self) == 1 {
            return 1
        }
        return 3
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let delegate = self.delegate else {
            return 0
        }
        return delegate.numberOfItems(in: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LiveItemViewCell
        
        cell.LiveNameLabel.text = "\(indexPath.section)-\(indexPath.item)"
        
        if indexPath.item == 0 {
            cell.LiveBgView.backgroundColor = UIColor.red
        } else if indexPath.item == 1 {
            cell.LiveBgView.backgroundColor = UIColor.yellow
        } else {
            cell.LiveBgView.backgroundColor = UIColor.blue
        }
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth, height: 100)
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let target = self.delegate {
            target.scrollCycleView(scrollCycleView: self, didSelectItemAt: indexPath.item)
        }
        if let block = self.clickBlock {
            block(self, indexPath.item)
        }
        print(indexPath.item)
    }
}
