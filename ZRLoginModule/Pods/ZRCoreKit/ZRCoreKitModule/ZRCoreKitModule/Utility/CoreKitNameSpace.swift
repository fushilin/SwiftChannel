//
//  CoreKitNameSpace.swift
//  ZRCoreKitModule
//
//  Created by Zhuorui on 2019/8/7.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit

/// CoreKit组件命名空间协议
public protocol CoreKitNameSpaceWrappable {
    
    associatedtype CoreKitWrapperType
    
    var ck: CoreKitWrapperType { get }
    
    static var ck: CoreKitWrapperType.Type { get }
}

/// 空间
public extension CoreKitNameSpaceWrappable {
    
    var ck: CoreKitNameSpaceWrapper<Self> {
        return CoreKitNameSpaceWrapper(value: self)
    }
    
    static var ck: CoreKitNameSpaceWrapper<Self>.Type {
        return CoreKitNameSpaceWrapper.self
    }
}

// 使用
public struct CoreKitNameSpaceWrapper<T> {
    
    public var wrappedValue: T
    
    public init(value: T) {
        self.wrappedValue = value
    }
}

/// 增加, 父类遵守了,子类就不需要遵守了
extension NSObject: CoreKitNameSpaceWrappable { }

/// 结构体
extension CGRect: CoreKitNameSpaceWrappable { }

