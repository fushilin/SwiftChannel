//
//  ViewController.swift
//  moyo-ceshi-01
//
//  Created by 世霖mac on 2019/7/4.
//  Copyright © 2019 世霖mac. All rights reserved.
//

import UIKit
import ObjectMapper

import DGElasticPullToRefresh
import KRProgressHUD
import CryptoSwift
import Alamofire
//import JerryAesSec







class ViewController: UIViewController {

    lazy  var  dataSource: NSMutableArray = []
    var tableView: UITableView!
    var showTextLabel: UILabel!
    var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     self.tabBarItem.title = "hhaa"
        self.navigationController?.navigationBar.isHidden = false
        
        self.view.backgroundColor = UIColor.white
     
        
//        ///1; 绘制BTN信息
//        self.makeBtnBtn()
//        ///2:绘制label的信息se
//        self.makeUpShowLabel()
//        //3:创建text的信息应用
//        self.makeUpTextField()
       
        //4:创建tableview的信息
      self.makeUpTableView()
        /**
         6：  使用刷新控件的信息
         */
        loadShowHeaderView()
        
    }
    
    
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    //MARK: -加载tableView的信息
    func makeUpTableView(){
        
        tableView = UITableView()
        /**
         这个上面的问题不同于别的，必须q上面有一个20的空余量信息
         */
        tableView?.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.gray
    }
    
    //MARK: -刷新数据时使用的空间信息
    func loadShowHeaderView(){
        let loadingView =  DGElasticPullToRefreshLoadingViewCircle()
        //        loadingView.tintColor = UIColor.white
        /**
         这个位置不能随便写，随便写会出现掉线的问题
         必须设置tabLeview的数据信息，偏移数值大于0才对
         */
        //        loadingView.tintColor = UIColor.red  、、
        tableView.dg_addPullToRefreshWithActionHandler({[weak self ] () -> Void in
            KRProgressHUD.show(withMessage: "Loading", completion: nil)
            self!.FslrefreshData()
            KRProgressHUD.dismiss()
            self?.tableView.dg_stopLoading()
            print("hahahah")
            }, loadingView: loadingView)
    }
    
    //MARK: - 绘制按钮信息
    
    func makeBtnBtn(){
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.red
        btn.frame = CGRect(x: 100, y: 100, width: 60, height: 40)
        btn.titleLabel?.text = "点击按钮"
        btn.titleLabel?.textColor = UIColor.white
//        btn.addTarget(self, action: #selector(btnClike:), for: .)
//        btn.addTarget(self, action: #selector(@objc  btnClike(_:)), for: .touchUpInside)

        self.view.addSubview(btn)
        btn.tag = 6
        
//        btn.addTarget(self, action: #selector(btnClike), for: .touchUpInside)
        btn.addTarget(self, action: #selector(btnClikeWith(btn: )), for: .touchUpInside)
//        带有参数的传递信息
        
    }
    
    //MARK: -显示 数据的label的信息
    
    func makeUpShowLabel(){
    
    let label = UILabel.init()
        label.frame = CGRect(x: 3, y: 200, width: 300, height: 50)
        label.backgroundColor = UIColor.gray
        label.text = "加密数据"
        label.textColor = UIColor.red
        self.view.addSubview(label)
        showTextLabel = label
    }
    func makeUpTextField(){
        
        let textField1 = UITextField.init()
        textField1.frame = CGRect(x: 20, y: 280, width: 300, height: 50)
        textField1.backgroundColor = UIColor.gray
        textField1.placeholder = "输入信息"
        self.view.addSubview(textField1)
        self.textField = textField1
        
    }
    
    @objc func  btnClike(){
        print("-------不带参数的按钮")
        showTextLabel.text = self.textField.text
        
    
    }
    //#MARK: 对信息进行加密操作
    
    /**
     > 密钥：ABCDEFG123456ABCDEFG12345687410
     >
     > 偏移量：ujhfwe9ihv0as89w
     
     padding : 具有pack：5 以及pack：7 两种方法
     
     */
    
    @objc func btnClikeWith(btn: UIButton){
        print(btn.tag)
       showTextLabel.text = self.textField.text

        let jerryAesModel =   JerryAesSec.init()
        
    let nameString =  jerryAesModel.AES128(nameDate: "hahahaha")
        
        print(nameString)

        
    }
    
    //MARK: 使用moya
     func FslrefreshData(){
        DoubanProvider.request(.channels) {Result  in
            if case let .success(response) = Result{
                
                let data = response.data
                
                
                let json  = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Array<AnyObject>
                
                for index in json! {
                    
                    let user = Mapper<UserModel>().map(JSONObject: index)
                    self.dataSource.add(user)
                    
                }
                self.tableView.reloadData()
                
                print("\(self.dataSource.count)")
                
            }
        }
    }
  
    
    
    override  func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        DoubanProvider.request(.channels) {Result  in
            if case let .success(response) = Result{
                
                let data = response.data
//                print("\(data)")
//                 必须使用anyObject方法
                
                let json  = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Array<AnyObject>
      
                for index in json! {
                    
                    let user = Mapper<UserModel>().map(JSONObject: index)
                    self.dataSource.add(user)
                    
                }
                self.tableView.reloadData()
                
                print("\(self.dataSource.count)")
    
            }
        }
    }
    
    //MARK: 测试MBPRogress的信息
    func textProgress(){
        
    }

}

extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idString = "cell"
        
        var cell  = tableView.dequeueReusableCell(withIdentifier: idString)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: idString)
        }
        
        let userModel  = self.dataSource[indexPath.row] as! UserModel
        
        cell?.textLabel?.text = userModel.title
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
     addMoreData()
        
    }
    func addMoreData(){
      DoubanProvider.request(.channels){Result  in
        if case let .success(response) = Result{
            
            let data = response.data
            //                print("\(data)")
            //                 必须使用anyObject方法
            
            let json  = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Array<AnyObject>
            
            for index in json! {
                
                let user = Mapper<UserModel>().map(JSONObject: index)
                self.dataSource.add(user)
                
            }
            self.tableView.reloadData()
            
            print("\(self.dataSource.count)")
            
        }
        
        
        
        }
    }
    
    
    
    
}
