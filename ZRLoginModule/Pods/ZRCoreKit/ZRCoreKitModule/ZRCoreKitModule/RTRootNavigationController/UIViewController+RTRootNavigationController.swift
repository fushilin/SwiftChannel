//
//  UIViewController+RTRootNavigationController.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/16.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit

public protocol RTNavigationItemCustomizable {
    
    
    /// Override this method to provide a custom back bar item, default is a normal @c UIBarButtonItem with title @b "Back"
    ///
    /// - Parameters:
    ///   - target: the action target
    ///   - action: the pop back action
    /// - Returns: a custom UIBarButtonItem
    func rt_customBackItems()-> [UIBarButtonItem]?
}



public var disableInteractivePopKey: String = "disableInteractivePop"

extension UIViewController {
    
    /// set this property to @b YES to disable interactive pop
    @objc public var rt_disableInteractivePop: Bool {
        set {
            objc_setAssociatedObject(self, &disableInteractivePopKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }

        get{
            return (objc_getAssociatedObject(self, &disableInteractivePopKey) as? Bool) ?? false
        }
    }
    
    
    /// self\.navigationControlle will get a wrapping @c UINavigationController, use this property to get the real navigation controller
    public var rt_navigationController: RTRootNavigationController? {
        var rt: UIViewController? = self
        
        while let vc = rt, !(vc is RTRootNavigationController) {
            rt = vc.navigationController
        }
        return rt as? RTRootNavigationController
    }
    
    
    /// Override this method to provide a custom subclass of @c UINavigationBar, defaults return nil
    ///
    /// - Returns: new UINavigationBar class
    open func rt_navigationBarClass() -> UINavigationBar.Type? {
        return nil
    }
    
    
    public var rt_NnvigationViewControllers: [UIViewController]? {
        return self.navigationController?.rt_Controllers
    }
}

extension UINavigationController {
    public var rt_Controllers : [UIViewController] {
        if let rt  = self as? RTRootNavigationController {
            return rt.rt_viewControllers
        }
        
        if let rt =  self.rt_navigationController {
            return rt.rt_viewControllers
        }
        
        return self.viewControllers
    }
}



