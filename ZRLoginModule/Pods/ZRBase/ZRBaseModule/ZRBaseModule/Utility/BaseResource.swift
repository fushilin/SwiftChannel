//
//  BaseResource.swift
//  DYBaseModule
//
//  Created by lam on 2019/7/10.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// bundle name
private let baseBundleName = "Base"

/// base资源bundle
public struct BaseResource: ResourceType {
    public static var bundleName: String {
        return baseBundleName
    }
}

/// 当前模块的bundle
extension BaseNameSpaceWrapper where T == Bundle {
    public static var resource: T {
        return Bundle.resourceBundle(BaseResource.self)
    }
}

/// 图片资源
extension BaseNameSpaceWrapper where T : UIImage {
    /// base 组件图片资源
    public static func resourceImage(_ name: String)-> UIImage? {
        return UIImage(named: name, in: Bundle.base.resource, compatibleWith: nil)
    }
}

/// base模块国际化字符
public func kBaseLoc(_ key: String) -> String {
    return LocalizedString(key, baseBundleName)
}


