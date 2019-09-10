//
//  ModelResource.swift
//  ZRModelModule
//
//  Created by Zhuorui on 2019/8/19.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import ZRBase

/// 资源管理
/// bundle name
private let modelBundleName = "Model"


// MARK: - Bundle
/// bundle
internal struct ModelResource : ResourceType {
    static var bundleName: String {
        return modelBundleName
    }
}

/// 图片资源
// MARK: - UIImage 图片资源
extension ModelNameSpaceWrapper where T: UIImage {
    internal static func resourceImage(_ name: String)-> UIImage? {
        return UIImage(named: name, in: Bundle.resourceBundle(ModelResource.self), compatibleWith: nil)
    }
}


// MARK: - 国际化 过问
internal func ModelLoc(_ key: String) -> String {
    return LocalizedString(key, modelBundleName)
}

/// 对外获取资源
extension ModelNameSpaceWrapper where T == Bundle {
    public static var resource: T {
        return Bundle.resourceBundle(ModelResource.self)
    }
}
