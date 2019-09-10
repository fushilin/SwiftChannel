//
//  NetworkError.swift
//  CandleStickChart_Swift_Demo
//
//  Created by lam on 2019/7/10.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import ZRBase

// stolen from python-requests
let statusCodeDescriptions = [
    // Informational.
    100: "continue",
    101: "switching protocols",
    102: "processing",
    103: "checkpoint",
    122: "uri too long",
    200: "ok",
    201: "created",
    202: "accepted",
    203: "non authoritative info",
    204: "no content",
    205: "reset content",
    206: "partial content",
    207: "multi status",
    208: "already reported",
    226: "im used",
    
    // Redirection.
    300: "multiple choices",
    301: "moved permanently",
    302: "found",
    303: "see other",
    304: "not modified",
    305: "use proxy",
    306: "switch proxy",
    307: "temporary redirect",
    308: "permanent redirect",
    
    // Client Error.
    400: "bad request",
    401: "unauthorized",
    402: "payment required",
    403: "forbidden",
    404: "not found",
    405: "method not allowed",
    406: "not acceptable",
    407: "proxy authentication required",
    408: "request timeout",
    409: "conflict",
    410: "gone",
    411: "length required",
    412: "precondition failed",
    413: "request entity too large",
    414: "request uri too large",
    415: "unsupported media type",
    416: "requested range not satisfiable",
    417: "expectation failed",
    418: "im a teapot",
    422: "unprocessable entity",
    423: "locked",
    424: "failed dependency",
    425: "unordered collection",
    426: "upgrade required",
    428: "precondition required",
    429: "too many requests",
    431: "header fields too large",
    444: "no response",
    449: "retry with",
    450: "blocked by windows parental controls",
    451: "unavailable for legal reasons",
    499: "client closed request",
    
    // Server Error.
    500: "internal server error",
    501: "not implemented",
    502: "bad gateway",
    503: "service unavailable",
    504: "gateway timeout",
    505: "http version not supported",
    506: "variant also negotiates",
    507: "insufficient storage",
    509: "bandwidth limit exceeded",
    510: "not extended",
]


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
        case .decryptedError: return kNetworkLoc("HTTP 解密失败")
        case .toJsonError: return kNetworkLoc("HTTP JSON解析失败")
        case .jsonError: return kNetworkLoc("HTTP JSON解析失败")
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
