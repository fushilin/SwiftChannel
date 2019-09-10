//
//  NetworkError.swift
//  CandleStickChart_Swift_Demo
//
//  Created by lam on 2019/7/10.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import ZRBase



/// 自定义请求错误
public enum NetworkError: Error {
    /// 解密错误
    case decryptedError
    /// to json string错误
    case toJsonError
    /// 解析错误
    case jsonError
}


// MARK: - Error Descriptions
extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decryptedError: return NetworkLoc("解密失败")
        case .toJsonError: return NetworkLoc("JSON解析失败")
        case .jsonError: return NetworkLoc("JSON解析失败")
        }
    }
}

// MARK: - Error User Info
extension NetworkError: CustomNSError {
    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        return userInfo
    }
    
    public var errorCode: Int {
        switch self {
        case .decryptedError: return -10000000
        case .toJsonError: return -10000001
        case .jsonError: return -10000002
        }
    }
}
