//
//  Dictionary+Base.swift
//  ZRBaseModule
//
//  Created by Zhuorui on 2019/7/23.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation

// MARK: - Dictionary 扩展
extension Dictionary {
    /// 拼接
    public mutating func append(dict: Dictionary) {
        dict.forEach { (key, value) in
            self.updateValue(value, forKey: key)
        }
    }
}
