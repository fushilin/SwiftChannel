//
//  NotificationCenter+Base.swift
//  ZRBaseModule
//
//  Created by Zhuorui on 2019/7/25.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation


// MARK: - NotificationCenter 工具分类
extension NotificationCenter {
    
    /// 主线程发送消息
    open func postOnMainThread(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        DispatchQueue.base.mainExecuted { [weak self] in
            self?.post(name: aName, object: anObject, userInfo: aUserInfo)
        }
    }
}

