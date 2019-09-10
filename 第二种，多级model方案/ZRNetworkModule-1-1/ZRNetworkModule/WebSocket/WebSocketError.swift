//
//  WebSocketError.swift
//  ZRNetworkModule
//
//  Created by Zhuorui on 2019/7/24.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// 错误
public enum WebSocketError: Error {
    
    /// 未连接
    case unconnect
    
    /// 超时
    case packetTimeout
    
    /// 断开链接
    case disconnect
    
    /// 心跳超时
    case heartbeatTimeout
}

// MARK: - Error Descriptions
extension WebSocketError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unconnect: return NetworkLoc("socket未链接")
        case .packetTimeout: return NetworkLoc("发包超时")
        case .disconnect: return NetworkLoc("断开链接")
        case .heartbeatTimeout: return NetworkLoc("心跳超时")
        }
    }
}

// MARK: - Error User Info
extension WebSocketError: CustomNSError {
    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        return userInfo
    }
    
    public var errorCode: Int {
        switch self {
            case .unconnect: return -100111111
            case .packetTimeout: return -100111112
            case .disconnect: return -100111113
            case .heartbeatTimeout: return -100111114
        }
    }
}
