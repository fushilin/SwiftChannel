//
//  WebSocketManager.swift
//  ZRNetworkModule
//
//  Created by Zhuorui on 2019/7/24.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import ZRBase
import Starscream
import Gzip


/// 链接状态
public enum WebSocketStatus {
    /// 未链接
    case unconnect
    /// 连接中
    case connecting
    /// 已连接
    case connected
    /// 未认证
    case unauthorized
    /// 已经认证
    case authorized
    
    /// 是否已经链接上
    public var isConnected: Bool {
        
        switch self {
        case .connected,.unauthorized,.authorized:
            return true
            
        default:
            return false
        }
    }
}


/// 完成回调
public typealias WebSocketClosure = (_ sendResult: WebSocketSendResult)->()

/* 配置默认值 */

/// 心跳默认值 30s
private let heartbeatIntervalDefault: Int = 30

/// 心跳计数 heartbeat timeout = (heartbeatCountDefault + 1)  * heartbeatIntervalDefault
private let heartbeatCountDefault: Int = 3

/// 重连延迟默认值 5s
private let TimeIntervalDefault: TimeInterval = 5.0

/// 全局管理器
public let webSocketM: WebSocketManager = WebSocketManager.default

/// web socket 管理器
public class WebSocketManager: NSObject {
    
    /// 根据不同环境,配置不同URL
    private var url: URL {
        var urlString = ""
        switch ConfigurationManager.default.current {
        case .DEV:
            urlString = "ws://192.168.1.213:1949"
        case .TEST:
            urlString = "ws://192.168.1.213:1949"
        case .RELEASE:
            urlString = "ws://192.168.1.213:1949"
        }
        return URL(string: urlString)!
    }
    
    /// 静态初始化
    public static let `default`: WebSocketManager = WebSocketManager()
    
    /// web socket
    private lazy var socket: WebSocket = {
        let request = URLRequest(url: url)
        let _socket = WebSocket(request: request)
        _socket.delegate = self
        _socket.pongDelegate = self
        // TODO: wss需要配置SSL证书
        
        return _socket
    }()
    
    /// 链接
    public var status: WebSocketStatus = .unconnect
    
    /// 包管理id
    private var packetIndex: Int = 0
    
    /// 包容器
    private var packets: [String : SocketIOPacket] = [String : SocketIOPacket]()
    
    /// 重连间隔
    private var reInterval: TimeInterval = TimeIntervalDefault
    
    /// app 状态
    private var applicationState: UIApplication.State {
        return UIApplication.shared.applicationState
    }
    
    /// 心跳间隔
    private var heartbeatInterval: Int = heartbeatIntervalDefault
    
    /// 心跳次数
    private var heartbeatCount: Int = heartbeatCountDefault
    
    /// 心跳定时器
    private var heartbeatTimer: DispatchSourceTimer?
    
    /// 定时器校验
    private var heartbeatTimerCheck: Bool = false
    
    override init() {
        super.init()
        /// 注册app活动通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didBecomeActiveNotification(_:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackgroundNotification(_:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    /// 开始连接
    public func connect(){
        /// 未链接的时候才链接,判断app状态,防止重连延迟任务在后台发生
        if status == .unconnect, applicationState == .active {
            socket.connect()
            status = .connecting
        }
    }
    
    /// 断开
    public func disconnect() {
        if status.isConnected {
            socket.disconnect()
        }
    }
}

/// 包管理扩展
extension WebSocketManager {
    /// 发送数据
    public func send<T: SocketTargetType>(_ target: T, completion: WebSocketClosure? = nil) {
        /// 判断连接状态
        
        switch status {
            /// 认证完成才能发送数据
        case .authorized:
            /// 发送数据
            write(target, completion: completion)
            break
            
        case .unauthorized:
            completion?(.failure(WebSocketError.unauthorized))
            break
            
        default:
            completion?(.failure(WebSocketError.unconnect))
            break
        }
    }
    
