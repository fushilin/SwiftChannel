//
//  SocketIOPacket.swift
//  ZRNetworkModule
//
//  Created by Zhuorui on 2019/7/24.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import Gzip
import ZRBase

/// 发送包数据
internal class SocketIOPacket: NSObject {
    
    typealias TimeoutClosure = (()->Void)
    
    /// request id,用于标记表
    internal var req_Id: String = "0"
    
    /// 请求路径
    internal var path: String = ""
    
    /// 请求参数
    internal var param: [String : Any]?
    
    /// key
    internal var key: String {
        return self.path + "_" + self.req_Id
    }
    
    /// 超时闭包
    internal var timeoutClosure: TimeoutClosure?
    
    /// 定时器,回调main函数里面
    private var timer: DispatchSourceTimer?
    
    /// 超时时间
    internal var timeout: Int = 0
    
    /// 定时器校验
    private var timerCheck: Bool = false
    
    /// 持有对外的回调
    internal var closure: WebSocketClosure?
    
    /// 请求数据拼接
    internal var jsonData: Data {
        
        /// 数据拼接
        var packet = [String : Any]()
        
        /// header
        var header = [String : Any]()
        /// req_id
        header["req_id"] = String(self.req_Id)
        /// path
        header["path"] = self.path
        /// 语言
        header["language"] = LanguageManager.default.serverLanuage
        /// app version
        header["version"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
        /// 拼接header
        packet["header"] = header
        
        /// 拼接 body
        packet["body"] = self.param ?? [:]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: packet, options: []) {
            return jsonData
        }
        
        return Data()
    }
    
    /// gzip data
    internal var gzipData: Data {
        if let gzip = try? self.jsonData.gzipped() {
            return gzip
        }
        return Data()
    }
    
    override init() {
        super.init()
    }
    
    
    /// 初始化默认超时时间 60s
    convenience init(_ req_Id: Int, path: String, param: [String : Any]?, timeout: Int = 60, closure: WebSocketClosure? = nil) {
        self.init()
        self.req_Id = String(req_Id)
        self.path = path
        self.param = param
        self.closure = closure
        self.timeout = timeout
    }
    
    /// 开始超时定时
    internal func startTimeout() {
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        self.timer?.schedule(deadline: .now(), repeating:.seconds(timeout))
        
        self.timerCheck = false
        
        /// 设置回调
        self.timer?.setEventHandler(handler: { [weak self] in
            guard let packet = self else { return }
            if packet.timerCheck {
                packet.timeoutClosure?()
                packet.stopTimeout()
            }
            packet.timerCheck = true
        })
        /// 开始
        self.timer?.resume()
    }
    
    /// 停止
    internal func stopTimeout() {
        self.timer?.cancel()
        self.timer = nil
    }
 
    /// 析构函数
    deinit {
        stopTimeout()
    }

}

