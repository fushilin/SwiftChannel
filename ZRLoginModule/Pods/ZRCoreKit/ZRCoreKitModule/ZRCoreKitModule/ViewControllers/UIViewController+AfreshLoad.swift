//
//  UIViewController+AfreshLoad.swift
//  ZRCoreKitModule
//
//  Created by Zhuorui on 2019/7/22.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit

// MARK: - AfreshLoad
extension UIViewController {
    
    /// show
    public func showAfreshLoadView(text: String?) {
        view.showAfreshLoadView(text: text) { [weak self] in
            self?.afreshLoadAction()
        }
    }
    
    
    /// 清理view
    open func endAfreshLoadView() {
        view.removeAfreshLoadView()
    }
    
    /// 重试动作
    @objc open func afreshLoadAction() {
        
    }
}