    /// 内部发送数据
    private func write(_ target: SocketTargetType, completion: WebSocketClosure? = nil) {
        /// 获取参数
        let path = target.path
        let param = target.parameter
        let timeout = target.timeout
        
        /// 自增
        packetIndex += 1
        let req_id = packetIndex
        
        /// 创建packet
        let packet = SocketIOPacket(req_id, path: path, param: param,timeout:timeout, closure: completion)
        
        /// 处理回调
        packet.timeoutClosure = { [weak self] in
            self?.handlePacketTimeout()
        }
        
        /// 发送数据
        socket.write(data: packet.gzipData)
        
        /// 缓存包
        packets[packet.key] = packet
        
        /// 开启包timeout
        packet.startTimeout()
    }
    
    /// 处理包的响应数据
    private func handlePacketResponse(_ response: SocketIOResponse) {
        
        /// 找到包
        if let pakcet = packets[response.key] {
            /// 回调
            let result = WebSocketResult(code: response.code,path: response.path, msg: response.msg, data: response.data)
            pakcet.closure?(.success(result))
            
            /// 删除包
            pakcet.stopTimeout()
            packets.removeValue(forKey: response.key)
        }
    }
    
    /// 处理服务器推送数据
    private func handleServerPushResponse(_ response: SocketPushResponse) {
        /// 取头数据
        if let header = response.header {
            
            let result = SocketPushResult(header.path, data: response.body)
            
            /// 发送通知推送
            NotificationCenter.default.post(name: WebSocketManager.didReceiveDataPushNotification, object: result, userInfo: nil)
        }
    }
    
    /// 处理包超时
    private func handlePacketTimeout() {
        /// 清理所有包
        handleRemoveAllPacket(WebSocketError.packetTimeout)
        /// 断开链接
        socket.disconnect()
    }
    
    
    /// 删除所有包,有error回调
    private func handleRemoveAllPacket(_ error: Error?) {
        if let err = error, packets.count > 0 {
            for (_,packet) in packets {
                packet.closure?(.failure(err))
            }
        }
        /// 清理所有包
        packets.removeAll()
    }
}


// MARK: - WebSocketDelegate
extension WebSocketManager : WebSocketDelegate {
    
    /// 链接完成
    public func websocketDidConnect(socket: WebSocketClient) {
        /// 修改链路状态
        status = .connected
        
        /// 发送链路认证
        status = .unauthorized
        write(SocketAuthTarget(), completion: {[weak self] rst in
            
            guard let manager = self else { return }
            
            switch rst {
            case .success(let result):
                /// 认证成功
                if result.code == websocketResultSuccess {
                    manager.status = .authorized
                    /// 发送通知
                    NotificationCenter.default.post(name: WebSocketManager.didAuthorizedNotification, object: nil)
                }
                break
            case .failure:
                break
            }
        })
        
        /// 开始心跳
        beginHeartbeat()
        
        /// 发送链接完成通知
        NotificationCenter.default.post(name: WebSocketManager.didConnectNotification, object: nil)
    }
    
    /// 链接断开
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        /// 设置状态
        status = .unconnect
        
        /// 结束心跳
        endHeartbeat()
        
        /// 处理未回调包
        handleRemoveAllPacket(WebSocketError.disconnect)
        
        /// 发送链接断开通知
        NotificationCenter.default.post(name: WebSocketManager.didDisconnectNotification, object: error)
        
        /// 重连
        reconnect()
    }
    
    /// 读取String数据
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        /// 重置心跳
        resetHeartbeat()
        
