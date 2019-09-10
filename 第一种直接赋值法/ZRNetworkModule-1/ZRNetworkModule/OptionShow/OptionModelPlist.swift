//
//  OptionModelPlist.swift
//  ZRNetworkModule
//
//  Created by 1230 on 2019/7/31.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import ObjectMapper
import ZRBase

public  class OptionModelPlist: NSObject {
  
//   对数据抽取方法，公用，只提供一个外调接口或者方法
    /// 静态初始化 外部调用
    public static let `default`: OptionModelPlist = OptionModelPlist()
    
    ///
    public var opts:  [OptionData] = []
    
    
    let dbPath: String = SandBoxType.documents.filePath("456.plist")
    

    /// 查询，写入，删除 目前只接收一种model的数据
    var  writableDBPath: String = ""
    
    public override init() {
        super.init()
        /// 本地读取
        let url = URL(fileURLWithPath: self.dbPath)
        
        guard let data = try? Data(contentsOf: url) else { return }
        
        guard let json = String(data: data, encoding: .utf8) else { return }
        
        guard let otps = Mapper<OptionData>().mapArray(JSONString: json)  else { return }
        
        self.opts = otps
    }
    
    /// 是否包含
    public func contains(_ element: OptionData) -> Bool {
       let filter =  opts.filter { (p) -> Bool in
            return p.code == element.code
        }
        return filter.count > 0
    }
    
    public func add (_ element: OptionData) {
        print(dbPath)
        opts.append(element)
        /// 缓存到本地啊
        saveToFile()
    }
    
    @discardableResult
    public func saveToFile() -> Bool {
        let url = URL(fileURLWithPath: self.dbPath)
        guard let jsonString = opts.toJSONString() else { return false }
        guard let data = jsonString.data(using: .utf8) else { return false }
        do {
            try data.write(to: url)
            return true
        } catch _ {
            return false
        }
    }
    
    public func remove(_ element: OptionData ){
        
        /// s首先读取数据

        /// 删除固定元素
 

            /// 过滤数组，重写数据
            let otpss = self.opts.filter { (result) -> Bool in
                result.code != element.code
            }
            self.opts = otpss

          saveToFile()
    }
    
    
    @objc func  changeDB(notion:Notification){
        print(notion.userInfo as Any)
        let dict = notion.userInfo as? [String:Any]
//        let optionData = notion.object as? OptionData
     
        let showModel = dict?["userInfo"] as? OptionData

        
        guard let readAray = NSMutableArray(contentsOfFile: writableDBPath) else {
            /// 首选读取数据，如果为空，则创建
            var  array = NSMutableArray()
            
            var  dict = [String: String]()
            ///首先写入部分s数据
            dict["code"] = showModel?.code
            array.add(dict)
            ///转化为字典，然后进行存储信息，先读取元素
            array.write(toFile: writableDBPath, atomically: true)
            return
        }
        
        if readAray.count > 0 {
            /// 首先先放进去，然后去重，再重新放一次
            var filterArray = [OptionData]()
            /// 数据转化 在总体读到的数据里面进行筛查
            for item   in readAray {
                //                print(item)
                //     1" 数据解析 数据model 解析
                let showDict = item as? [String: Any]
                print(showDict?["code"])
                
                guard let showModel = Mapper<OptionData>().map(JSONObject: showDict ) else{
                    return
                }
                //2: 数据添加到数组，进行比对筛查
                //    let showModel = showDict?["code"] as? OptionData
                print(showModel.code)
                //3: 形成新的数组数据
                filterArray.append(showModel)
                //4:完成应用
            }
            
            let newArray = filterArray.filter { (res) -> Bool in
                res.code == showModel?.code
            }
            /// 借用双重判断标准数据
            if  newArray.count > 0 { /// 说明之前添加过了 不添加，删除元素
                ///   直接把上面返回的写入
                let dictArray = filterArray.filter { (res) -> Bool in
                    res.code != showModel?.code
                }
                /// newArray 转化为字典对象，存储
                readAray.removeAllObjects()
                
                for modelItem in dictArray{
                    var  dict = [String: String]()
                    ///首先写入部分s数据
                    dict["code"] = modelItem.code
                    readAray.add(dict)
                }
                readAray.write(toFile: writableDBPath, atomically: true)
                
            }else{
                ///添加
                var  dict = [String: String]()
                
                dict["code"] = showModel?.code
                readAray.add(dict)
                readAray.write(toFile: writableDBPath, atomically: true)
            }
        }
      
}
    
    
    /// 返回一个包含数据的对象
    func returnDBdata() ->(Array<OptionData>){
        var  filterArray = [OptionData]()
            var  readAray = NSMutableArray(contentsOfFile: writableDBPath)
            for item   in readAray  ?? NSMutableArray() {
            //                print(item)
            //     1" 数据解析 数据model 解析
            let showDict = item as? [String: Any]
            guard let showModel = Mapper<OptionData>().map(JSONObject: showDict ) else{
                return [OptionData]()
            }
            //3: 形成新的数组数据
            filterArray.append(showModel)
            //4:完成应用
        }
        return filterArray
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
