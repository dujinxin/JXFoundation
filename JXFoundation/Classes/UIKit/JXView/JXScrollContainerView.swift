//
//  JXHorizontalView.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/21.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let reuseIndentifierHeader = "reuseIndentifierHeader"
private let reuseIndentifierFooter = "reuseIndentifierFooter"

public enum JXScrollContainerViewScrollDirection {
    case horizontal
    case vertical
}

public protocol JXScrollContainerViewDelegate {
    
    func scrollContainerView(_ scrollContainerView : JXScrollContainerView, to indexPath: IndexPath) -> Void
    func scrollContainerViewDidScroll(scrollView: UIScrollView) -> Void
}
/// 目前没有使用，双层嵌套时会用到viewForItemAt
@objc public protocol JXScrollContainerViewDataSource: NSObjectProtocol {
    @objc optional func scrollContainerView(_ scrollContainerView: JXScrollContainerView, numberOfItemsInSection section: Int) -> Int
    @objc optional func scrollContainerView(_ scrollContainerView : JXScrollContainerView, viewForItemAt indexPath: IndexPath) -> UIView
}

public class JXScrollContainerView: UIView {
    //MARK: 双层嵌套,JXScrollContainerView作为二级容器时会用到
    var mainScrollView : UIScrollView?
    
    
    var subScrollView : UIScrollView?
    /// 代理兼父控制器
    let parentViewController : UIViewController
    /// 容器
    public var containers = Array<Any>()
    /// 当前所处的页码
    public var currentPage = 0
    /// 滚动切换方向，主要分为horizontal，vertical
    public var scrollDirection : JXScrollContainerViewScrollDirection = .horizontal {
        didSet{
            guard let collectionViewLayout : UICollectionViewFlowLayout = self.containerView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            collectionViewLayout.scrollDirection = (scrollDirection == .horizontal) ? .horizontal : .vertical
            self.containerView.collectionViewLayout = collectionViewLayout
        }
    }
    var dataSource : JXScrollContainerViewDataSource?
    var delegate : JXScrollContainerViewDelegate?
    /// 手动管理viewWillAppear(_:) 、 viewDidAppear(_:) 、viewWillDisappear(_:) 、viewDidDisappear(_:) ，需要父控制器重写次属性，改为false。暂时不开放，无法控制viewDidDisappear(_:)，viewDidAppear(_:)无法控制
    var shouldAutomaticallyForwardAppearanceMethods: Bool
    
    /// 主容器，UICollectionView，分页切换，包含的视图为controller.view 或者 view
    public lazy var containerView: UICollectionView = {
        
        let flowlayout = UICollectionViewFlowLayout.init()
        flowlayout.itemSize = self.bounds.size
        flowlayout.scrollDirection = .horizontal
        //flowlayout.scrollDirection = .vertical
        flowlayout.minimumLineSpacing  = 0.0
        flowlayout.minimumInteritemSpacing = 0.0
        flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //flowlayout.headerReferenceSize = CGSize.init(width: self.rect.size.width, height: 44)
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowlayout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
      
        collectionView.backgroundColor = UIColor.brown
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        return collectionView
    }()
    
