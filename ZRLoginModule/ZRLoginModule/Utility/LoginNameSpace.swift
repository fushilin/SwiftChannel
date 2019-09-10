//
//  LoginNameSpace.swift
//  ZRLoginModule
//
//  Created by Zhuorui on 2019/8/14.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import Foundation
/// Login 组件命名空间协议
public protocol LoginNameSpaceWrappable {
    
    /// type
    associatedtype LoginWrapperType
    
    /// 空间命名
    var login: LoginWrapperType { get }
    
    /// 空间命名
    static var login: LoginWrapperType.Type { get }
}

/// 空间
public extension LoginNameSpaceWrappable {
    
    var login: LoginNameSpaceWrapper<Self> {
        return LoginNameSpaceWrapper(value: self)
    }
    
    static var login: LoginNameSpaceWrapper<Self>.Type {
        return LoginNameSpaceWrapper.self
    }
}

// 命名空间中间层
public struct LoginNameSpaceWrapper<T> {
    
    public var wrappedValue: T
    
    public init(value: T) {
        self.wrappedValue = value
    }
}


// MARK: - UIImage 图片资源
extension NSObject : LoginNameSpaceWrappable { }
