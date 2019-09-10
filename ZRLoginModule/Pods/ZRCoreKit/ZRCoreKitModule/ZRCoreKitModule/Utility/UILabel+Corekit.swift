//
//  UILabel+Corekit.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors


// MARK: - label 工具 扩展
extension UILabel {
    /// 快速初始化
    public convenience init(_ text: String?,
                            textColor: UIColor?,
                            font: UIFont,
                            textAlignment: NSTextAlignment = .left,
                            numberOfLines: Int = 1,
                            lineBreakMode: NSLineBreakMode = .byTruncatingTail,
                            backgroundColor: UIColor? = .clear) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.lineBreakMode = lineBreakMode
        self.backgroundColor = backgroundColor
    }
}


// MARK: - label 设置行间
extension CoreKitNameSpaceWrapper where T: UILabel {
    
    /// 设置text切行间
    public func setTextWithLineSpacing(_ text: String?, spacing: CGFloat = 0) {
        
        wrappedValue.text = text
        
        if let t = text, spacing > 0.0 {
            
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: t)
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = spacing
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, t.count))
            wrappedValue.attributedText = attributedString
        }
    }
}
