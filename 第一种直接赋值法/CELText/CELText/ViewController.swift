//
//  ViewController.swift
//  CELText
//
//  Created by 我演示 on 2019/8/4.
//  Copyright © 2019 我演示. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// 属性空间
    var dataSource:[PriceDataMdoel] {
        var data:[PriceDataMdoel] = [PriceDataMdoel]()
        for item in  0...10 {
             let model = PriceDataMdoel.init(name: "道琼斯\(item)", tsName: "000\(item)", newPrice: "2452\(item)", upString: "2586\(item)")
            data.append(model)
        
        }
      return data
        
    }
    lazy  var tableView:UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableView.Style.plain)
        tableView.dataSource  = self
        tableView.delegate = self
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UITableViewDelegate,UITableViewDataSource
{
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        let cell = JerryTableViewCell().cellWithTableView(tableView: tableView) as? JerryTableViewCell
//            tableView.dequeueReusableCell(withIdentifier: string) as? UITableViewCell
        cell?.viewModel = self.dataSource[indexPath.row]
        return cell ?? JerryTableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
