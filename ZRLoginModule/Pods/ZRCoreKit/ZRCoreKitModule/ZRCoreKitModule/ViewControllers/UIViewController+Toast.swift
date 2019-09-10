//
//  UIViewController+Toast.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit
import ZRBase

extension UIViewController {
    
    /// show self.view
    open func toastShowOnView(_ message: String?, type: ToastStyleType = .none, completion: (()->Void)? = nil) {
        self.toastShowMessage(message, type: type, onView: self.view, completion: completion)
    }
    
    /// show self.window
    open func toastShowOnWindw(_ message: String?, type: ToastStyleType = .none, completion: (()->Void)? = nil) {
        if let window  = self.ck.keyWindow {
            self.toastShowMessage(message, type: type, onView: window, completion: completion)
        }
    }
    
    /// show
    private func toastShowMessage(_ message: String?, type: ToastStyleType, onView: UIView, completion: (()->Void)?) {
        DispatchQueue.base.mainExecuted {
            onView.makeToast(message,type: type, completion: completion)
        }
    }
}

