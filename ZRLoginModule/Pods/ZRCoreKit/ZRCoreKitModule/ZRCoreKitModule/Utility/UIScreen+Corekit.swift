//
//  UIScreen+Corekit.swift
//  ZRCoreKitModule
//
//  Created by Zhuorui on 2019/8/19.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit


// MARK: - UIScreen 
extension CoreKitNameSpaceWrapper where T: UIScreen {
    
    /// mianSize
    public static var mainSize: CGSize  {
        return T.main.bounds.size
    }
    
    /// main width
    public static var mainWidth: CGFloat {
        return mainSize.width
    }
    
    /// main height
    public static var mainHeight: CGFloat {
        return mainSize.height
    }
}
