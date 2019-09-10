//
//  CoreKitResource.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/17.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import ZRBase

/// bundle name
private let corekitBundleName = "CoreKit"

// MARK: - Bundle
/// bundle
public struct CoreKitResource: ResourceType {
    public static var bundleName: String {
        return corekitBundleName
    }
}

/// 当前模块的bundle
extension CoreKitNameSpaceWrapper where T == Bundle {
    public static var resource: T {
        return Bundle.resourceBundle(CoreKitResource.self)
    }
}

/// 图片资源
// MARK: - UIImage 图片资源
extension CoreKitNameSpaceWrapper where T: UIImage {
    public static func resourceImage(_ name: String)-> UIImage? {
        return UIImage(named: name, in: Bundle.ck.resource, compatibleWith: nil)
    }
}

// MARK: - 国际化字符
public func kCoreKitLoc(_ key: String) -> String {
    return LocalizedString(key, corekitBundleName)
}
