//
//  UIViewController+LoadingView.swift
//  ZRCoreKitModule
//
//  Created by Zhuorui on 2019/7/22.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

private var loadingViewKey = "loadingViewKey"

// MARK: - loadingview
extension UIViewController {
    
    /// loadding view
    open var loadingView: LoadingView? {
        set {
            objc_setAssociatedObject(self, &loadingViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &loadingViewKey) as? LoadingView)
        }
    }
    
    /// 是否正在loading
    open var isLoading: Bool {
        return self.loadingView?.isAnimating ?? false
    }
    
    /// 开始loading
    open func startLoading() {
        self.startLoadingOnView(self.view)
    }
    
    /// 停止loading
    open func stopLoading() {
        DispatchQueue.base.mainExecuted {
            if let loading = self.loadingView {
                loading.stop()
                loading.removeFromSuperview()
                self.loadingView = nil
            }
        }
    }
    
    /// 再window上加载
    open func startLoadingOnWindow(_ text: String? = nil) {
        if let window = self.ck.keyWindow {
            self.startLoadingOnView(window,text: text)
        }
    }
    
    /// loading on view text = nil 默认
    private func startLoadingOnView(_ view: UIView, text: String? = nil) {
        DispatchQueue.base.mainExecuted {
            if self.loadingView == nil {
                let loading = LoadingView()
                
                if let t = text, t.count > 0 {
                    loading.text = t
                }
                
                /// 插入最上层
                view.insertSubview(loading, at: view.subviews.count)
                loading.frame = view.bounds
//                /// 约束
//                view.snp.makeConstraints({ (make) in
//                    make.edges.equalToSuperview()
//                })
                
                
                loading.start()
                
                self.loadingView = loading
            }
        }
    }
}
