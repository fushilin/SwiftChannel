//
//  UIView+CoreKit.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit

// MARK: - get viewContoroller
extension CoreKitNameSpaceWrapper where T: UIView {
    
    /// 获取当前 Responder viewContoroller
    public var viewContoroller: UIViewController? {
        var next = wrappedValue.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is UIViewController) {
                return nextResponder as? UIViewController
            }
            next = next?.superview
        }
        return nil
    }
}


// MARK: - frame
extension UIView {
    
    /// left
    open var left: CGFloat {
        set {
            var frame = self.frame
            frame.left = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.left
        }
    }
    
    /// right
    open var right: CGFloat {
        set {
            var frame = self.frame
            frame.right = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.right
        }
    }
    
    /// top
    open var top: CGFloat {
        set {
            var frame = self.frame
            frame.top = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.top
        }
    }
    
    /// bottom
    open var bottom: CGFloat {
        set {
            var frame = self.frame
            frame.bottom = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.bottom
        }
    }
    
    /// width
    open var width: CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.width
        }
    }
    
    /// height
    open var height: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.height
        }
    }
    
    /// center X
    open var centerX: CGFloat {
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
        
        get {
            return self.center.x
        }
    }
    
    /// center y
    open var centerY: CGFloat {
        set {
            self.center = CGPoint(x:self.center.x , y: newValue)
        }
        
        get {
            return self.center.y
        }
    }
}
