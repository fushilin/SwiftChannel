//
//  ModelNameSpace.swift
//  ZRModelModule
//
//  Created by Zhuorui on 2019/8/19.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation

/// Model组件命名空间协议
public protocol ModelNameSpaceWrappable {
    
    associatedtype ModelWrapperType
    
    /// model模块命名空间
    var ml: ModelWrapperType { get }
    
    /// model模块命名空间
    static var ml: ModelWrapperType.Type { get }
}

/// 空间
public extension ModelNameSpaceWrappable {
    
    /// model模块命名空间
    var ml: ModelNameSpaceWrapper<Self> {
        return ModelNameSpaceWrapper(value: self)
    }
    
    /// model模块命名空间
    static var ml: ModelNameSpaceWrapper<Self>.Type {
        return ModelNameSpaceWrapper.self
    }
}

// 使用
public struct ModelNameSpaceWrapper<T> {
    
    public var wrappedValue: T
    
    public init(value: T) {
        self.wrappedValue = value
    }
}

/// 增加, 父类遵守了,子类就不需要遵守了
extension NSObject: ModelNameSpaceWrappable { }
