//
//  UIViewController+NavBarItem.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/18.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

public enum CustomNavBarItemPosition{
    case left
    case right
}

/// 数据类型
@objc public protocol NavigationBarItemStyleProtocol {
    
    /// button 文字大小
    var textFont: UIFont? { get }
    
    /// 文字 颜色
    var textColor: UIColor? { get }
    
    /// 文字
    var text: String? { get }
    
    /// 返回按钮
    var image: UIImage? { get }
}

// MARK: - 导航条itmes
extension UIViewController {
    /// 便利
    public func customNavigationBarItem(title: String?, image: UIImage?, textColor: UIColor? = nil, textFont: UIFont? = nil, target: Any?, action: Selector ,position: CustomNavBarItemPosition = .right) {
        
        /// 内部函数
        func _itemElements<T>(_ obj: T?) -> [T]? {
            if let oj = obj {
                return [oj]
            }
            return nil
        }
        if let items = self.createNavigationBarItems(titles: _itemElements(title), textColors: _itemElements(textColor), textFonts: _itemElements(textFont), images: _itemElements(image), target: target, actions: [action], position: position) {
            self.customSetNavigationBarItems(items, position: position)
        }
    }
    
    
    /// 便利
    public func customNavigationBarItems(titles: [String]?, images: [UIImage]?, textColors: [UIColor]? = nil, textFonts: [UIFont]? = nil, target: Any?, actions:[Selector],position: CustomNavBarItemPosition = .right) {
        if let items = self.createNavigationBarItems(titles: titles, textColors: textColors, textFonts: textFonts, images: images, target: target, actions: actions, position: position) {
            self.customSetNavigationBarItems(items, position: position)
        }
    }
    
    
    /// 设置 BarButtonItems
    private func customSetNavigationBarItems(_ items: [UIBarButtonItem], position: CustomNavBarItemPosition) {
        var barItems = items
        let targetAction = spacerItemTargetActionFromItems(items, position: position)
        let spacerItem = UIBarButtonItem(spacerItem: targetAction.0, action: targetAction.1)
        barItems.insert(spacerItem, at: 0)
        if position == .left {
            self.navigationItem.leftBarButtonItems = barItems
        } else {
            self.navigationItem.rightBarButtonItems = barItems
        }
    }
    
    /// 创建
    private func createNavigationBarItems(titles: [String]?,textColors: [UIColor]?,textFonts: [UIFont]?,images: [UIImage]? ,target: Any?, actions:[Selector],position: CustomNavBarItemPosition) ->[UIBarButtonItem]? {
        /// 容错
        guard actions.count > 0 else { return nil}
        let titleCount = titles?.count ?? 0
        let imageCount = images?.count ?? 0
        
        if  actions.count != titleCount,actions.count != imageCount  {
            return nil
        }
        
        /// 内部函数
        func _barItemElement<T>(_ array: [T]?,_ index: Int) -> T? {
            if let ts = array, ts.count > index {
                return ts[index]
            }
            return nil
        }
        
        var items = [UIBarButtonItem]()
        
        /// 便利
        for index in 0..<actions.count {
            
            let title: String? = _barItemElement(titles, index)
            
            let image: UIImage? = _barItemElement(images, index)
            
            let tColor = _barItemElement(textColors, index) ?? .white
            
            let tFont = _barItemElement(textFonts, index) ?? self.navigationBarTheme.titleFont
            
            let action = actions[index]
            
            items.append(UIBarButtonItem(title: title, textColor: tColor, textFont: tFont, image: image, target: target, action: action, position: position))
        }
        
        return items
    }
    
    /// 从数组提起 target 和action
    fileprivate func spacerItemTargetActionFromItems(_ items: [UIBarButtonItem], position: CustomNavBarItemPosition) -> (Any?,Selector?) {
        let item = position == .left ? items.first : items.last
        return (item?.target,item?.action)
    }
}

// MARK: - bar button 便利初始化
extension UIBarButtonItem {
    
    convenience init (style: NavigationBarItemStyleProtocol, target: Any?, action:Selector, position: CustomNavBarItemPosition) {
        self.init(title: style.text,
                  textColor: style.textColor,
                  textFont: style.textFont,
                  image: style.image,
                  target: target,
                  action: action,
                  position: position)
    }
    
    
    convenience init (title: String?,textColor: UIColor?,textFont: UIFont?, image: UIImage? ,target: Any?, action: Selector, position: CustomNavBarItemPosition) {

        let button = UIButton(title: title, textColor: textColor, textFont: textFont, image: image,  state: .normal, target: target, action: action)
        
        var rect = CGRect(origin: .zero, size: CGSize(width: 30.0, height: 44.0))
        
        var width = rect.size.width
        
        /// 图片
        let  imageWidth: CGFloat = image?.ck.width ?? 0.0
        
        /// 文字宽度
        let textWidth: CGFloat = {

            if let t = title, let f = textFont {
                return t.base.size(f, CGSize(width: 1000.0, height: 44.0)).width
            }
            
            return 0.0
        }()
        
        /// 先赋值文字宽度
        width = textWidth != 0.0 ? textWidth : width
        
        /// 获取最大的
        width = max(width, imageWidth,textWidth)
        

        if title != nil, textFont != nil {
            UIBarButtonItem.setItemButtonEdgeInsets(button, maxW: width, width: textWidth, position: position)
        }
        
        if image != nil{
            UIBarButtonItem.setItemButtonEdgeInsets(button, maxW: width, width: imageWidth, position: position)
        }
        
        rect.size.width = width
        
        button.frame = rect
        
        self.init(customView:button)
    }
    
    /// 设置button 偏移
    private class func setItemButtonEdgeInsets(_ button: UIButton, maxW: CGFloat, width: CGFloat, position: CustomNavBarItemPosition) {
        var offset = max((maxW - width), 0.0)
        if position == .left {
            if #available(iOS 11.0, *) {
                offset += 8.0
            }
            button.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: -(offset), bottom: 0, right: 0)
        } else {
            
            if #available(iOS 11.0, *) {
                offset += 4.0
            }
            
            button.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0, right: -(offset))
        }
    }
}

