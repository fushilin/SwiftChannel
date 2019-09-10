//
//  UIView+Toast.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import SwiftHEXColors

public enum ToastStyleType {
    /// 纯文字
    case none
    
    /// image+ text
    case image
}


/// toast样式
public struct ToastStyle {
    
    /// 是否阴影
    public var isShadow: Bool = false
    
    /// 阴影透明度
    public var shadowOpacity: Float = 0.95
    
    /// 阴影圆角
    public var shadowRadius: CGFloat = 3.0
    
    /// 阴影颜色
    public var shadowColor: UIColor? = .black
    
    /// 阴影偏移
    public var shadowOffset: CGSize = CGSize(width: 4.0, height: 4.0)
    
    /// 动画时间
    public var animateDuration: TimeInterval = 0.2
    
    /// 停留时间
    public var stayDuration: TimeInterval = 2.0
    
    /// 圆角
    public var cornerRadius: CGFloat = 5.0
    
    /// 背景颜色
    public var backgroundColor: UIColor? {
        switch type {
        case .image:
            return UIColor(hex: 0x0, alpha: 0.85)
        case .none:
            return UIColor(hex: 0x0, alpha: 0.65)
        }
    }
    
    ///  font
    public var font: UIFont = UIFont.systemFont(ofSize: 16.0)
    
    /// textcolor
    public var textColor: UIColor? = .white
    
    /// top botoom
    public var topBottomPadding: CGFloat {
        switch type {
        case .image:
            return 15.0
        case .none:
            return 11.0
        }
    }
    
    /// left right
    public var leftRightPadding: CGFloat {
        switch type {
        case .image:
            return 20.0
        case .none:
            return 18.0
        }
    }
    
    /// 文字和图片
    public var imageTextPadding: CGFloat = 9.0
    
    /// text alignment
    public var textAlignment: NSTextAlignment = .center
    
    /// cetner Y
    public var centerYScale: CGFloat = 0.41
    
    /// max width
    public var maxWidthScale: CGFloat = 0.8
    
    /// 样式
    public var type: ToastStyleType = .none
    
    init(type: ToastStyleType) {
        self.type = type
    }
    
}

/// tag index
private let tagIndex: Int = 0x1193f

// MARK: - Toast
extension UIView {

    open func makeToast(_ message: String? = "", type: ToastStyleType, completion: (()->Void)?) {
        
        let msg = message ?? ""
        
        let theme = ToastStyle(type: type)
        
        showToast(toastForMessage(msg, theme: theme), theme: theme, completion: completion)
    }
    
    /// show
    private func showToast(_ toast: UIView, theme: ToastStyle, completion: (()->Void)?) {
        
        /// 确保上一个被删除了
        if let last = viewWithTag(tagIndex) {
            last.alpha = 0
            last.removeFromSuperview()
        }
        
        toast.tag = tagIndex
        toast.center = toastCenter(theme: theme)
        toast.alpha = 0.0
        addSubview(toast)
        
        
        /// 显示
        let animateDuration = theme.animateDuration
        UIView.animate(withDuration: animateDuration, delay: 0.0, options:
            .curveEaseOut, animations: {
                toast.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: animateDuration, delay: theme.stayDuration, options: .curveEaseIn, animations: {
                toast.alpha = 0.0
            }, completion: { (finished) in
                toast.removeFromSuperview()
                completion?()
            })
        }
    }
    
    /// get center
    private func toastCenter(theme: ToastStyle) -> CGPoint {
        let x = bounds.width * 0.5;
        let y = bounds.height * theme.centerYScale
        return CGPoint(x: x, y: y)
    }
    
    /// 获取taost
    private func toastForMessage(_ message: String, theme: ToastStyle) -> UIView {
        
        /// 底部
        let wrapperView = UIView()
        wrapperView.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin]
        wrapperView.backgroundColor = theme.backgroundColor
        
        /// 阴影
        if (theme.isShadow) {
            wrapperView.layer.shadowColor = theme.shadowColor?.cgColor
            wrapperView.layer.shadowOpacity = theme.shadowOpacity
            wrapperView.layer.shadowRadius = theme.shadowRadius
            wrapperView.layer.shadowOffset = theme.shadowOffset
        }
        
        //计算文字高度
        let maxWidth: CGFloat = bounds.width * theme.maxWidthScale
        let maxMessageWidth = maxWidth - theme.leftRightPadding * 2.0
        let maxMessageHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let maxSizeMessage = CGSize(width: maxMessageWidth, height: maxMessageHeight)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let font = theme.font
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        let msgSize = message.boundingRect(with: maxSizeMessage, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        
        var imagsSize: CGSize = .zero
        var imageoffset: CGFloat = 0.0
        var imageView: UIImageView?
        
        /// Image
        if theme.type == .image {
            let image = UIImage.ck.resourceImage("ck_toast_succeed")
            imagsSize = image?.size ?? .zero
            let imageV = UIImageView(image: image)
            wrapperView.addSubview(imageV)
            imageView = imageV
            imageoffset  = imagsSize.height + theme.imageTextPadding
        }
        
        
        /// 计算bounds
        let wrapperWidth: CGFloat = min(max(msgSize.width, imagsSize.width) + theme.leftRightPadding * 2.0, maxWidth)
        let wrapperHeight: CGFloat = msgSize.height + imageoffset +  theme.topBottomPadding * 2.0
        
        /// image frame
        if let imageV = imageView {
            let x = (wrapperWidth - imagsSize.width) / 2.0
            let y = theme.topBottomPadding
            imageV.frame = CGRect(origin: CGPoint(x: x, y: y), size:imagsSize)
        }
        
        /// label
        let messageLabel = UILabel(message, textColor: .white, font: font, textAlignment: .center, numberOfLines: 0, lineBreakMode: .byWordWrapping)
        let messageY = wrapperHeight - msgSize.height - theme.topBottomPadding
        let messageX = (wrapperWidth - msgSize.width) / 2.0
        messageLabel.frame = CGRect(x: messageX, y: messageY, width: msgSize.width, height: msgSize.height)
        wrapperView.addSubview(messageLabel)
        
        
        /// 设置frame
        wrapperView.frame = CGRect(x: 0.0, y: 0.0, width: wrapperWidth, height: wrapperHeight)
        wrapperView.layer.cornerRadius = theme.cornerRadius
        wrapperView.layer.masksToBounds = true
        
        return wrapperView
    }
    
}


