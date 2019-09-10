//
//  NetworkNameSpace.swift
//  ZRNetworkModule
//
//  Created by Zhuorui on 2019/8/7.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import ZRBase

/// Network 组件命名空间协议
public protocol NetworkNameSpaceWrappable {
    
    /// type
    associatedtype NetworkWrapperType
    
    /// 空间命名
    var nk: NetworkWrapperType { get }
    
    /// 空间命名
    static var nk: NetworkWrapperType.Type { get }
}

/// 空间
public extension NetworkNameSpaceWrappable {
    
    var nk: NetworkNameSpaceWrapper<Self> {
        return NetworkNameSpaceWrapper(value: self)
    }
    
    static var nk: NetworkNameSpaceWrapper<Self>.Type {
        return NetworkNameSpaceWrapper.self
    }
}

// 命名空间中间层
public struct NetworkNameSpaceWrapper<T> {

    public var wrappedValue: T
    
    public init(value: T) {
        self.wrappedValue = value
    }
}


// MARK: - UIImage 图片资源
extension NSObject : NetworkNameSpaceWrappable { }
