//
//  LoginServerView.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/21.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit

/// 富文本 服务协议，隐私协议
extension UITextView {
    
    public convenience init(label: String){
        self.init()
        
        ///1: 基本信息
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.scrollsToTop = false
        self.isSelectable = true
        self.isEditable = false
        self.backgroundColor = UIColor.init(hex: 0xf0f0f0)
        self.textAlignment = NSTextAlignment.center
        self.delegate = self
        
        /// 不可识别
        self.dataDetectorTypes = .all
     
        let serveText = LoginLoc("服务协议")
        let secText = LoginLoc("隐私协议")
        let contentStr =  label as NSString
        let range1 = contentStr.range(of: serveText)
        let range3 = contentStr.range(of: secText)
        
        /// 2.初始化富文本
        let nameStr : NSMutableAttributedString = NSMutableAttributedString(string:contentStr as String)
        
        /// 3.添加样式 (行间距和对其方式)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .left
        nameStr.addAttribute(NSAttributedString.Key.strokeColor, value: paragraphStyle, range: NSMakeRange(0, contentStr.length))

        ///4:设置点击链接
        nameStr.addAttribute(NSAttributedString.Key.link, value: "first://", range: range1)
        nameStr.addAttribute(NSAttributedString.Key.link, value: "second://", range: range3)
        
        //5：设置成功
        self.attributedText = nameStr
        self.font = UIFont.systemFont(ofSize: 11)
    }
    
}

extension UITextView:UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "first" {
            print("点击111111")
            self.ck.viewContoroller?.push(of: LoginModuleType.serveAndPrivacy)
            return false
        }
        if URL.scheme == "second" {
            print("点击222222")
             self.ck.viewContoroller?.push(of: LoginModuleType.serveAndPrivacy)
            return false
        }
        return true
    }
}
