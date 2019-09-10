//
//  SocketTargetType.swift
//  ZRNetworkModule
//
//  Created by Zhuorui on 2019/7/24.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import ZRBase

/// socket 入参协议
public protocol SocketTargetType {
    /// 路径
    var path: String { get }
    /// 参数
    var parameter: [String : Any]? { get }
}

/// 认证
internal enum SocketAuthTarget : SocketTargetType {
    case atuh
    
    var path: String {
        return "auth.auth"
    }
    
    var parameter: [String : Any]? {
        /// uuid
        let uuid = UIDevice.UUID ?? ""
        /// timestamp
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000.0)
        /// 签名key
        let signKey = "069d" + "e799" + "0c0c4b8" + "d87f516b7478e9f4a"
        /// token
        let token = (uuid + String(timestamp) + signKey).md5()
        
        return ["dev_id": uuid,"timestamp":timestamp,"token": token]
    }
}

