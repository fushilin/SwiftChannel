//
//  DispatchQueue+Base.swift
//  ZRBaseModule
//
//  Created by Zhuorui on 2019/7/23.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation

extension BaseNameSpaceWrapper where T : DispatchQueue {
    /// 强制在main函数执行
    public static func mainExecuted(_ executed :@escaping ()->()) {
        if Thread.current.isMainThread {
            executed()
        } else {
            T.main.async {
                executed()
            }
        }
    }
}
