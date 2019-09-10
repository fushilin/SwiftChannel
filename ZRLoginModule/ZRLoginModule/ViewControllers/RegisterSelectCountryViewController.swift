//
//  RegisterSelectCountryViewController.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/16.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit
import ZRCoreKit
import ObjectMapper
import ZRModel
import ZRBase

protocol RegisterSelectCountryDelegate {
     func selectCountrySendName(name: String)
}

/// 定义传值变量
typealias block = (_ str: CountryModel) -> Void

 public class RegisterSelectCountryViewController: BaseViewController {

    var callBackBlock: block?
    
    
    /// var  searchBar
    private  lazy var searchBar : UISearchBar = {
       var searchBar = UISearchBar.init(frame: .zero)
        
        searchBar.delegate = self

        return searchBar
    }()
    
    /// 右侧添加一个button
    private lazy var searBtn : UIButton = {
        var btn = UIButton.init(frame: .zero)
        btn.setTitle("搜索", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self , action: #selector(pressSearchBtn), for: .touchUpInside)
        return btn
    }()
    
    var dataSourceArray:[Any] = [Any]()
    
    var searchDataSource:[Any] = [Any]()
    var delegage: RegisterSelectCountryDelegate?

   var searchBool: Bool = false
    let sortArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    /// 设置属性
    private  lazy var tableView: UITableView = {
       let tableView  = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        //设置索引条的文字颜色
        tableView.sectionIndexColor = UIColor.blue
//            [UIColor orangeColor];
        //设置索引条的背景颜色
       tableView.sectionIndexBackgroundColor = .white
//        [UIColor redColor];
        return tableView
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        self.view.addSubview(searchBar)
        self.view.addSubview(searBtn)
//      let language =   LanguageManager.default.serverLanuage
        
        
        switch languageM.current {
        case .cn_hk:
            print("香港")
           break
        case  .english:
            print("meiyu")
            break
        default:
            print("qita")
            break
        }
      
        searchBar.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(-80)
            make.top.equalTo(self.view.snp_top).offset(0)
            make.height.equalTo(50)
            
        }
        searBtn.snp.makeConstraints { (make) in
            make.left.equalTo(searchBar.snp_right).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.top.equalTo(self.view.snp_top).offset(0)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { (make) in

            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.top.equalTo(searchBar.snp_bottom).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
        /// 读取数据库操作
        let pathString  = "/Users/woyanshi/Desktop/测试代码/ZRLoginModule/Pods/ZRModel/ZRModelModule/ZRModelModule/Resources/Countrys"
//        SandBoxType.documents.filePath("/ZRModelModule/Resources/Countrys")
//        "/Users/woyanshi/Desktop/测试代码/ZRLoginModule/Pods/ZRModel/ZRModelModule/ZRModelModule/Resources/Countrys"
        
        let url = URL(fileURLWithPath: pathString)
        let data = (try? Data(contentsOf: url)) ?? Data()
        let jsonData:Any = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        let jsonArr = jsonData as! NSArray

        
        for charTmp in self.sortArray {
           
            var  array = [CountryModel]()
            for item in jsonArr {
                let model = Mapper<CountryModel>().map(JSONObject: item)
                /// 全部转化为大写
//                model?.cn_py
                let firstString = model?.cn_py.uppercased()
                
//                print(firstString)
                /// 截取字符串首字母
                let first =  firstString?.prefix(1)
                
                if first == charTmp.prefix(1) {
                    array.append(model! )
                }
            }
            
            var  dict:[String: Any]  = [String:Any]()
            dict["sectionArray"] = array
            dict["sectionTitle"] = charTmp

            self.dataSourceArray.append(dict)
        }
        /// 转化为model
      
        tableView.reloadData()

    }
    func callBackFunction(block:@escaping (_ str: CountryModel) -> Void)
    {
        callBackBlock = block
    }
}


extension RegisterSelectCountryViewController: UITableViewDelegate , UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var dict:NSDictionary? = NSDictionary()
        if searchBool == false {
             dict = self.dataSourceArray[section] as? NSDictionary
         
        }else{
              dict = self.searchDataSource[section] as? NSDictionary
        }
        let array = dict?.object(forKey:"sectionArray") as!  NSArray
        return array.count
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if searchBool == false {
            return  dataSourceArray.count
            
        }else {
            return self.searchDataSource.count
        }
        
    }
    

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let string = "string"
       var  dict: NSDictionary = NSDictionary()
        if  searchBool == false {
            dict  =  self.dataSourceArray[indexPath.section] as! NSDictionary
        }else{
              dict  =  self.searchDataSource[indexPath.section] as! NSDictionary
        }
        
        var  cell = tableView.dequeueReusableCell(withIdentifier: string)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: string)
        }
        let array:NSArray! = dict.object(forKey: "sectionArray") as? NSArray
        
        let model = array.object(at: indexPath.row) as? CountryModel
    
        switch languageM.current {
            case .cn_hk:

                 cell?.textLabel!.text = model?.cn
                
                break
            case  .english:
            
                 cell?.textLabel!.text = model?.en
                break
            default:
         
                break
        }
       
 
        return cell ?? UITableViewCell()
        
    }
    
    
    /// 数量
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sortArray.count
    }

    
    /// 设置索引
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return  sortArray
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var dict: NSDictionary? = NSDictionary()
        if searchBool == false {
            dict   = self.dataSourceArray[section] as? NSDictionary
        }else{
              dict  = self.searchDataSource[section] as? NSDictionary
        }
       
        let text:String! = dict?.object(forKey: "sectionTitle") as? String
        return text
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// 传值信息
        var  dict: NSDictionary = NSDictionary()
        if  searchBool == false {
            dict  =  self.dataSourceArray[indexPath.section] as! NSDictionary
        }else{
            dict  =  self.searchDataSource[indexPath.section] as! NSDictionary
        }
        if callBackBlock != nil
        {
            let array:NSArray! = dict.object(forKey: "sectionArray") as? NSArray
            
            guard let model = array.object(at: indexPath.row) as? CountryModel else {
                return
            }
       
            
            callBackBlock!(model)
        }

        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension RegisterSelectCountryViewController:UISearchBarDelegate {
    
}

extension RegisterSelectCountryViewController {
    @objc private func pressSearchBtn() {
        /// 开启搜索数据s
            znSimpleLaguage()
  
        
    }
    
    /// 转化为汉语
    private func znSimpleLaguage() {
        self.searchDataSource.removeAll()
        for item in self.dataSourceArray{
            let dict = item as? NSDictionary
            let sourceArray = dict?.object(forKey: "sectionArray") as! NSArray
            searchBool = true
            var  dict3:[String: Any]  = [String:Any]()
            var  searchArray = [CountryModel]()
            for searchItem in sourceArray {
                let searchModel = searchItem as! CountryModel
        
                
                var  upString: String = ""
                let showString: String = ""
                switch languageM.current {
                case .cn_hk:
            
                    upString = searchModel.cn.uppercased()
                    break
                case  .english:
           
                        upString = searchModel.en.uppercased()
                    
                    break
                default:
                    break
                }
                
                if (upString.range(of: "\(searchBar.text?.uppercased() ?? "")") != nil) {
                    searchArray.append(searchModel)
                }
            }
            dict3["sectionArray"] = searchArray
            dict3["sectionTitle"] = ""
            
            self.searchDataSource.append(dict3)
            
        }
        tableView.reloadData()
    }
    
}
