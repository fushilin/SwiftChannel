//
//  NetworkResource.swift
//  DYNetworkModule
//
//  Created by lam on 2019/7/15.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import ZRBase

/// bundle name
private let networkBundleName = "Network"

// MARK: - Bundle
/// bundle
public struct NetworkResource : ResourceType {
    public static var bundleName: String = networkBundleName
}

/// 当前模块资源bundle
extension NetworkNameSpaceWrapper where T == Bundle {
    public static var resource: T {
        return Bundle.resourceBundle(NetworkResource.self)
    }
}

// MARK: - 图片资源
extension NetworkNameSpaceWrapper where T: UIImage {
    /// 获取当前模块组件图片资源
    public static func resourceImage(_ name: String)-> UIImage? {
        return UIImage(named: name, in: Bundle.nk.resource, compatibleWith: nil)
    }
}

// MARK: - 国际化字符
public func kNetworkLoc(_ key: String) -> String {
    return LocalizedString(key, networkBundleName)
}
