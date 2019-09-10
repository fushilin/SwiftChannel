//
//  UITableView+Corekit.swift
//  ZRCoreKitModule
//
//  Created by Zhuorui on 2019/7/25.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

// MARK: - tableview 工具扩展
extension CoreKitNameSpaceWrapper where T: UITableView {
    
    /// 注册
    public func register(_ type: UITableViewCell.Type, identifier: String? = nil) {
        if let id = identifier, id.count > 0 {
            wrappedValue.register(type.classForCoder(), forCellReuseIdentifier: id)
        } else {
            wrappedValue.register(type.classForCoder(), forCellReuseIdentifier: type.ck.cellIdentifier)
        }
    }
}
