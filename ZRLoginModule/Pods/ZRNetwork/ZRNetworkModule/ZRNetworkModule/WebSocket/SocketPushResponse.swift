//
//  SocketPushResponse.swift
//  ZRNetworkModule
//
//  Created by Zhuorui on 2019/7/24.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import ObjectMapper

/// 推送header
internal class SocketPushHeader: NSObject, Mappable {
    
    /// req_id
    internal var reqId: String?
    
    /// path
    internal var path: String = ""
    
    required init?(map: Map) {
        let json = map.JSON
        if json["path"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        reqId <- map["reqId"]
        path <- map["path"]
    }
    
    
}

/// 推送数据
internal class SocketPushResponse: NSObject,Mappable {
    
    /// header
    internal var header: SocketPushHeader?
    
    /// body
    internal var body: Any?
    
    required init?(map: Map) {
        let json = map.JSON
        if json["header"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        header <- map["header"]
        body <- map["body"]
    }
    
    
}
