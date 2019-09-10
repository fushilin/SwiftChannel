//
//  CGRect+Corekit.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/18.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit



// MARK: - CGRect便利方法
extension CoreKitNameSpaceWrapper where T == CGRect {
}

extension CGRect {
    /// x
    public var x: CGFloat {
        set {
            self.origin.x = newValue
        }
        get {
            return self.origin.x
        }
    }
    
    /// y
    public var y: CGFloat {
        set {
            self.origin.y = newValue
        }
        get {
            return self.origin.y
        }
    }
    
    /// left
    public var left: CGFloat {
        set {
            self.origin.x = newValue
        }
        get {
            return self.x
        }
    }
    
    /// right
    public var right: CGFloat {
        set {
            self.origin.x = newValue - self.width
        }
        get {
            return self.x + self.width
        }
    }
    
    /// top
    public var top: CGFloat {
        set {
            self.origin.y = newValue
        }
        get {
            return self.y
        }
    }
    
    /// bottom
    public var bottom: CGFloat {
        set {
            self.origin.y = newValue - self.height
        }
        get {
            return self.y + self.height
        }
    }
}