    /// 初始化方法
    /// 注意⚠️：当传入viewController时，loadView，viewDidLoad两个方法会在初始化的时候一并调用，viewWillAppear 、 viewDidAppear 、viewWillDisappear、viewDidDisappear跟随parentviewcontroller
    /// 1. 建议写在viewDidLoad中的网络请求改为viewWillAppear中请求。至于每次都请求或者请求一次自己控制。因为当containers数量巨大时，会导致瞬间十几或几十个网络请求。
    /// 2. viewWillDisappear、viewDidDisappear不要做操作，手动管理调用不准确，自动管理则不会调用
    /// - Parameters:
    ///   - frame: -
    ///   - containers: 数组，元素为UIViewController或view
    ///   - parentViewController: 父控制器
    public init(frame: CGRect, containers: Array<Any>, parentViewController: UIViewController) {
    
        self.parentViewController = parentViewController
        self.delegate = parentViewController as? JXScrollContainerViewDelegate
        self.dataSource = parentViewController as? JXScrollContainerViewDataSource
        self.containers = containers
        self.shouldAutomaticallyForwardAppearanceMethods = parentViewController.shouldAutomaticallyForwardAppearanceMethods
        super.init(frame: frame)
        
        //print(self.bounds)
        
        for obj in containers {
            if let vc = obj as? UIViewController {
                if vc.isKind(of: UINavigationController.self) {
                    assert(false, "can not append UINavigationController")
                } else {
                    vc.view.frame = bounds
                    self.parentViewController.addChild(vc)
                }
            }
        }
        
        self.addSubview(self.containerView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    /// 主动调用的刷新方法
    public func reloadData() {
        let indexPath = IndexPath.init(item: currentPage, section: 0)
        self.containerView.reloadItems(at: [indexPath])
    }
    /// 滚动方法
    /// - Parameters:
    ///   - indexPath: 目标位置
    ///   - animated: 动画
    public func scrollToItem(at indexPath: IndexPath, animated: Bool) {
        if let cell = self.containerView.visibleCells.first, let indexP = self.containerView.indexPath(for: cell), indexPath == indexP {
            return
        }
        let scrollPosition = self.scrollDirection == .horizontal ? UICollectionView.ScrollPosition.centeredHorizontally : UICollectionView.ScrollPosition.top //UICollectionView.ScrollPosition.centeredVertically 用这个有问题，因为是从中间滚动，所以会影响分页，导致显示一屏显示两页
        self.containerView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        
    }
    /// 选择方法
    /// - Parameters:
    ///   - indexPath: 选择位置
    ///   - animated: 动画
    public func selectItem(at indexPath: IndexPath, animated: Bool) {
        if let cell = self.containerView.visibleCells.first, let indexP = self.containerView.indexPath(for: cell), indexPath == indexP {
            return
        }
        let scrollPosition = self.scrollDirection == .horizontal ? UICollectionView.ScrollPosition.centeredHorizontally : UICollectionView.ScrollPosition.top //UICollectionView.ScrollPosition.centeredVertically 用这个有问题，因为是从中间滚动，所以会影响分页，导致显示一屏显示两页
        
        self.containerView.selectItem(at: indexPath, animated: true, scrollPosition: scrollPosition)
    }
    
}
//MARK:UICollectionViewDelegate, UICollectionViewDataSource
extension JXScrollContainerView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if containers.count > 0 {
            return containers.count
        }
        return 0
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = containerView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if containers.count > indexPath.item {
            let obj = containers[indexPath.item]
            if let vc = obj as? UIViewController {
                vc.view.tag = 100
                vc.view.frame = cell.contentView.bounds
                if let v = cell.contentView.viewWithTag(100) {
                    v.removeFromSuperview()
                }
                if !shouldAutomaticallyForwardAppearanceMethods { vc.beginAppearanceTransition(true, animated: true) }
                cell.contentView.addSubview(vc.view)
                if !shouldAutomaticallyForwardAppearanceMethods { vc.endAppearanceTransition() }
                
                //vc.didMove(toParent: parentViewController)
            } else if(obj is UIView){
                let v = obj as! UIView
                v.frame = cell.contentView.bounds
                v.tag = 10000
                cell.contentView.addSubview(v)
            }
            if let dataSource = self.dataSource, let v = dataSource.scrollContainerView?(self, viewForItemAt: indexPath) {
//                cell.contentView.removeAllSubView()
//                v.frame = cell.contentView.bounds
//                v.tag = 10000
//                cell.contentView.addSubview(v)
            }
         }
    }
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        for i in 0..<self.containers.count {
//            let obj = self.containers[i]
//            if let vc = obj as? UIViewController {
//                if i != indexPath.item {
//                    vc.beginAppearanceTransition(false, animated: true)
//                    //vc.view.removeFromSuperview()
//            //        vc.removeFromParent()
//                    vc.endAppearanceTransition()
//                }
//            }
//        }
       
    }
}
//MARK:UIScrollViewDelegate
extension JXScrollContainerView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate = self.delegate else { return }
        delegate.scrollContainerViewDidScroll(scrollView: self.containerView)
        
        
        var page_int = 0
        
        if self.scrollDirection == .vertical {
            let offset = scrollView.contentOffset.y
            let page = offset / self.frame.size.height
            page_int = Int(page)
            
            if self.currentPage == page_int {
                return
            }
            print(scrollView.contentOffset.y,self.frame.size.height)
            print("vertical ",page_int)
            
            //self.containerView.reloadItems(at: [indexPath])
            
            let vc = self.containers[self.currentPage] as! UIViewController
            if !shouldAutomaticallyForwardAppearanceMethods {
                //vc.willMove(toParent: nil)
                
                vc.beginAppearanceTransition(false, animated: true)
                //vc.view.removeFromSuperview()
                //vc.removeFromParent()
                vc.endAppearanceTransition()
            }

            self.currentPage = page_int
            
            let indexPath = IndexPath.init(item: page_int, section: 0)
            guard let delegate = self.delegate, (self.containerView.isDragging || self.containerView.isDecelerating) else { return }
            
            delegate.scrollContainerView(self, to: indexPath)
        }
        
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if self.scrollDirection == .horizontal {
            
            let offset = scrollView.contentOffset.x
            let page = offset / self.frame.size.width
            let page_int = Int(page)
            
            if self.currentPage == page_int {
                return
            }
                    
            print("scrollViewDidEndDecelerating horizontal ",page_int)
            
            //self.containerView.reloadItems(at: [indexPath])
            
            let vc = self.containers[self.currentPage] as! UIViewController
            if !shouldAutomaticallyForwardAppearanceMethods {
                //vc.willMove(toParent: nil)
                
                vc.beginAppearanceTransition(false, animated: true)
                //vc.view.removeFromSuperview()
                //vc.removeFromParent()
                vc.endAppearanceTransition()
            }

            self.currentPage = page_int
            
            let indexPath = IndexPath.init(item: page_int, section: 0)
            guard let delegate = self.delegate else { return }
            delegate.scrollContainerView(self, to: indexPath)
        } else if self.scrollDirection == .vertical {
            print("scrollViewDidEndDecelerating vertical ",scrollView.contentOffset)
            
            if let s = self.mainScrollView {
                s.isScrollEnabled = true
            }
        }
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let s = self.mainScrollView {
            s.isScrollEnabled = false
        }
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let s = self.mainScrollView, decelerate == false {
            s.isScrollEnabled = false
        }
    }
}
