//
//  Network.swift
//  ZRNetworkModule
//
//  Created by Zhuorui on 2019/7/24.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import Moya
import ZRBase
import ZRModel


/// 完成回调
public typealias NetworkCompletion = (_ response: ResponseResult)->()

/// 进度回调
public typealias NetworkProgress = (_ progress: Double) -> ()

/// 请求措施
fileprivate let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<Network>.RequestResultClosure) -> Void in
    
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

/// http 请求载体
open class Network<T: NetworkAPI>: NSObject {
    
    /// 请求体
    private let moya = MoyaProvider<Network>(requestClosure:timeoutClosure)
    
    /// 请求API
    private var api: T?
    
    /// 请求
    @discardableResult
    /// 请求
    open func request(_ t: T,  callbackQueue: DispatchQueue? = DispatchQueue.main, progressClosure: NetworkProgress? = nil ,completion: NetworkCompletion?) -> Cancellable {
        self.api = t
        return moya.request(self, callbackQueue: callbackQueue, progress: {
            (progress) in
            /// 回调进度
            progressClosure?(progress.progress)
            
        }, completion: {
            (result) in
            switch result {
            case .success(let response):
                /// json数据
                guard let json = String(data: response.data, encoding: .utf8) else {
                    completion?(.failure(NetworkError.toJsonError))
                    return
                }
                
                /// 解析
                guard let rs = NetworkResult(JSONString: json) else {
                    completion?(.failure(NetworkError.toJsonError))
                    return
                }
                
                completion?(.success(rs))
                break
                
            case .failure(let error):
                completion?(.failure(error))
                break
            }
        })
    }
}

// MARK: - TargetType
extension Network: TargetType {
    /// 基础url
    public var baseURL: URL {
        switch ConfigurationManager.default.current {
            
        case .DEV:
            return URL(string: "http://192.168.1.211")!
            
        case .TEST:
            return URL(string: "http://192.168.1.211")!
            
        case .RELEASE:
            return URL(string: "http://192.168.1.211")!
        }
    }
    
    /// 路径
    public var path: String {
        if let api = self.api {
            return api.path
        }
        return ""
    }
    
    /// 方法
    public var method: Moya.Method {
        return .post
    }
    
    /// 单元测试
    public var sampleData: Data {
        return Data()
    }
    
    /// task 任务
    public var task: Task {
        
        /// 入参
        var parameters = self.api?.parameters ?? [String: Any]()
        /// 加上时间戳
        parameters["timeStamp"] = Int(Date().timeIntervalSince1970 * 1000.0)
        /// 加上签名
        parameters["sign"] = Signer.signed(parameters)
        
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }
    
    /// header
    public var headers: [String : String]? {
        
        var headers: [String : String] = [:]
        
        // token
        headers["token"] = UserManager.default.user.token ?? ""
        
        // 系统
        headers["osType"] = "IOS"
        
        // deviceId
        headers["deviceId"] = UIDevice.UUID
        
        //osVersion,系统版本
        headers["osVersion"] = UIDevice.current.systemVersion
        
        //app版本
        headers["appVersion"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
        
        // 语言
        headers["lang"] = LanguageManager.default.serverLanuage
        
        /// content type
        headers["Content-Type"] = "application/json; charset=utf-8"
        
        return headers
    }
}
