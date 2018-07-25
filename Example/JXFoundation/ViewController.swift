//
//  ViewController.swift
//  JXView
//
//  Created by dujinxin on 08/23/2017.
//  Copyright (c) 2017 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

enum Type : Int {
    case guide
    case ad
}

class ViewController: UIViewController {

    var type = Type.guide
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.red
        
        if type == .guide {
            self.setGuideView()
        } else {
            self.setAdvertiseView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// 设置引导页面
    func setGuideView() {
        var array = Array<String>()
        
        for i in 1...4 {
            array.append(String(format: "guide_%d", i))
        }
        let guideView = JXGuideView(frame: view.bounds, images: array, style: .point) { (guide) in
            print("收起")
        }
        view.addSubview(guideView)
    }
    /// 设置广告页面
    func setAdvertiseView() {
        let adView = JXAdvertiseView(frame: view.bounds)
        adView.imageView.image = UIImage(named: "guide_2")
        view.addSubview(adView)
    }
}

