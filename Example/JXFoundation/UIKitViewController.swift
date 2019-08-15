//
//  UIKitViewController.swift
//  JXFoundation_Example
//
//  Created by 杜进新 on 2018/7/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class UIKitViewController: UIViewController {

    var dataArray: Array<String> {
        return ["0.02","0.01","0.03","0.017","0.024","0.008","0.007","0.006","0.004","0.009","0.012","0.013","0.022","0.021","0.025","0.027","0.019"]
    }
    var buttonArray = Array<UIView>()
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: kNavStatusHeight, width: view.jxWidth, height: view.jxWidth)
        v.backgroundColor = UIColor.jxeeeeeeColor
        return v
    }()
    var centerView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "测试", fontSize: 15, target: self, action: #selector(test))
        self.view.backgroundColor = UIColor.rgbColor(from: 10, 200, 50)
        self.view.addSubview(self.contentView)
        
        
//        //随机分布视图，并带上下浮动动画
//        let subArray = ["0.009","0.012","0.013","0.022","0.021","0.025","0.027","0.019"]
//        self.random(subArray)
//        self.animate()

        //随机分布视图向中间汇聚动画
        
        
        self.centerView = UIView()
        centerView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        centerView.backgroundColor = UIColor.blue
        self.contentView.addSubview(centerView)
        centerView.center = CGPoint(x: self.contentView.jxCenterX, y: self.contentView.jxHeight / 2)

        self.randomPoints(begin: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func test() {
        print(UIScreen.main.model)
        print(UIViewController.topStackViewController ?? "")
    }

    //由于同一个视图在动画过程中不响应点击事件，这里的做法是给父视图添加点击事件，而给子视图添加动画
    func random(_ array:Array<String>) {
        //self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
        
        //origin可随机区域 width = superView.width - button.width - animateWidth
        let width = self.contentView.bounds.width - 44 - 5 * 2
        //origin可随机区域 width = superView.height - button.height - animateHeight
        let height = self.contentView.bounds.width - 64 - 5 * 2
        
        for title in array {
            
//            let button = UIButton()
//            button.backgroundColor = UIColor.randomColor
//            button.setTitle(title, for: .normal)
//            button.addTarget(self, action: #selector(dismissAnimation(_:)), for: .touchUpInside)
            
            let superView = UIView()
            superView.backgroundColor = UIColor.randomColor
            superView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
            
            let superView1 = UIView()
            superView1.backgroundColor = UIColor.randomColor
            superView.addSubview(superView1)
            
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.randomColor
            imageView.isUserInteractionEnabled = true
            superView1.addSubview(imageView)
            
            let label = UILabel()
            label.text = title
            superView1.addSubview(label)
            
            
            
            var isIntersects = true
            repeat{
                //起始位置预留动画的位置
                let x = 5 + arc4random_uniform(UInt32(width))
                let y = UInt32(kNavStatusHeight) + 5 + arc4random_uniform(UInt32(height))
                superView.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: 44, height: 64)
                superView1.frame = CGRect(x: 0, y: 0, width: 44, height: 64)
                imageView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
                label.frame = CGRect(x: 0, y: 44, width: 44, height: 20)
                if self.buttonArray.count == 0 {
                    print("第一个视图一定没有交集")
                    isIntersects = false
                } else {
                    isIntersects = false
                    for subView in self.buttonArray {
                        //与已存在的子视图没有交集，方可添加
                        if subView.frame.intersects(superView.frame) == true {
                            print("有交集")
                            isIntersects = true
                            break
                        }
                    }
                }
                
            }while(isIntersects)
            print("没有交集")
            self.buttonArray.append(superView)
            self.view.addSubview(superView)
        }
    }
    func animate() {
        for v1 in self.buttonArray {
            guard let v = v1.subviews.first else{
                return
            }
            let animation = CAKeyframeAnimation.init(keyPath: "position")
            let path = CGMutablePath.init()
            path.move(to: CGPoint(x: v.center.x, y: v.center.y))//设置起始点
            path.addLine(to: CGPoint(x: v.center.x, y: v.center.y + 5))//终点
            path.addLine(to: CGPoint(x: v.center.x, y: v.center.y))//终点
            path.addLine(to: CGPoint(x: v.center.x, y: v.center.y - 5))//终点
            path.addLine(to: CGPoint(x: v.center.x, y: v.center.y))//终点

            
//            let transform = CGAffineTransform.init(translationX: -v.bounds.origin.x, y: -v.bounds.origin.y)
//            transform.scaledBy(x: 1, y: 0.2)
//            transform.translatedBy(x: v.bounds.origin.x, y: v.bounds.origin.y)
//
//            let center = CGPoint(x: v.jxOrigin.x + 44 / 2, y: v.jxOrigin.y + 64 / 2)
//
//            path.addArc(center: center, radius: 5, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true,transform:transform)
            
            animation.path = path
            
            animation.isRemovedOnCompletion = false
            animation.repeatCount =  Float.greatestFiniteMagnitude
            //animation.repeatDuration = 3
            animation.duration = 5
            animation.autoreverses = false
            animation.fillMode = CAMediaTimingFillMode.forwards
            animation.calculationMode = CAAnimationCalculationMode.paced
            
            v.layer.add(animation, forKey: nil)
            
//            UIView.animate(withDuration: 3, delay: 3.1, options: [.repeat,.curveEaseInOut], animations: {
//                var frame = button.frame
//                frame.origin.y += 10
//                button.frame = frame
//            }) { (finish) in
//                if finish == true {
//                    UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: {
//                        var frame = button.frame
//                        frame.origin.y -= 10
//                        button.frame = frame
//                    }) { (finish1) in
//                        if finish1 == true {
//                            print("done1")
//                        } else {
//                            print("animating1")
//                        }
//                    }
//                    print("done")
//                } else {
//                    print("animating")
//                }
//            }
        }
    }
    @objc func tap(tap: UITapGestureRecognizer) {
        guard let subView = tap.view else {
            return
        }
//        let point = tap.location(in: self.view)
//        for subView in self.buttonArray {
//            let presentLayer = subView.layer.presentation()
//            if let layer = presentLayer?.hitTest(point) {
//                print(subView.frame)
//                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
//                    var frame = subView.frame
//                    frame.origin.y = -64
//                    subView.frame = frame
//                    print("animation frame = ",subView.frame)
//                }) { (finish) in
//                    if finish {
//                        subView.removeFromSuperview()
//                        let index = self.buttonArray.index(of: subView)
//                        self.buttonArray.remove(at: index!)
//                    }
//                }
//            }
//
//        }
        print(subView.frame)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            var frame = subView.frame
            frame.origin.y = -64
            subView.frame = frame
            print("animation frame = ",subView.frame)
        }) { (finish) in
            if finish {
                subView.removeFromSuperview()
                let index = self.buttonArray.firstIndex(of: subView)
                self.buttonArray.remove(at: index!)
            }
        }
    }
    
    //由于同一个视图在动画过程中不响应点击事件，这里的做法是给父视图添加点击事件，而给子视图添加动画
    func randomPoints(begin count: Int) {
    
        self.countDown(timeOut: count, timeInterval: 1, process: { (i) in
            print("当前点",i)
            self.resetRandomPoint(v: nil)
        }) {
            print("初始点全部生成")
        }
    }
    func resetRandomPoint(v: UIView?) {

        //origin可随机区域 width = superView.width - button.width
        let width = self.contentView.bounds.width - 5
        //origin可随机区域 width = superView.height - button.height
        let height = self.contentView.bounds.width - 5
        
        var frame = CGRect()
        var isIntersects = true
        repeat{
            //起始位置预留动画的位置
            let x = 5 + arc4random_uniform(UInt32(width))
            let y = UInt32(kNavStatusHeight) + 5 + arc4random_uniform(UInt32(height))
            frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: 10, height: 10)
            
            
            isIntersects = false
            //与已存在的子视图没有交集，方可添加
            if self.centerView.frame.intersects(frame) == true {
                //print("有交集")
                isIntersects = true
                break
            }
            
        }while(isIntersects)
        //print("没有交集")
        let superView = v ?? UIView()
        superView.frame = frame
        superView.backgroundColor = UIColor.randomColor
        superView.alpha = 1
        superView.layer.cornerRadius = 5
        superView.isHidden = false
        self.view.addSubview(superView)
        self.beginConvergeAnimate(v: superView, startTime: 0)

    }
    func beginConvergeAnimate(v: UIView, startTime: Double) {

        //动画
        UIView.animate(withDuration: 3, delay: startTime, options: [.curveEaseOut], animations: {
            var frame = v.frame
            let point = CGPoint(x: self.contentView.jxCenterX + 10 / 2, y: self.contentView.jxCenterY + 10 / 2)
            frame.origin = point
            frame.size = CGSize(width: 0, height: 0)
            v.frame = frame
            v.alpha = 0
            v.layer.cornerRadius = 0
        }) { (finish) in
            if finish {
                v.isHidden = true
                v.alpha = 1
                v.removeFromSuperview()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + startTime) {
                    self.resetRandomPoint(v: v)
                }
            }
        }
    }
    /// 倒计时
    ///
    /// - Parameters:
    ///   - timeOut: 倒计时长(执行次数)
    ///   - timeInterval: 倒计时间间隔(每次调用间隔)
    ///   - process:未完成时的回调
    ///   - completion: 完成回调
    func countDown(timeOut: Int, timeInterval: Int = 1, process: @escaping ((_ currentTime:Int)->()), completion: @escaping (()->())) {
        
        var timeOut1 = timeOut
        
        let queue = DispatchQueue.global(qos: .default)
        let source_timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        source_timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: Double(timeInterval))
        source_timer.setEventHandler {
            if timeOut1 <= 0 {
                source_timer.cancel()
                DispatchQueue.main.async {
                    completion()
                }
            } else {
                let seconds = timeOut1 % (timeOut + 1)
                DispatchQueue.main.async {
                    process(seconds)
                }
                timeOut1 -= timeInterval
            }
        }
        source_timer.resume()
    }
}
