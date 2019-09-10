//
//  UIViewController+Corekit.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIViewController
extension CoreKitNameSpaceWrapper where T: UIViewController {
    
    /// get window
    public var keyWindow: UIWindow? {
        return UIWindow.ck.getKeyWindow()
    }
}
