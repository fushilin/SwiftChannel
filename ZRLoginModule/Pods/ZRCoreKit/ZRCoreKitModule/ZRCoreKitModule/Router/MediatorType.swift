//
//  MediatorType.swift
//  DYBaseModule
//
//  Created by lam on 2019/7/11.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

public protocol MediatorTargetType {}


/// 数据协议
public protocol MediatorSourceType {
    var viewController: UIViewController? { get }
}
