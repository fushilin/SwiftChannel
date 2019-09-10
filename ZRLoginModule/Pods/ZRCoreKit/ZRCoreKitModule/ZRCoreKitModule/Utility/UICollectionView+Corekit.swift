//
//  UICollectionView+Corekit.swift
//  ZRCoreKitModule
//
//  Created by Zhuorui on 2019/7/29.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit


// MARK: - 功能扩展
extension CoreKitNameSpaceWrapper where T: UICollectionView {
    
    /// 注册 class
    public func registerClass(_ className: String, identifier: String? = nil) {
        if let id = identifier, id.count > 0 {
            wrappedValue.register(NSClassFromString(className).self, forCellWithReuseIdentifier: id)
        } else {
            wrappedValue.register(NSClassFromString(className).self, forCellWithReuseIdentifier: className)
        }
    }
    
    /// 注册 nib
    public func registerNib(_ nibName: String, identifier: String? = nil) {
        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        if let id = identifier, id.count > 0 {
            wrappedValue.register(nib, forCellWithReuseIdentifier: id)
        } else {
            wrappedValue.register(nib, forCellWithReuseIdentifier: nibName)
        }
    }
}
