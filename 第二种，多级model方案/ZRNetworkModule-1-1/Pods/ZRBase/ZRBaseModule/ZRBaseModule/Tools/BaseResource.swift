//
//  BaseResource.swift
//  DYBaseModule
//
//  Created by lam on 2019/7/10.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// 协议
public protocol ResourceType {
    var bundleName: String {get}
}

/// 资源
public extension Bundle {
     class func resourceBundle<T: ResourceType>(_ type: T) -> Bundle {
        var bundle = self.main
        if let resourceBundleURL = self.main.url(forResource:type.bundleName , withExtension: "bundle") {
            bundle = Bundle(url: resourceBundleURL) ?? bundle
        }
        return bundle
    }
}

/// 获取图片
public extension UIImage {
    class func resourceImage<T: ResourceType>(_ name: String, _ type:T)-> UIImage? {
        return UIImage(named: name, in: Bundle.resourceBundle(type), compatibleWith: nil)
    }
}

/// base资源bundle
public struct BaseResource: ResourceType {
    public var bundleName: String {
        return "Base"
    }
}

/// 图片资源
extension UIImage {
    public class func baseResourceImage(_ name: String)-> UIImage? {
        return self.resourceImage(name, BaseResource())
    }
}
