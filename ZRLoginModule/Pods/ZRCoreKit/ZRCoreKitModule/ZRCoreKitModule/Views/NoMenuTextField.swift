//
//  NoMenuTextField.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// 没有长按菜单，放大镜效果
open class NoMenuTextField: UITextField {
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    open override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if let long = gestureRecognizer as? UILongPressGestureRecognizer {
            long.isEnabled = false
        }
        super.addGestureRecognizer(gestureRecognizer)
    }
}
