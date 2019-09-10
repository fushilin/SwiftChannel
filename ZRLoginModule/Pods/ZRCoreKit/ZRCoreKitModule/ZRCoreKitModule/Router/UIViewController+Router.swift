//
//  UIViewController+Router.swift
//  DYBaseModule
//
//  Created by lam on 2019/7/11.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit

/// URL路由参数获取
public  protocol MediatorParameter {
    
    /// 传参方式
    func routerReceiveParameter(url: String, parameter: [String : Any]?)
}

/// 参数协议
extension UIViewController: MediatorParameter {
    
    @objc open func routerReceiveParameter(url: String, parameter: [String : Any]?) {
        
    }
}


extension UIViewController {

    /// push
    @discardableResult
    public func push(of target:MediatorTargetType, parameter:[String: Any]? = nil, animated: Bool = true)-> UIViewController? {
        return Router.push(of: target, from: self.navigationController,parameter:parameter, animated: animated)
    }
    
    /// push
    @discardableResult
    public func push(_ url: URLConvertible, parameter:[String: Any]? = nil, animated: Bool = true)-> UIViewController? {
        return Router.push(url, from: self.navigationController,parameter:parameter, animated: animated)
    }
    
    /// present
    @discardableResult
    public func present(of target:MediatorTargetType, parameter:[String: Any]? = nil, animated: Bool = true, completion: (() -> Void)? = nil)-> UIViewController?{
        return Router.present(of: target, parameter:parameter,wrap:RTRootNavigationController.self,animated: animated, completion: completion)
    }
    
    
    /// present
    @discardableResult
    public func present(_ url: URLConvertible, parameter:[String: Any]? = nil, animated: Bool = true, completion: (() -> Void)? = nil)-> UIViewController?{
        return Router.present(url, parameter:parameter,wrap:RTRootNavigationController.self,animated: animated, completion: completion)
    }
    
}
