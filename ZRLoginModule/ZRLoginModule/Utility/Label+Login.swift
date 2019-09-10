//
//  ZRLabel.swift
//  ZRNetworkModule
//
//  Created by 1230 on 2019/8/9.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit


/// Label 扩展
public extension UILabel {
    /// 便利初始化器创建
    convenience init(frame: CGRect,  text: String, textAlignment: NSTextAlignment , textFont: CGFloat) {
        self.init()
        self.frame = frame
        self.text = text
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: textFont)
  
    }
    
    convenience init(frame: CGRect,  text: String ,textColor: UIColor , textAlignment: NSTextAlignment , textFont: CGFloat) {
        self.init()
        self.frame = frame
        self.text = text
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: textFont)
        self.textColor = textColor
    }
    
    /// 获取文字的宽度
   static func getTextRectSize(text:NSString,font:UIFont,size:CGSize) -> CGRect {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        
        return rect;
    }
    
}
