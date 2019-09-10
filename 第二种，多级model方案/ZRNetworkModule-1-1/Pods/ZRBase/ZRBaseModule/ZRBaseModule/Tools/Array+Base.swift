//
//  Array+Base.swift
//  ZRBaseModule
//
//  Created by Zhuorui on 2019/7/23.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
/// 增加扩展
extension Array where Element: Equatable {
    /// moreve objcet
    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}

