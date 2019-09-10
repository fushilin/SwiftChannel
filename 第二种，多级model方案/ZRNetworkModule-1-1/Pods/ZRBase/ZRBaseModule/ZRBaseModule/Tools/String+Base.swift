//
//  String+Base.swift
//  ZRBaseModule
//
//  Created by Zhuorui on 2019/7/23.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit


// MARK: - string 计算大校
extension String {
    public func sizeWith(_ font : UIFont , _ maxSize : CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), _ lineMargin : CGFloat = 0.0) -> CGSize {
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineMargin
        var attributes : [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key.font] = font
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        let textBouds = self.boundingRect(with: maxSize,
                                          options: options,
                                          attributes: attributes,
                                          context: nil)
        return textBouds.size
        
    }
}


// MARK: - 字符串截取
extension String {
    
    /// 字符串的第一个字符
    public var firstString: String {
        
        return self.substringTo(0)
    }
    
    /// 字符串的最后一个字符
    public var lastString: String {
        
        return self.substringFrom(self.count - 1)
    }
    
    /// 字符串开始到第index
    ///
    /// - Parameter index: 结束索引
    /// - Returns: 子字符串
    public func substringTo(_ index: Int) -> String {
        
        guard index < self.count else {
            assertionFailure("index beyound the length of the string")
            return ""
        }
        
        let theIndex = self.index(self.startIndex, offsetBy: index)
        
        return String(self[startIndex...theIndex])
    }
    
    /// 从第index个开始到结尾的字符
    ///
    /// - Parameter index: 开始索引
    /// - Returns: 子字符串
    public func substringFrom(_ index: Int) -> String {
        
        guard index < self.count else {
            assertionFailure("index beyound the length of the string")
            return ""
        }
        
        guard index >= 0 else {
            assertionFailure("index can't be lower than 0")
            return ""
        }
        
        let theIndex = self.index(self.endIndex, offsetBy: index - self.count)
        
        return String(self[theIndex..<endIndex])
    }
    
    /// 某个闭区间内的字符
    ///
    /// - Parameter range: 闭区间，例如：1...6
    /// - Returns: 子字符串
    public func substringInRange(_ range: CountableClosedRange<Int>) -> String {
        
        guard range.lowerBound >= 0 else {
            assertionFailure("lowerBound of the Range can't be lower than 0")
            return ""
        }
        
        guard range.upperBound < self.count else {
            assertionFailure("upperBound of the Range beyound the length of the string")
            return ""
        }
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound + 1)
        
        return String(self[start..<end])
    }
    
    /// 手机号字符串隐藏中间部分数字
    public mutating func hiddenTelphone() {
        
        if self.count != 11 {
            return ;
        }
        
        let start = self.index(self.startIndex, offsetBy: 3)
        let end = self.index(self.endIndex, offsetBy: -4)
        
        let range = Range.init(uncheckedBounds: (lower: start, upper: end))
        
        self.replaceSubrange(range, with: "****")
        //        self.replaceSubrange(3...6, with: "****")
    }
}



// MARK: - NSString属性
extension String {
    
    /// length
    public var length: Int {
        ///更改成其他的影响含有emoji协议的签名
        return self.utf16.count
    }
    
    ///  doubleValue
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    ///  intValue
    var intValue: Int32 {
        return (self as NSString).intValue
    }
    
    
    /// floatValue
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    /// integerValue
    var integerValue: Int {
        return (self as NSString).integerValue
    }
    
    /// longLongValue
    var longLongValue: Int64 {
        return (self as NSString).longLongValue
    }
    
    /// boolValue
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
}
