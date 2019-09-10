//
//  UIViewController+NavBar.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/18.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors


/// 导航条样式协议
@objc public protocol NavigationBarStyleProtocol {
    
    /// 颜色
    var color: UIColor? { get }
    
    /// 图片
    var image: UIImage? { get }
    
    /// 线图片
    var lienImage: UIImage? { get }
    
    /// 是否透明
    var isTranslucent: Bool { get }
    
    /// 字体大小
    var titleFont: UIFont { get }
    
    /// 字体颜色
    var titleColor: UIColor { get }
}

/// 默认样式
public class NavigationBarStyle : NavigationBarStyleProtocol {
    
    public var color: UIColor? = UIColor(hex: 0x211F2A)!
    
    public var image: UIImage? = nil
    
    public var lienImage: UIImage? = nil
    
    public var isTranslucent: Bool =  false
    
    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 20.0)
    
    public var titleColor: UIColor = .white
}


/// 导航bar协议
@objc public protocol NavigationBarCustomizable {
    @objc var navigationBarTheme: NavigationBarStyleProtocol { get }
}


// MARK: - NavigationBarCustomizable
extension UIViewController : NavigationBarCustomizable {
    
    /// 数据协议
    open var navigationBarTheme: NavigationBarStyleProtocol {
        return NavigationBarStyle()
    }
    
    
    public func customNavigationBar() {
       drawNavigationBar(style: self.navigationBarTheme)
    }
    
    public func drawNavigationBar(style: NavigationBarStyleProtocol)  {
        if let navigationBar = self.navigationController?.navigationBar{
            /// 透明度
            navigationBar.isTranslucent = style.isTranslucent
            
            /// bar color
            navigationBar.barTintColor = style.color
            
            /// bar image
            navigationBar.setBackgroundImage(style.image ?? UIImage(), for: .default)
            
            /// line
            navigationBar.shadowImage = style.lienImage ?? UIImage()
            
            let attributes = [NSAttributedString.Key.font : style.titleFont, NSAttributedString.Key.foregroundColor: style.titleColor]
            
            navigationBar.titleTextAttributes = attributes
        }
    }
}


