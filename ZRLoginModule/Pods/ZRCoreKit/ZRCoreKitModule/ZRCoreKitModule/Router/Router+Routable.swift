//
//  Router+Routable.swift
//  DYBaseModule
//
//  Created by lam on 2019/7/11.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

private var routeTargetsKey = "routeTargetsKey"

/// 添加属性
extension ZRRouter: SwiftyMediatorRouterStoreType {
    
    /// 路由影射
    public var routeTargets: [String: MediatorRoutable.Type] {
        get { return objc_getAssociatedObject(self, &routeTargetsKey) as? [String: MediatorRoutable.Type] ?? [:] }
        set { objc_setAssociatedObject(self, &routeTargetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

/// 注册
extension ZRRouter: SwiftyMediatorRoutable {
    
    /// 注册
    public func register(_ targetType: MediatorRoutable.Type) {
        self.routeTargets[targetType.moduler] = targetType
    }
    
    /// URLConvertible 转 targetType
    public func targetType(of url: URLConvertible) -> MediatorTargetType? {
        guard let moduler = url.moduler else { return nil }
        guard let routable = routeTargets[moduler] else { return nil }
        guard let table = routable.init(url: url) else { return nil }
        guard let target = table as? MediatorTargetType else { return nil }
        return target
    }
    
    /// 获取vc
    public func viewController(of url: URLConvertible) -> UIViewController? {
        guard let target = self.targetType(of: url) else { return nil }
        return self.viewController(of: target)
    }
    
}


// MARK: - push present
extension ZRRouter {
    
    /// push URLConvertible
    @discardableResult
    public func push(_ url: URLConvertible, from: UINavigationController? = nil, parameter:[String: Any]? = nil, animated: Bool = true) -> UIViewController? {
        guard let target = self.targetType(of: url) else { return nil }
        return self.push(of: target, url:url, from: from,parameter: parameter, animated: animated)
    }
    
    /// present URLConvertible
    @discardableResult
    public func present(_ url: URLConvertible, from: UIViewController? = nil, parameter:[String: Any]? = nil, wrap: UINavigationController.Type? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        guard let target = self.targetType(of: url) else { return nil }
        return self.present(of:target, url:url, from: from,parameter: parameter, wrap: wrap, animated: animated, completion: completion)
    }
    
}
