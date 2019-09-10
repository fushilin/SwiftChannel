//
//  Router.swift
//  DYBaseModule
//
//  Created by lam on 2019/7/11.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// 单例
public let Router = ZRRouter()

/// 内路由类
public class ZRRouter: NSObject {
    /// push
    @discardableResult
    public func push(of target:MediatorTargetType,url: URLConvertible? = nil, from: UINavigationController? = nil, parameter:[String: Any]? = nil,animated: Bool = true) -> UIViewController? {
        guard let viewController = self.viewController(of:target) else { return nil }
        
        /// 传参
        var param = url?.queryParameters ?? [String : Any]()
        param.append(parameter)
        viewController.routerReceiveParameter(url: url?.urlStringValue ?? "target", parameter: param)
        
        viewController.hidesBottomBarWhenPushed = true
        guard let navigationController = from ?? UIViewController.topMost?.navigationController else { return nil }
        navigationController.pushViewController(viewController, animated: animated)
        return viewController
    }
    
    /// present
    @discardableResult
    public func present(of target:MediatorTargetType, url: URLConvertible? = nil, from: UIViewController? = nil, parameter:[String: Any]? = nil, wrap: UINavigationController.Type? = UINavigationController.self, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        
        guard let viewController = self.viewController(of:target) else { return nil }
        
        /// 传参
        var param = url?.queryParameters ?? [String : Any]()
        param.append(parameter)
        viewController.routerReceiveParameter(url: url?.urlStringValue ?? "target", parameter: param)
        
        guard let fromViewController = from ?? UIViewController.topMost else { return nil }
        
        let viewControllerToPresent: UIViewController
        if let navigationControllerClass = wrap, (viewController is UINavigationController) == false {
            viewControllerToPresent = navigationControllerClass.init(rootViewController: viewController)
        } else {
            viewControllerToPresent = viewController
        }
        
        fromViewController.present(viewControllerToPresent, animated: animated, completion: completion)
        return viewController
    }
}


extension ZRRouter: SwiftyMediatorType {
    public func viewController(of target: MediatorTargetType) -> UIViewController? {
        guard let t = target as? MediatorSourceType else {
            print("MEDIATOR WARNINIG: \(target) does not conform to MediatorSourceType")
            return nil
        }
        guard let viewController = t.viewController else { return nil }
        return viewController
    }
}


extension Dictionary {
    /// 拼接
    mutating public func append(_ dict: Dictionary?) {
        dict?.forEach { (key, value) in
            self.updateValue(value, forKey: key)
        }
    }
}




