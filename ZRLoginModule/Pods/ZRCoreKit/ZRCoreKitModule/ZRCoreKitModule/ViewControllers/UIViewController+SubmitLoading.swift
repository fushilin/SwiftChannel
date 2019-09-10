//
//  UIViewController+SubmitLoading.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

private var submitLoadingViewKey: String = "submitLoadingViewKey"

/// 提交 loading view
extension UIViewController {
    
    /// 数据
    open var submitView: SubmitLoadingView? {
        set {
            objc_setAssociatedObject(self, &submitLoadingViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &submitLoadingViewKey) as? SubmitLoadingView)
        }
    }
    
    /// 是否正在加载
    open var isSubmitLoading: Bool {
        return self.submitView?.isAnimating ?? false
    }
    
    /// 开始加载
    open func beginSubmitLoading() {
        self.beginSubmitLoadingOnView(onView: self.view)
    }
    
    /// 结束加载
    open func endSubmitLoading() {
        DispatchQueue.base.mainExecuted {
            if let submitView = self.submitView {
                submitView.removeFromSuperview()
                self.submitView = nil
            }
        }
    }
    
    /// 开始加载再window上
    open func beginSubmitLoadingOnWindow() {
        if let window  = self.ck.keyWindow {
            self.beginSubmitLoadingOnView(onView: window)
        }
    }
    
    private func beginSubmitLoadingOnView(onView: UIView) {
        DispatchQueue.base.mainExecuted {
            if self.submitView == nil {
                let submitView = SubmitLoadingView(addedTo: onView)
                self.submitView = submitView
            }
        }
    }
}
