//
//  UITableViewCell+CoreKit.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

// MARK: - cell 扩展
extension CoreKitNameSpaceWrapper where T: UITableViewCell {
    
    /// 获取id
    public static var cellIdentifier: String {
        return "cellIdentifier_" + NSStringFromClass(T.classForCoder())
    }
}
