//
//  DispatchQueue+Base.swift
//  ZRBaseModule
//
//  Created by Zhuorui on 2019/7/23.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
/// 自定义工具类
extension DispatchQueue {
    
    /// 强制在main函数执行
    open class func mainExecuted(_ executed :@escaping ()->()) {
        if Thread.current.isMainThread {
            executed()
        } else {
            self.main.async {
                executed()
            }
        }
    }
    
    private static var _onceTracker = [String]()
    
    open class func once(_ token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
