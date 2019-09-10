//
//  BaseViewController.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/17.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import ZRBase

/// 基础 VC
open class BaseViewController: UIViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        if #available(iOS 11.0, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        /// 渲染
        customNavigationBar()
        
        /// 注册通知
        registerBaseNotifications()
    }
    
    /// 子类继承或者重写
    open func languageDidChanged(_ old: LanguageManager.Language, _ new: LanguageManager.Language) {
        
    }
    
    /// 删除
    deinit {
        NotificationCenter.default.removeObserver(self)
        Log.debug("💦deinit:<\(NSStringFromClass(self.classForCoder))>💦")
    }
}


// MARK: - 生命周期
extension BaseViewController {
    
    /// 已经出现
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// 重置动画
        if let submit = self.submitView {
            submit.start()
        }
        
        /// loading
        if let loading = self.loadingView {
            loading.start()
        }
    }
    
    /// 准备出现
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// 准备消失
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    /// 已经消失
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    /// 内存警告
    open override func didReceiveMemoryWarning() {
        Log.debug("💦didReceiveMemoryWarning:<\(NSStringFromClass(self.classForCoder))>💦")
    }
}



// MARK: - 导航
extension BaseViewController {
    
}



// MARK: - 状态栏
extension BaseViewController {
    /// 状态栏
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


// MARK: - 传参
extension BaseViewController {
    open override func routerReceiveParameter(url: String, parameter: [String : Any]?) {
        Log.debug("url:\(url), parameter:\(parameter ?? [:])")
    }
}


// MARK: - 注册一直基础的通知
extension BaseViewController {
    
    /// 基础通知
    open var baseNotifications: [(Notification.Name,Selector)] {
        return [
            (LanguageManager.didChangedNotification, #selector(languageDidChangedNotification(_:)))
        ]
    }
    
    /// 注册通知
    @objc open func registerBaseNotifications() {
        /// 遍历
        for (name, selector) in self.baseNotifications {
            NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
        }
    }
    
    /// 语言
    @objc private func languageDidChangedNotification(_ notif: Notification) {
        guard let userInfo = notif.userInfo as? [String : LanguageManager.Language] else { return }
        guard let old = userInfo[LanguageManager.oldValueKey] else { return }
        guard let new = userInfo[LanguageManager.newValuekey] else { return }
        languageDidChanged(old, new)
    }
}

