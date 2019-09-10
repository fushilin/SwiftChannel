//
//  SocketIOResponse.swift
//  ZRNetworkModule
//
//  Created by Zhuorui on 2019/7/24.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import ObjectMapper

/// 响应包
internal class SocketIOResponse: NSObject, Mappable {
    
    /// code
    internal var code: String = ""
    
    /// msg
    internal var msg: String?
    
    /// path
    internal var path: String = ""
    
    /// resp_id 对应req_id
    internal var respId: String = "0"
    
    /// key
    internal var key: String {
        return self.path + "_" + self.respId
    }
    
    /// data
    internal var data: Any?
    
    required init?(map: Map) {
        let json = map.JSON
        if json["path"] == nil || json["respId"] == nil || json["code"] == nil {
            return nil
        }
    }
    
     func mapping(map: Map) {
        code <- map["code"]
        msg <- map["msg"]
        path <- map["path"]
        respId <- map["respId"]
        data <- map["data"]
    }


}
