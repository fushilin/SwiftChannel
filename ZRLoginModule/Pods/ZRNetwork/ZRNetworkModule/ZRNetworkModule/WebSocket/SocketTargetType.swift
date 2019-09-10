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
    
    /// timeout(s)
    var timeout: Int { get }
}

extension SocketTargetType {
   public var timeout: Int {
        return 60
    }
    
}

/// 认证
internal struct SocketAuthTarget: SocketTargetType {
    
    var path: String {
        return "auth.auth"
    }
    
    var parameter: [String : Any]? {
        /// uuid
        let uuid = UIDevice.base.UUID ?? ""
        /// timestamp
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000.0)
        /// 签名key
        let signKey = "069d" + "e799" + "0c0c4b8" + "d87f5" + "16b7478e9f4a"
        /// token
        let token = (uuid + String(timestamp) + signKey).md5()
        return ["devId": uuid,"timestamp":timestamp,"token": token]
    }
}

