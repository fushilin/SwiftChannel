//
//  UIButton+Corekit.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/18.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit

/// 增加命名空间
extension CoreKitNameSpaceWrapper where T: UIButton { }

// MARK: - 便利初始化
extension UIButton {
    /// 便捷初始化
    public convenience init(title: String?,textColor: UIColor?,textFont: UIFont?,image: UIImage? = nil,backgroundImage: UIImage? = nil,state: UIControl.State = .normal,target: Any?,action:Selector, event: UIControl.Event = .touchUpInside) {
        self.init(type:.custom)
        setTitle(title, for: state)
        setTitleColor(textColor, for: state)
        titleLabel?.font = textFont
        
        setImage(image, for: state)
        setBackgroundImage(backgroundImage, for: state)
        addTarget(target, action: action, for: event)
    }
}


// MARK: - set Button Image, text, text color for state
extension UIButton {
    private var states: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }
    
    /// Set image for all states.
    ///
    /// - Parameter image: UIImage.
    open func setImageForAllStates(_ image: UIImage) {
        states.forEach { self.setImage(image, for: $0) }
    }
    
    /// Set title color for all states.
    ///
    /// - Parameter color: UIColor.
    open func setTitleColorForAllStates(_ color: UIColor) {
        states.forEach { self.setTitleColor(color, for: $0) }
    }
    
    /// Set title for all states.
    ///
    /// - Parameter title: title string.
    open func setTitleForAllStates(_ title: String) {
        states.forEach { self.setTitle(title, for: $0) }
    }
    
    /// Center align title text and image on UIButton
    ///
    /// - Parameter spacing: spacing between UIButton title text and UIButton Image.
    open func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}


// MARK: - Get Button Image, text, text color for state
extension UIButton {
    /// Image of disabled state for button; also inspectable from Storyboard.
    @IBInspectable open var imageForDisabled: UIImage? {
        get {
            return image(for: .disabled)
        }
        set {
            setImage(newValue, for: .disabled)
        }
    }
    
    /// Image of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable open var imageForHighlighted: UIImage? {
        get {
            return image(for: .highlighted)
        }
        set {
            setImage(newValue, for: .highlighted)
        }
    }
    
    /// Image of normal state for button; also inspectable from Storyboard.
    @IBInspectable open var imageForNormal: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
    
    /// Image of selected state for button; also inspectable from Storyboard.
    @IBInspectable open var imageForSelected: UIImage? {
        get {
            return image(for: .selected)
        }
        set {
            setImage(newValue, for: .selected)
        }
    }
    
    /// Title color of disabled state for button; also inspectable from Storyboard.
    @IBInspectable open var titleColorForDisabled: UIColor? {
        get {
            return titleColor(for: .disabled)
        }
        set {
            setTitleColor(newValue, for: .disabled)
        }
    }
    
    /// Title color of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable open var titleColorForHighlighted: UIColor? {
        get {
            return titleColor(for: .highlighted)
        }
        set {
            setTitleColor(newValue, for: .highlighted)
        }
    }
    
    /// Title color of normal state for button; also inspectable from Storyboard.
    @IBInspectable open var titleColorForNormal: UIColor? {
        get {
            return titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }
    
    /// Title color of selected state for button; also inspectable from Storyboard.
    @IBInspectable open var titleColorForSelected: UIColor? {
        get {
            return titleColor(for: .selected)
        }
        set {
            setTitleColor(newValue, for: .selected)
        }
    }
    
    /// Title of disabled state for button; also inspectable from Storyboard.
    @IBInspectable open var titleForDisabled: String? {
        get {
            return title(for: .disabled)
        }
        set {
            setTitle(newValue, for: .disabled)
        }
    }
    
    /// Title of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable open var titleForHighlighted: String? {
        get {
            return title(for: .highlighted)
        }
        set {
            setTitle(newValue, for: .highlighted)
        }
    }
    
    /// Title of normal state for button; also inspectable from Storyboard.
    @IBInspectable open var titleForNormal: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    /// Title of selected state for button; also inspectable from Storyboard.
    @IBInspectable open var titleForSelected: String? {
        get {
            return title(for: .selected)
        }
        set {
            setTitle(newValue, for: .selected)
        }
    }
}
