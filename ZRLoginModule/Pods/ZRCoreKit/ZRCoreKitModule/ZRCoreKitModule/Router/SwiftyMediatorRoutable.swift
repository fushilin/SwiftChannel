//
//  SwiftyMediatorRoutable.swift
//  DYBaseModule
//
//  Created by lam on 2019/7/11.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit

/// 注册协议
public protocol SwiftyMediatorRouterStoreType {
    /// 属性
    var routeTargets: [String: MediatorRoutable.Type] { get set }
}

/// 增加协议
public protocol SwiftyMediatorRoutable where Self: SwiftyMediatorRouterStoreType {
    
    /// 注册模块
    func register(_ targetType: MediatorRoutable.Type)
    
    /// URLConvertible 转 MediatorTargetType
    func targetType(of url: URLConvertible) -> MediatorTargetType?
    
    /// 获取vc
    func viewController(of url: URLConvertible) -> UIViewController?
}
