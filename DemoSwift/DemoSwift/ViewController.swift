//
//  ViewController.swift
//  DemoSwift
//
//  Created by David on 17/1/9.
//  Copyright © 2017年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    let kCatologNamesArray = ["DemoSwift.TopScrollViewController"]
//    ,"CircleProgressViewController","SpiderNetViewController"
    
    var _tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        _tableView.frame = self.view.bounds
        self.view .addSubview(_tableView)
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        _tableView.rowHeight = 30
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return kCatologNamesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellId")
        if cell == nil {
            cell =  UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "CellId")
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        let name = kCatologNamesArray[indexPath.row]
        cell?.textLabel?.text = name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = kCatologNamesArray[indexPath.row]
        let aClass = NSClassFromString(name) as! UIViewController.Type
        let controller = aClass.init()
        self.navigationController? .pushViewController(controller , animated: true)
    }
}


