//
//  UICollectionViewCell+Corekit.swift
//  ZRCoreKitModule
//
//  Created by Zhuorui on 2019/8/19.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

// MARK: - cell 扩展
extension CoreKitNameSpaceWrapper where T: UICollectionViewCell {
    
    /// 获取id
    public static var cellIdentifier: String {
        return "cellIdentifier_" + NSStringFromClass(T.classForCoder())
    }
}
