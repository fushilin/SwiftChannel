//
//  NetworkResult.swift
//  CandleStickChart_Swift_Demo
//
//  Created by lam on 2019/7/9.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import ObjectMapper

/// Http请求结果
public enum ResponseResult {
    /// 成功
    case success(NetworkResult)
    /// 失败
    case failure(Error)
}

/// 成功
public let networkResultSuccess = "000000"

/// 默认错误
public let networkResultFail = "-1"

/// 请求返回结果model
open class NetworkResult: NSObject,Mappable {
    
    /// msg
    open var msg: String? = ""
    
    /// 请求code
    open var code: String = networkResultFail
    
    /// 返回数据
    open var data: Any?
    
    /// 强制元素
    required public init?(map: Map) {
        let json = map.JSON
        if json["code"] == nil {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        data <- map["data"]
        msg  <- map["msg"]
        code <- map["code"]
    }
    
    //父类的init方法是必须去实现的
    override init() {
        super.init()
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
    }
}


extension String {
    
    /// 是否成功
    var isNetworkSuccess: Bool {
        return self == networkResultSuccess
    }
}

