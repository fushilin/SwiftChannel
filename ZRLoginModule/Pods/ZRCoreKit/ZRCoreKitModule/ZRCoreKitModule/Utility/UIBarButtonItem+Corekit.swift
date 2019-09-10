//
//  UIBarButtonItem+Corekit.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/18.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit

/// 增加命名空间

// MARK: - UIBarButtonItem fixed space item
extension UIBarButtonItem {
    
    @objc open var navSpacerWidth: CGFloat {
        if #available(iOS 11.0, *) {
            return 0.0
        } else {
             return -8.0
        }
    }
    
    /// 间隔item
    public convenience init(spacerItem target:Any?, action:Selector?) {
        self.init(barButtonSystemItem: .fixedSpace, target: target, action: action)
        width = navSpacerWidth
    }
}
