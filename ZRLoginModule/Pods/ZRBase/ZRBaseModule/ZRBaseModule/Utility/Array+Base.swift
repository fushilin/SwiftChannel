//
//  Array+Base.swift
//  ZRBaseModule
//
//  Created by Zhuorui on 2019/7/23.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation

/// 增加扩展
extension BaseNameSpaceWrapper where T == Array<Any> {
    
}
extension Array where Element: Equatable {
    /// moreve objcet
    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            removeFirst(index)
        }
    }
    
    /// 安全获取数据
    subscript (safe index: Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
}
