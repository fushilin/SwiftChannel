//
//  MediatorRoutable.swift
//  DYBaseModule
//
//  Created by lam on 2019/7/11.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// 初始化协议
public protocol MediatorRoutable where Self: MediatorTargetType {
    
    /// 初始化，用于url映射
    init?(url: URLConvertible)
    
    /// 模块名字
    static var moduler: String { get }
}
