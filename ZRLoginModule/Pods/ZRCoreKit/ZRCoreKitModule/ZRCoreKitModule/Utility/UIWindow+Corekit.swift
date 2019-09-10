//
//  UIWindow+Corekit.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit

extension CoreKitNameSpaceWrapper where T : UIWindow {
     public static func getKeyWindow() -> UIWindow? {
        var window = UIApplication.shared.keyWindow
        if window == nil {
            window = UIApplication.shared.windows.first
        }
        return window
    }
}
