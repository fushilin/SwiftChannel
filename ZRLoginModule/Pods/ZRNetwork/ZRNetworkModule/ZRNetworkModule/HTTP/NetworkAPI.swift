//
//  NetworkAPI.swift
//  CandleStickChart_Swift_Demo
//
//  Created by lam on 2019/7/9.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// Http API 协议
public protocol NetworkAPI {
    
    /// 路径
    var path: String { get }
    
    /// 参数
    var parameters: [String: Any]? { get }
}








