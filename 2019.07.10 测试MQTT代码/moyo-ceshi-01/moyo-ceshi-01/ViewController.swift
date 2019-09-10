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

import SocketIO
import  CocoaMQTT


//import JerryAesSec

class ViewController: UIViewController {

    lazy  var  dataSource: NSMutableArray = []
    var tableView: UITableView!
    var showTextLabel: UILabel!
    var textField: UITextField!
    var manager: SocketManager!
    var mqtt:CocoaMQTT!
    
//     let string = textu
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
//      self.makeUpTableView()
//        /**
//         6：  使用刷新控件的信息
//         */
//        loadShowHeaderView()
        
        //7：测试soucket的连接
        
      
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
        
    }
  

    //MARK: 测试点击时间的信息
    
    override  func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 
        
//        self.textRequestWithString()
        
        //床架socket的连接方案
        
//        self.creatSocketIO()
        
        self.creatMQtt()
        
    }
    
    
    //MARK: 创建长连接的信息Socket的信息
    func creatMQtt(){
//        let clientIdPid = "" + String(ProcessInfo().processIdentifier)
//        let   mqtt = CocoaMQTT(clientID: clientIdPid, host: "192.168.9.135", port: 1881)
//
//            mqtt.username = "57bec7e6cc96586442651585"
//            mqtt.password = "rehL66qTLwmpruFQNacGqr4YedRDMptt"
//            mqtt.willMessage = CocoaMQTTWill(topic:"v1.0/regist/57bec7e6cc96586442651585/12345", message:"did")
//            mqtt.keepAlive = 90
//            mqtt.delegate = self

        
//        let clientIdPid = "sub" + String(ProcessInfo().processIdentifier)
//
////        tcp://192.168.1.212:1883
////        let mqtt = CocoaMQTT(clientID: clientIdPid, host: "192.168.1.212", port: 1883)
//
//  let      mqtt = CocoaMQTT(clientID: clientIdPid, host: "test.mosquitto.org", port: 1883)

//        let      mqtt = CocoaMQTT(clientID: clientIdPid, host: "192.168.9.135", port: 1881)
//let mqttConfigSub = MQTTConfig(clientId: "sub", host: "test.mosquitto.org", port: 1883, keepAlive: 60)
//        mqtt.username = "test"
//        mqtt.password = "public"
//        mqtt.username = "thinkpad"
//        mqtt.password = "public"
//        mqtt.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
//         192.168.1.212
//        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)

          let clientID = "Slicence" + String(ProcessInfo().processIdentifier)
        print("clientID : \(clientID)")
        mqtt = CocoaMQTT(clientID: clientID, host: "192.168.1.212", port: 1883)
//        mqtt.username = "admin"
//        mqtt.password = "public"
        mqtt.keepAlive = 60

//        mqtt.willMessage(
          mqtt.willMessage = CocoaMQTTWill(topic:"v1.0/regist/57bec7e6cc96586442651585/12345", message:"did")
        mqtt.delegate = self
        let right  =  mqtt.connect()
        print(right)

    }
     //MARK: 创建长连接的信息Socket的信息
    func creatSocketIO(){
        
//        wss://socket.citex.co.kr/socket.io/?EIO=3&transport=websocket
        
//1           manager = SocketManager(socketURL: URL(string: "wss://socket.citex.co.kr/socket.io/?EIO=3&transport=websocket")!, config: [.log(true), .compress])
// 2      manager = SocketManager(socketURL: URL(string: "ws://192.168.1.111:1949/project/websocket")!, config: [.log(true), .compress])
        
//        3 http://localhost:8080
         manager = SocketManager(socketURL: URL(string: "http://localhost:9999")!, config: [.log(true), .compress])
        let socket = manager.socket(forNamespace: "/socket.io/")
//             manager.defaultSocket
//            manager.socket(forNamespace: "/socket.io/")
//
//            manager.socket(forNamespace: "/socket.io/")
//            \manager.defaultSocket
//        socket.nsp = "/socket.io"
        socket.on(clientEvent: .connect) {data, ack in
            print(data)
            print("socket connected success")
        }
        
       
        socket.on(clientEvent: .disconnect) {data , ack  in
            print(data)
            print("连接失败")
            
        }
//        error
        socket.on(clientEvent: .error) {data , ack  in
            print(data)
            print("连接错误")
            
        }
        
        
        socket.on("currentAmount") {data, ack in
            guard let cur = data[0] as? Double else { return }
            
            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                socket.emit("update", ["amount": cur + 2.50])
            }
            
            ack.with("Got your currentAmount", "dude")
        }
        let cur = "463255"
     
        //发送消息socket
        //chat message 为发送消息给后台的方法名 (为举例)  与后台协定方法名
        socket.emit("chat message", with: [cur])
        
        
        
        socket.connect()
    }
    
    //MARK: 测试MBPRogress的信息
    func textProgress(){
        
    }
    func textRequestWithoutString(){
        
    }
    func   textRequestWithString(){
        
    }
    

}




extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.dataSource.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = JerryTextTableViewCell.cellWithTableView(tableView: tableView)
        
//        var cell  = tableView.dequeueReusableCell(withIdentifier: idString)
//
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: idString)
//        }
//
//        let userModel  = self.dataSource[indexPath.row] as! UserModel
//
//        cell.textLabel?.text = userModel.title
        return cell as! JerryTextTableViewCell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
     addMoreData()
        
    }
    func addMoreData(){
        
        
        
    }

}


extension ViewController:CocoaMQTTDelegate{
//    func mqdidcon
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("正在ping连接")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
          print("正在pong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
          print("断开连接")
        print(err)
    }
    
    
    ///
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
          print("正在建立连接")

        print(ack.description)

        if ack.description == "accept"{

            /**
             这个public是发送消息
             */
//            mqtt.publish("chat", withString: "dtr")

            /**
             这个subscribe 是主题消息 ，就是自己发布的主题
             */
            mqtt.subscribe("jerry-03") // 这一句是发布主题
            
//            for index in 1...1000000 {
//                print("\(index) 乘于 5 为：\(index * 5)")
//
//                var string = String(index)
//
//            }
//               mqtt.subscribe("jerry-15")
//            mqtt.publish("jerry-15", withString: "jerry-0001", qos: CocoaMQTTQOS.qos0, retained: true, dup: true)
            mqtt.subscribe("stock/0001/01")

        }
        
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        
 
        print("发送消息")
        
//        mqtt.publish("jerry", withString: "jerry-01", qos: CocoaMQTTQOS.qos0, retained: true, dup: true)
        
//        在这个里面发送了消息针对主题 主题必须对应
        
//        mqtt.publish("jerry-18", withString: "jerry-0005", qos: CocoaMQTTQOS.qos0, retained: false, dup: false)
        
        print(message)
        print(message.string)
        print(message.topic)
        print(message.dup)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("fasongxiaoxi ")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
          print("正在didReceiveMessage message ")
        print("topics:\(message.topic)")
        print("message:\(message.string)")
    }
    
    //这个是返回的主题的信息
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        
        
        print("==========\(topics)")
//        print(topics.)
          print("didSubscribeTopic")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        
        print("didUnsubscribeTopic")
    }
    
 
    
}
