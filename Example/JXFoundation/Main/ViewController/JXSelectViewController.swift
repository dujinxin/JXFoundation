//
//  JXSelectViewController.swift
//  JXFoundation_Example
//
//  Created by Admin on 8/6/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class JXSelectViewController: JXBaseViewController {
    
    
    var actions = ["我2016年毕业分在老家的一个单位上班","同时和我一块分过去的还有一个姑娘，当然我们都是老乡，一见面大家都熟悉了。","单位年轻人少，而且都结婚了，所以我们就慢慢的变得很熟识，因为我们都在单位住，一来二往的也就熟悉了许多，聊的也就多了。","我2016年毕业分在老家的一个单位上班，同时和我一块分过去的还有一个姑娘，当然我们都是老乡，一见面大家都熟悉了。单位年轻人少，而且都结婚了，所以我们就慢慢的变得很熟识，因为我们都在单位住，一来二往的也就熟悉了许多，聊的也就多了。"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar.backgroundView.backgroundColor = UIColor.cyan
        self.customNavigationBar.separatorView.backgroundColor = UIColor.gray
    }
    
    @IBAction func pickAction(_ sender: Any) {
        let v = UIImageView()
        v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth / 2)
        let path = Bundle.main.path(forResource: "樱花", ofType: ".jpg")!
        let url = URL(fileURLWithPath: path)
        guard
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else { return }
        v.image = image
        let select = JXSelectView(frame: CGRect(), customView: v)
        select.show()
    }
    @IBAction func listAction(_ sender: Any) {
        
        let attribute = JXAttribute()
        attribute.isUseBottomArea = true
        attribute.topBarStyle = 1
        
        let select = JXSelectView(frame: CGRect(), style: .list)
        select.attribute = attribute
        select.position = .bottom
        select.delegate = self
        select.show()
    }
    @IBAction func customAction(_ sender: Any) {
        let v = UIImageView()
        v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth / 2)
        
        print(v.frame)
        
        let path = Bundle.main.path(forResource: "樱花", ofType: ".jpg")!
        let url = URL(fileURLWithPath: path)
        guard
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else { return }
        v.image = image
        
        let attribute = JXAttribute()
        attribute.isUseBottomArea = true
        attribute.topBarStyle = 1
        
        let select = JXSelectView(frame: CGRect(), customView: v)
        select.attribute = attribute
        select.position = .bottom
        
        select.show()
    }
    @IBAction func middleAction(_ sender: Any) {
        let v = UIImageView()
        v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth / 2)
        
        let path = Bundle.main.path(forResource: "樱花", ofType: ".jpg")!
        let url = URL(fileURLWithPath: path)
        guard
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else { return }
        v.image = image
        
        let attribute = JXAttribute()
        attribute.topBarStyle = 1
        
        let select = JXSelectView(frame: CGRect(), customView: v)
        select.attribute = attribute
        select.position = .middle
        select.show()
    }
    @IBAction func bottomAction(_ sender: Any) {
        let v = UIImageView()
        v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth / 2)
        let path = Bundle.main.path(forResource: "樱花", ofType: ".jpg")!
        let url = URL(fileURLWithPath: path)
        guard
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else { return }
        v.image = image
        let select = JXSelectView(frame: CGRect(), customView: v)
        select.position = .bottom
        select.show()
    }
    var customCellSelect: JXSelectView!
    @IBAction func title3Action(_ sender: Any) {
        let attribute = JXAttribute()
        attribute.isUseBottomArea = true
        attribute.topBarStyle = 1
        
        customCellSelect = JXSelectView(frame: CGRect(), style: .list)
        customCellSelect.attribute = attribute
        customCellSelect.position = .bottom
        customCellSelect.delegate = self
        customCellSelect.title = "标题标题标题"
        //customCellSelect.toolEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        customCellSelect.register(UINib(nibName: "CustomSelectCell", bundle: nil), nil, forCellReuseIdentifier: "reuseIdentifierCustom")
        
        customCellSelect.show()
      
    }
    @objc func clickAction(item: UIBarButtonItem) {
        customCellSelect.dismiss()
    }
    
}
extension JXSelectViewController: JXSelectViewDelegate {
    func jxSelectView(_ selectView: JXSelectView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    //默认
    func jxSelectView(_ selectView: JXSelectView, StringForRowAt indexPath: IndexPath) -> String {
        return actions[indexPath.row]
    }
    //
    func jxSelectView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> JXSelectListViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCustom", for: indexPath) as! CustomSelectCell
        cell.label.text = actions[indexPath.row]
        return cell
    }
    func jxSelectView(_ selectView: JXSelectView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectView == self.customCellSelect {
            return UITableView.automaticDimension
        }
        return 44
    }
    func jxSelectView(_ selectView: JXSelectView, clickButtonAtIndex index: Int) {
        self.showNotice(actions[index])
    }
}
