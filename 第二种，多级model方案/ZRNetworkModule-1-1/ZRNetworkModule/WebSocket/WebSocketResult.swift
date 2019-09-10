//
//  WebSocketResult.swift
//  ZRNetworkModule
//
//  Created by Zhuorui on 2019/7/24.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// 请求结果
public enum WebSocketSendResult {
    /// 成功
    case success(WebSocketResult)
    /// 失败
    case failure(Error)
}

/// 请求成功
public let websocketResultSuccess = "0"

/// 默认失败
public let websocketResultFail = "-1"

/// 返回数据
open class WebSocketResult: NSObject {
    /// code
    open var code: String = websocketResultFail
    
    /// msg
    open var msg: String?
    
    /// path
    open var path: String = ""
    
    /// data
    open var data: Any?
    
    /// code
    init(code: String, path: String, msg: String?, data: Any?) {
        self.code = code
        self.path = path
        self.msg = msg
        self.data = data
    }
}
