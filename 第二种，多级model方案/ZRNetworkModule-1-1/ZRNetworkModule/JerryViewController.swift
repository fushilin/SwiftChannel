//
//  JerryViewController.swift
//  ZRNetworkModule
//
//  Created by 1230 on 2019/7/30.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import Network
import NetworkExtension
import ZRBase
import Starscream
import Gzip
import ObjectMapper

public typealias SendSocketPakgsClosure = (_ sendResult: socketSendPackageResult) -> ()

class JerryViewController: UIViewController {
    /// 控件属性
 
    
    let JerrywebSorkect =  WebSocketManager.default
//    var dataSource:[OptionData] = []
    var  dataBackDataSource:[OptionSocketBackDataStockData] = []
    var newDataSource: [OptionMultileFirstModel] =  []
    
    var dataType: String = "3"
    lazy  var tableView:UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableView.Style.plain)
        tableView.dataSource  = self
        tableView.delegate = self        
        return tableView
            }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        
        setUpBarButtonItem()
        ///首先发送数据请求认证
        requestData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeSorkectData), name: WebSocketManager.didReceiveDataPushNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: 处理socket 返回的数据信息
extension JerryViewController {
    /// 处理socket返回的通知操作
    
    @objc func changeSorkectData(notion: Notification) {
    guard let objc = notion.object as? SocketPushResult else {
    return
    }
    
    let dict = notion.userInfo
    guard dict != nil else {
    return
    }
    let result = dict!["result"] as? SocketPushResult
        guard let res = Mapper<OptionSocketBackData>().map(JSONObject: result?.data) else {
            return
        }
//        self.dataBackDataSource
     
        if res.stockData.count > 0 {
            for item in res.stockData {
                self.dataBackDataSource.append(item)
            }
            
        }
        
        
        
    guard self.newDataSource.count > 0 else {
    return
    }
        /// 比对和添加数据
        /// 两个for 循环数据 第一种方案，不存在其他的type 以及index 的信息比对
        
        for item in self.newDataSource {
            guard  item.optionMultileSecondeModel.optiondata != nil else {
                return
            }
//            guard let optionData
//            for option in self.dataBackDataSource {
//
//                if item.optionMultileSecondeModel. == option.code {
//                    item.OptionSocketBackDataStockData = option
//                }
//
//            }
        }
    
        
    self.tableView.reloadData()
    }
}


/// 数据处理链路
// MARK: - 请求网络数据
extension JerryViewController{
    
    func requestData(){
        let req =  Network<optionPort>()
        req.request(optionPort.port(ts: "SH", currentPage: 0, pageSize: 20)) { (result) in
            switch result {
            case .success(let  rep ):
                if (rep.code == networkResultSuccess ){
                    
                    guard  let res =  Mapper<OptionPort>().map(JSONObject: rep.data) else {
                        return
                    }
                    
                    guard let array = res.datas as? [OptionData] else{
                        return
                    }
                    /// 三层至四层嵌套关系，具有index type 信息，以及coptionData 信息
                    
                    if res.datas.count  > 0 {
                        for index in 0..<res.datas.count {
                            let item = res.datas[index]
                    
                            let newModel = OptionMultileFirstModel()
                            newModel.index = index
                            newModel.optionMultileSecondeModel.type = self.dataType
                            newModel.optionMultileSecondeModel.optiondata = item
                            self.newDataSource.append(newModel)
                        }
                    }

                    self.tableView.reloadData()
                    /// 发送数据链接
                    /// 发送信息这里，信息嵌套关系改变之后x，需要层级便利，重新计算
                    var dataSourceArray = [OptionData]()
                    for index in self.newDataSource {
                          let second = index.optionMultileSecondeModel.optiondata
                        dataSourceArray.append(second ?? OptionData())
//                        dataSourceArray.append(second)
                        
                    }
                    
                    self.sendSocketData(array: dataSourceArray)
                }
            case .failure( _):
                break
            }
        }
    }
    //    MARK: 处理socket数据
    ///发送socket 数据处理
    func sendSocketData(array:[OptionData], closure: SendSocketPakgsClosure? = nil){
        /// 延时执行 等待数据链路认证处理
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            /// 要开始倒计时操作， 如果时间超过尚未返回，则必须重新发送一次
            let sources = SendSocketPakgsClosure.self

            let sockteBack = OptionPortSocketArray.init(timeout: 60 )
            ///外界回调信息 没有拥有外部回调
            sockteBack.timeOutClosure = {  [weak self] in
                
                /// 处理超时
                
            }
            
            let socketBackParam = sockteBack.socketArraySend(sourceArray: array )
            self!.JerrywebSorkect.openSendData("topic.reBind", param: socketBackParam) { (result) in
                print(result)
            }
            /// 开始倒计时 超时说明发包失败，重新按照新的data发包
            sockteBack.startTimeout()
            
        }
    }
    /// 超时处理信息
    
    func handlerTimeout(){
        /// 清除socket 返回的数据，重新请求数据
        
        /// 重新请求数据
        var dataSourceArray = [OptionData]()
        for index in self.newDataSource {
            let second = index.optionMultileSecondeModel.optiondata
            dataSourceArray.append(second)
            //                        dataSourceArray.append(second)
            
        }
        
        sendSocketData(array: dataSourceArray )

        
    }
    
}


//MARK: 处理按钮点击事件 添加导航条信息
extension JerryViewController{
    
    func setUpBarButtonItem(){
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加自选", style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightClick))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "刷新", style: UIBarButtonItem.Style.plain, target: self, action: #selector(leftClick))
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.setTitle("同步", for: UIControl.State.normal)
        btn.setTitleColor(.blue, for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(middleClike), for: UIControl.Event.touchUpInside)
        self.navigationItem.titleView = btn
    }
    @objc func middleClike(){
        
    }
    @objc  func rightClick(){
        self.navigationController?.pushViewController(OptionShowViewController(), animated: true)
    }
    @objc  func leftClick(){
        /// 拼接一个字典以及array
        requestData()
    }
    
}


extension JerryViewController : UITableViewDataSource ,UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.newDataSource.count
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  string = "string"
        //       数据筛选处理
        var  cell = tableView.dequeueReusableCell(withIdentifier: string)
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: string)
        }
        guard self.newDataSource.count > 0 else {
            return cell!
        }
        
        let  firstModel = self.newDataSource[indexPath.row]
//        ///筛选数据 比对结果，是不是有对应的code信 ,, 不改变是因为被通知循环回来了 如何改变data的数据类型
        let model = firstModel.optionMultileSecondeModel.optiondata
//            dict["\(indexPath.row)"]  as? OptionData

        cell?.textLabel!.text = model.code
//            firstModel.optionMultileSecondeModel.optiondata.code
        
        guard  model.OptionSocketBackDataStockData != nil else {
            return cell ?? UITableViewCell()
        }
        cell?.detailTextLabel!.text = String(format: "%ld", model.OptionSocketBackDataStockData?.ask1_volume ?? "")
     
        return cell ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /// 移除选定的工作任务，删除元素 自定义cell ，开始变化添加信息
        //         把数据写入数据库中
 
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
