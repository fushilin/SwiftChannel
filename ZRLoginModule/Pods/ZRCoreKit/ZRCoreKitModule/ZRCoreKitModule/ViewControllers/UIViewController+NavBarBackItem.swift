//
//  UIViewController+NavBarBackItem.swift
//  ZRCoreKitModule
//
//  Created by Zhuorui on 2019/8/8.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit


// MARK: - NavigationBarBackItemCustomizable
@objc public protocol NavigationBarBackItemCustomizable {
    
    @objc var navigationBarBackItemTheme: NavigationBarItemStyleProtocol { get }
    
    /// 返回按钮方法
    @objc func customBackAation(_ sender: UIButton)
    
}

/// 因为协议继承重写，需要@objc 无法识别struct类型
public class NavigationBarBackItemStyle : NavigationBarItemStyleProtocol {
    
    /// button 文字大小
    public var textFont: UIFont? = UIFont.systemFont(ofSize: 16.0)
    
    /// 文字 颜色
    public var textColor: UIColor? = .white
    
    /// 文字
    public var text: String?  = nil
    
    /// 返回按钮
    public var image: UIImage? = UIImage.ck.resourceImage("ck_backup_w")
}

extension UIViewController : NavigationBarBackItemCustomizable {
    
    /// 返回按钮
    public var navigationBarBackItemTheme: NavigationBarItemStyleProtocol {
        return NavigationBarBackItemStyle()
    }
    
    /// 返回
    public func customBackAation(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 隐藏返回按钮
    public func hideBackButton() {
        //取消返回按钮
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = false
        
        if let rt = self.navigationController as? RTRootNavigationController {
            rt.useSystemBackBarButtonItem = false
        }
    }
    
    /// 显示返回按钮
    public func showBackButton() {
        self.navigationItem.leftBarButtonItems = self.rt_customBackItems()
    }
    
    /// 获取返回按钮
    fileprivate func backButton() -> UIBarButtonItem {
        let theme = navigationBarBackItemTheme
        return UIBarButtonItem(style: theme, target: self, action: #selector(customBackAation(_:)), position: .left)
    }
}


// MARK: - RTNavigationItemCustomizable
extension UIViewController: RTNavigationItemCustomizable {
    
    public func rt_customBackItems() -> [UIBarButtonItem]? {
        let backItem = self.backButton()
        let spacerItem = UIBarButtonItem(spacerItem: backItem.target, action: backItem.action)
        return [spacerItem,backItem]
    }
}
