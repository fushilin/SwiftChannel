//
//  VerificationTel.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/19.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit
import Foundation

/// 验证电话号码,判定区号信息,中国区11位 ， 判定标准
extension String {
    public func isOnePhone() -> Bool? {
        
        let pattern2 = "^1[0-9]{10}$"
        
        if NSPredicate(format: "SELF MATCHES %@", pattern2).evaluate(with: self) {
            return true
        }
        return false
    }
}

