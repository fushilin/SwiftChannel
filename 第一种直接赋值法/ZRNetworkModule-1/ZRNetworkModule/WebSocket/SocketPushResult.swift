//
//  SocketPushResult.swift
//  ZRNetworkModule
//
//  Created by Zhuorui on 2019/7/24.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import ObjectMapper

/// 服务器推送数据
open class SocketPushResult: NSObject {
    /// 数据
    open var data: Any?
    /// path
    open var path: String = ""
    
    public override init() {
        super.init()
    }
    
    public convenience init(_ path: String, data: Any?) {
        self.init()
        self.data = data
        self.path = path
    }
}
