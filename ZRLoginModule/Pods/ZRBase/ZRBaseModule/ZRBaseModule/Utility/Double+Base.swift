//
//  Double+Base.swift
//  ZRBaseModule
//
//  Created by Zhuorui on 2019/7/26.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation

extension BaseNameSpaceWrapper where T == Double {
    
    /// timeInterval 转成秒级
    public var secondLevel: TimeInterval {
        var timeInterval = wrappedValue
        /// 毫秒级以上
        if timeInterval > 1000000000000.0 {
            /// 微妙
            if timeInterval >  1000000000000000.0{
                timeInterval = timeInterval / 1000000.0
            } else {
                timeInterval = timeInterval / 1000.0
            }
        }
        return timeInterval
    }
}
