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


public protocol JXHorizontalViewDelegate {
    
    func horizontalView(_ : JXHorizontalView, to indexPath: IndexPath) -> Void
    func horizontalViewDidScroll(scrollView: UIScrollView) -> Void
}

public class JXHorizontalView: UIView {

    let parentViewController : UIViewController
    var containers = Array<Any>()
    var currentPage = 0
    var delegate : JXHorizontalViewDelegate?
    /// 手动管理viewWillAppear(_:) 、 viewDidAppear(_:) 、viewWillDisappear(_:) 、viewDidDisappear(_:) ，需要父控制器重写次属性，改为false。暂时不开放，无法控制viewDidDisappear(_:)，viewDidAppear(_:)无法控制
    var shouldAutomaticallyForwardAppearanceMethods: Bool
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
        self.delegate = parentViewController as? JXHorizontalViewDelegate
        self.containers = containers
        self.shouldAutomaticallyForwardAppearanceMethods = parentViewController.shouldAutomaticallyForwardAppearanceMethods
        super.init(frame: frame)
        
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

    
    public func reloadData() {
        let indexPath = IndexPath.init(item: 0, section: 0)
        self.containerView.reloadItems(at: [indexPath])
    }
    
    
    
    public lazy var containerView: UICollectionView = {
        
        let flowlayout = UICollectionViewFlowLayout.init()
        flowlayout.itemSize = self.bounds.size
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing  = 0.0
        flowlayout.minimumInteritemSpacing = 0.0
        flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //flowlayout.headerReferenceSize = CGSize.init(width: self.rect.size.width, height: 44)
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowlayout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
      
        collectionView.backgroundColor = UIColor.brown
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        return collectionView
    }()
}
//MARK:UICollectionViewDelegate, UICollectionViewDataSource
extension JXHorizontalView: UICollectionViewDelegate, UICollectionViewDataSource {
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
            let v = containers[indexPath.item]
            if let vc = v as? UIViewController {
                vc.view.tag = 100
                if let v = cell.contentView.viewWithTag(100) {
                    v.removeFromSuperview()
                }
                if !shouldAutomaticallyForwardAppearanceMethods { vc.beginAppearanceTransition(true, animated: true) }
                cell.contentView.addSubview(vc.view)
                if !shouldAutomaticallyForwardAppearanceMethods { vc.endAppearanceTransition() }
                
                //vc.didMove(toParent: parentViewController)
            }else if(v is UIView){
                let iv = v as! UIView
                iv.frame = cell.contentView.bounds
                iv.tag = 10000
                cell.contentView.addSubview(iv)
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
extension JXHorizontalView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate = self.delegate else { return }
        delegate.horizontalViewDidScroll(scrollView: self.containerView)
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let page = offset / self.frame.size.width
        let page_int = Int(page)
        
        if self.currentPage == page_int {
            return
        }
        
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
        delegate.horizontalView(self, to: indexPath)
    }
}
