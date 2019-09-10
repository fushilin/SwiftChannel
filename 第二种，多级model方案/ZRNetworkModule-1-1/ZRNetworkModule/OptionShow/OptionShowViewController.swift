//
//  OptionShowViewController.swift
//  ZRNetworkModule
//
//  Created by 1230 on 2019/7/29.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import Network
import NetworkExtension
import ZRBase
import Starscream
import Gzip
import ObjectMapper

public enum Test{
    
    case source(keyword: String , currentPage: Int, pageSize: Int)
}

extension Test: NetworkAPI {
    public var path: String {
        /// 接口地址信息
        switch self {
        case .source:
            return   "/stock-market/api/stock/view/v1/search"
        default:
            return ""
        }
    
    }
   public var parameters: [String : Any] {
        ///创建封装组件信息
    switch self {
    case .source(let keyword, let currentPage , let pageSize):
        var dict = [String : Any] ()
        dict["keyword"] = keyword
        dict["currentPage"] = pageSize
        dict["pageSize"] = currentPage
        return dict
        default:
        return [:]
        break
    }
    }
}

public class OptionShowViewController: UIViewController {


    var searchText:String = ""
    var DBdataSource:NSMutableArray = []
    
    var selectSoutce = [OptionData]()
//     首先创建单元格
    lazy  var tableView:UITableView = {
    var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableView.Style.plain)
        tableView.dataSource  = self
        tableView.delegate = self
        tableView.register(OptionViewCell.classForCoder(), forCellReuseIdentifier: "string")
        return tableView
    }()
    
    var dataSource: [OptionData] = []
    /// 由于数据库我只创建了一次，导致数据读取时候，无法读取已经更新的数据。需要通知进行改变
   
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
//         requestData()
         self.view.addSubview(tableView)
        setupSearch()
        setUpRightSearch()
        /// 添加读取数据的通知
//        NotificationCenter.default.addObserver(self, selector: #selector(readDBData), name: OptionViewCell.didDBChangeNotion, object: nil)
    }
    //    MARK:读取数据库操作
    

    func setupSearch(){
        let  searchBar = UISearchBar.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//    CGRect(x: 0, y: 0, width: 100, height: 40)
//        self.searchBar = searchBar.
        searchBar.delegate = self as UISearchBarDelegate
        searchBar.showsCancelButton = false
        searchBar.placeholder = "搜索"
          self.navigationItem.titleView  = searchBar
    }
    func setUpRightSearch(){
        let right = UIBarButtonItem(title: "搜索", style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightClick))
        self.navigationItem.rightBarButtonItem = right
    }
    @objc  func rightClick(){
        /// 开始 搜索 ，先清除数据，再开始搜索
        self.dataSource.removeAll()
          requestData()
//        self.DBdataSource
    }

    func requestData(){
      let net = Network<Test>()
        
        net.request(Test.source(keyword: self.searchText , currentPage: 0, pageSize: 20)) { (result) in

            switch result {
           
            case .success( let response):

             
                if response.code == networkResultSuccess{
                    guard let res = Mapper<OptionModel>().map(JSONObject: response.data) else{
                        return
                    }
                   
                    for item in res.datas {
                        item.option =  OptionModelPlist.default.contains(item)
                        self.dataSource.append(item)
                    }

                    self.tableView.reloadData()
                }
                return
            case .failure(_):
                break
            }
        }
    }
}


extension OptionShowViewController : UITableViewDataSource ,UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataSource.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  string = "string"
//       数据筛选处理
       
        
        guard  let  cell = tableView.dequeueReusableCell(withIdentifier: string, for: indexPath) as? OptionViewCell else {
            return OptionViewCell()
        }
       let  model = self.dataSource[indexPath.row]
        cell.setValuesModel(model: model)
        
        cell.model = model
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

}
}

extension  OptionShowViewController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange earchText: String) {
        print(searchBar.text as Any)
        self.searchText = searchBar.text as! String
    }
    // 搜索触发事件，点击虚拟键盘上的search按钮时触发此方法
    private func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    private func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // 搜索内容置空
        searchBar.text = ""
   
        searchBar.resignFirstResponder()
    }
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print(searchBar.text as Any)
        return true
    }
    
}
