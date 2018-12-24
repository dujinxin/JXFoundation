//
//  TestListController.swift
//  JXFoundation_Example
//
//  Created by 杜进新 on 2018/11/5.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import JXFoundation

class TestListController: JXTableViewController {
    
    var countDown : CountDown?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TimeLabel"

        self.tableView.frame = CGRect(x: 0, y: kNavStatusHeight, width: view.bounds.width, height: view.bounds.height - kNavStatusHeight)
        self.tableView.register(JXTimeCell.self, forCellReuseIdentifier: "cell")
       
        self.dataArray = [30230,4035,175,5]
            //,52,20,9532,30232,4022,5132,242,5000,46302,5300,4532,5432,3220,402,5532,30070,4002,51232]
        
        countDown = CountDown(tableView: self.tableView, data: dataArray as! Array<Int>)
        //countDown?.isPlusTime = true
    }
    
    
}
extension TestListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JXTimeCell
        cell.tag = indexPath.row
        //cell.textLabel?.text = "\(indexPath.row)"
        cell.timeLabel.tag = 1314
        cell.timeLabel.text = countDown?.countDown(indexPath: indexPath)
        return cell
    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.01
//    }
}

class JXTimeCell:  UITableViewCell{
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(self.timeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.timeLabel.frame = self.bounds
    }
}
