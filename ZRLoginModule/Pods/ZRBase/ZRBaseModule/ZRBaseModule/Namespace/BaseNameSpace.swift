//
//  BaseNameSpace.swift
//  ZRBaseModule
//
//  Created by Zhuorui on 2019/8/7.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
/// base 组件命名空间 协议
public protocol BaseNameSpaceWrappable {
    
    associatedtype BaseWrapperType
    
    /// base组件命名空间
    var base: BaseWrapperType { get }
    
    /// base组件命名空间
    static var base: BaseWrapperType.Type { get }
}

/// 空间
public extension BaseNameSpaceWrappable {
    
    /// base组件命名空间
    var base: BaseNameSpaceWrapper<Self> {
        return BaseNameSpaceWrapper(value: self)
    }
    
    /// base组件命名空间
    static var base: BaseNameSpaceWrapper<Self>.Type {
        return BaseNameSpaceWrapper.self
    }
}

// 扩展
public struct BaseNameSpaceWrapper<T> {
    public var wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}

/// 增加, 父类遵守了,子类就不需要遵守了
extension NSObject: BaseNameSpaceWrappable { }

extension Date: BaseNameSpaceWrappable { }

extension Data: BaseNameSpaceWrappable { }

extension Array: BaseNameSpaceWrappable {}

extension String: BaseNameSpaceWrappable {}

/// 增命名空间
extension Double: BaseNameSpaceWrappable {}
