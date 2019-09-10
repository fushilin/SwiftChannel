//
//  Bundle+Base.swift
//  ZRBaseModule
//
//  Created by Zhuorui on 2019/8/22.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation

// MARK: - 资源处理
/// 资源协议
public protocol ResourceType {
    static var bundleName: String { get }
}

extension Bundle {
    
    /// 获取对应模块的bundle
    public class func resourceBundle(_ type: ResourceType.Type) -> Bundle {
        let name = type.bundleName
        let ext = "bundle"
        guard let url = self.main.url(forResource:name , withExtension: ext) else { return .main }
        return Bundle(url: url) ?? .main
    }
}
