//
//  SwiftyMediatorType.swift
//  DYBaseModule
//
//  Created by lam on 2019/7/11.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// 获取vc协议
public protocol SwiftyMediatorType {
    /// 获取vc
    func viewController(of target: MediatorTargetType) -> UIViewController?
}

