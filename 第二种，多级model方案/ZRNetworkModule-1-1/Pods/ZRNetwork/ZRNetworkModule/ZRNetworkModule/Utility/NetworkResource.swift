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
fileprivate let networkBundleName = "Network"


// MARK: - Bundle
/// bundle
internal struct NetworkResource : ResourceType {
    var bundleName: String {
        return networkBundleName
    }
}

// MARK: - UIImage

/// 图片资源
internal extension UIImage {
     class func networkResourceImage(_ name: String)-> UIImage? {
        return self.resourceImage(name, NetworkResource())
    }
}


// MARK: - 国际化 过问
public func NetworkLoc(_ key: String) -> String {
    return LocalizedString(key, networkBundleName)
}
