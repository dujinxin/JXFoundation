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

public protocol JXScrollCycleViewDelegate {
    func scrollCycleView(scrollCycleView : JXScrollCycleView,didSelectItemAt index: Int) -> Void
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
    var scrollInterval : TimeInterval = 2
    
    var attribute: JXAttribute = JXAttribute() {
        didSet{
            self.backgroundColor = attribute.backgroundColor
//            self.leftButton.titleLabel?.font = UIFont.systemFont(ofSize: attribute.normalFontSize)
//            self.rightButton.titleLabel?.font = UIFont.systemFont(ofSize: attribute.normalFontSize)
        }
    }
    var currentIndex = 0
    
    //MARK: public properties & methods
    /// NSString || NSSAttrbuteString
    var titles: Array<Any> = Array<Any>() {
        didSet{
            initSubViews(titles)
        }
    }
    /// delegate : JXScrollTitleViewDelegate
    public var delegate : JXScrollCycleViewDelegate?
    /// 回调
    public var clickBlock : ((_ view: UIView, _ index: Int) -> ())?
    public var selectedIndex = 0 {
        didSet{
            //self.resetStatus(animateType: 0)
        }
    }
    public var scrollDirection : JXScrollCycleViewScrollDirection = .horizontal {
        didSet{
            guard let collectionViewLayout : UICollectionViewFlowLayout = self.containerView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            collectionViewLayout.scrollDirection = (scrollDirection == .horizontal) ? .horizontal : .vertical
            self.containerView.collectionViewLayout = collectionViewLayout
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
    public init(frame: CGRect, delegate: JXScrollCycleViewDelegate, titles: Array<Any>, attribute: JXAttribute) {
        super.init(frame: frame)
        
        self.titles = titles
        self.delegate = delegate
        self.attribute = attribute
        
        
        self.backgroundColor = attribute.backgroundColor
        
        self.addSubview(self.containerView)
        
        self.initSubViews(titles)
    }
    /// 创建一个滑动视图
    /// - Parameters:
    ///   - frame: frame
    ///   - titles: 标题集合 String  || NSAttributedString
    ///   - attribute: 常用属性设置
    ///   - clickBlock: 回调
    @objc public init(frame: CGRect, titles: Array<Any>, attribute: JXAttribute, clickBlock: ((_ view: UIView,_ index: Int) -> ())?) {
        super.init(frame: frame)
        
        self.titles = titles
        self.clickBlock = clickBlock
        self.attribute = attribute
        
        self.backgroundColor = attribute.backgroundColor
        
        self.addSubview(self.containerView)
        self.initSubViews(titles)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()

        self.containerView.frame = CGRect(x: attribute.sectionEdgeInsets.left, y: attribute.sectionEdgeInsets.top, width: bounds.width - attribute.sectionEdgeInsets.left - (-attribute.sectionEdgeInsets.right), height: bounds.height - attribute.sectionEdgeInsets.top - (-attribute.sectionEdgeInsets.bottom))
        
    }
    
    //MARK: private methods
    @objc func tabButtonAction(button : UIButton) {
        
        self.selectedIndex = button.tag
       
        if let target = self.delegate {
            target.scrollCycleView(scrollCycleView: self, didSelectItemAt: button.tag)
        }
        if let block = self.clickBlock {
            block(self, self.selectedIndex)
        }
    }
    private func initSubViews(_ titles: Array<Any>) {
        
    }
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
        
        if currentIndex == self.titles.count - 1 {
            currentIndex = 0
            let indexPath = IndexPath(item: currentIndex, section: 2)
            self.scrollToItem(at: indexPath, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                self.containerView.setContentOffset(CGPoint(x: Int(self.containerView.bounds.width) * (self.titles.count - 1), y: 0), animated: false)
            }
        } else {
            currentIndex += 1
            let indexPath = IndexPath(item: currentIndex, section: 1)
            self.scrollToItem(at: indexPath, animated: true)
        }
    }
    public func scrollToItem(at indexPath: IndexPath, animated: Bool) {
//        if let cell = self.containerView.visibleCells.first, let indexP = self.containerView.indexPath(for: cell), indexPath == indexP {
//            return
//        }
        let scrollPosition = self.scrollDirection == .horizontal ? UICollectionView.ScrollPosition.centeredHorizontally : UICollectionView.ScrollPosition.top //UICollectionView.ScrollPosition.centeredVertically 用这个有问题，因为是从中间滚动，所以会影响分页，导致显示一屏显示两页
        self.containerView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        print(indexPath)
    }
    /// 切换方法
    @objc func scrollWithAnimate1() {
        var offset = self.containerView.contentOffset
        offset.x += 1
        self.containerView.contentOffset = offset
        
        if offset.x == self.containerView.bounds.width {
            self.containerView.setContentOffset(CGPoint(), animated: false)
            
            if currentIndex == self.titles.count - 1 {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
            
//            //设置左边
//            self.leftButton.tag = currentIndex
//            self.setButtonTitle(self.leftButton, titles[currentIndex])
//
//            //设置右边
//            if currentIndex + 1 >= titles.count {
//                self.rightButton.tag = 0
//                self.setButtonTitle(self.rightButton, titles[0])
//            } else {
//                self.rightButton.tag = currentIndex + 1
//                self.setButtonTitle(self.rightButton, titles[currentIndex + 1])
//            }
        }
    }
    //MARK: public methods
    @objc func beginScroll() {
//        if self.titles.count < 2 || self.containerView.contentSize.width <= self.containerView.bounds.width {
//            return
//        }
        self.timer.fire()
    }
    @objc func stopScroll() {
        
        self.timer.invalidate()
    }
    @objc func pause() {
        self.timer.fireDate = Date.distantPast
        
    }
    deinit {
        self.timer.invalidate()
    }
    
}
// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension JXScrollCycleView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.titles.count > 1 {
            return 3
        } else {
            return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LiveItemViewCell
        
        cell.LiveNameLabel.text = "\(indexPath.item)"
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth, height: 100)
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