        /// 处理数据
        websocketDidReceiveJson(socket: socket, json: text)
    }
    
    /// 读取Data二进制数据
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
        /// 重置心跳
        resetHeartbeat()
        
        /// 解析数据
        var jsonData = data
        
        /// 是否gzip进行解压
        if data.isGzipped, let gzipData = try? data.gunzipped() {
            jsonData = gzipData
        }
        
        /// 容错
        guard let json = String(data: jsonData, encoding: .utf8) else { return }
        
        /// 数据处理
        websocketDidReceiveJson(socket: socket, json: json)
    }
    
    /// 解析数据
    private func websocketDidReceiveJson(socket: WebSocketClient, json: String) {
        
        /// packet响应包
        if let resp = SocketIOResponse(JSONString: json) {
            handlePacketResponse(resp)
            
            /// 服务器推送
        } else if let push = SocketPushResponse(JSONString: json) {
            handleServerPushResponse(push)
            
        } else {
            /// 其他数据忽略
        }
    }
}

// MARK: - 心跳
extension WebSocketManager: WebSocketPongDelegate {
    
    /// 接受pong
    public func websocketDidReceivePong(socket: WebSocketClient, data: Data?) {
        /// 重置次数
        self.heartbeatCount = heartbeatCountDefault
    }
    
    /// 开始心跳
    private func beginHeartbeat() {
        
        /// 初始化定时器
        heartbeatTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        
        heartbeatTimer?.schedule(deadline: .now(), repeating:.seconds(self.heartbeatInterval))
        
        heartbeatTimerCheck = false
        
        /// 设置回调
        heartbeatTimer?.setEventHandler(handler: { [weak self] in
            
            guard let manager = self else { return }
            
            if manager.heartbeatTimerCheck {
                manager.heartbeatCount -= 1
                /// 次数
                if manager.heartbeatCount >= 0 {
                    manager.sendPing()
                } else {
                    manager.heartbeatTimeout()
                }
            }
            
            manager.heartbeatTimerCheck = true
        })
        
        /// 开始
        heartbeatTimer?.resume()
    }
    
    /// 结束心跳
    private func endHeartbeat() {
        heartbeatCount = heartbeatCountDefault
        heartbeatTimer?.cancel()
        heartbeatTimer = nil
    }
    
    /// 重置心跳
    private func resetHeartbeat() {
        endHeartbeat()
        beginHeartbeat()
    }
    
    /// 心跳超时
    private func heartbeatTimeout() {
        /// 结束
        endHeartbeat()
        /// 错误
        handleRemoveAllPacket(WebSocketError.heartbeatTimeout)
        /// 断开链接
        disconnect()
    }
    
    /// 发送ping
    private func sendPing() {
        /// 判断链接上才发ping
        if status.isConnected {
            /// 发送ping的空包
            socket.write(ping: Data())
        } else {
            /// 结束心跳
            endHeartbeat()
        }
    }
    
}

// MARK: - 通知&重连
extension WebSocketManager {
    /// 重连
    private func reconnect() {
        /// 在程序活动的时候才自动发起重连
        if applicationState == .active {
            /// 延迟操作
            DispatchQueue.main.asyncAfter(deadline: .now() + reInterval) { [weak self] in
                self?.connect()
            }
        }
    }
    
    /// 从后台回来
    @objc private func didBecomeActiveNotification(_ notfi: Notification) {
        connect()
    }
    
    /// 进入后台
    @objc private func didEnterBackgroundNotification(_ notfi : Notification) {
        
    }
}

// MARK: - 自定义通知
extension WebSocketManager {
    
    /// 完成链接通知名
    public static let didConnectNotification: Notification.Name = Notification.Name(rawValue: "WSDidConnectNotification")
    
    /// 完成认证通知名
    public static let didAuthorizedNotification: Notification.Name = Notification.Name(rawValue: "WSAuthorizedNotification")
    
    /// 断开链接通知名
    public static let didDisconnectNotification: Notification.Name = Notification.Name(rawValue: "WSDidDisconnectNotification")
    
    /// 服务器主动接受数据通知
    public static let didReceiveDataPushNotification: Notification.Name = Notification.Name(rawValue: "WSDidReceiveDataPushNotification")
}
