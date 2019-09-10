//
//  String+Base.swift
//  ZRBaseModule
//
//  Created by Zhuorui on 2019/7/23.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit


// MARK: - 时间
extension BaseNameSpaceWrapper where T == String {
    
    
    /// 默认到秒的时间格式
    public static let dateFormatterYMDHMS: String  = "yyyy-MM-dd HH:mm:ss"
    
    /// 默认到日的时间格式
    public static let dateFormatterYMD: String = "yyyy-MM-dd"
    
    /// 默认到消失的时间格式
    public static let dateFormatterYMDHM: String = "YYY-MM-DD HH:MM"
    
    ///  dateFormatter 从 date转时间string
    public func dateFormatterConvertString(from date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .short
        dateformatter.dateFormat = wrappedValue
        return dateformatter.string(from: date)
    }
    
    
    /// dateFormatter 从 timeInterval转时间string 1970时间
    public func dateFormatterConvertString(from timeInterval: TimeInterval) -> String {
        if timeInterval <= 0 {
            return ""
        }
        let date = Date(timeIntervalSince1970: timeInterval.base.secondLevel)
        return self.dateFormatterConvertString(from: date)
    }
    
    /// 时间string 转date
    func dateStringConvertDate(from dateFormatter: String) -> Date {
        let formatter = DateFormatter()
        let timeZone = NSTimeZone.local
        formatter.timeZone = timeZone
        formatter.dateFormat = dateFormatter
        let dateTime = formatter.date(from: wrappedValue) ?? Date()
        return dateTime
    }
    
    
}


// MARK: - string 计算区域
extension BaseNameSpaceWrapper where T == String {
    public func size(_ font : UIFont , _ maxSize : CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), _ lineMargin : CGFloat = 0.0) -> CGSize {
        let options: NSStringDrawingOptions = .usesLineFragmentOrigin
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineMargin
        var attributes : [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key.font] = font
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        let textBouds = wrappedValue.boundingRect(with: maxSize,
                                          options: options,
                                          attributes: attributes,
                                          context: nil)
        return textBouds.size
        
    }
}


// MARK: - 字符串截取
extension BaseNameSpaceWrapper where T == String {
    
    /// 字符串的第一个字符
    public var first: String {
        
        return self.substringTo(0)
    }
    
    /// 字符串的最后一个字符
    public var last: String {
        
        return self.substringFrom(wrappedValue.count - 1)
    }
    
    /// 字符串开始到第index
    ///
    /// - Parameter index: 结束索引
    /// - Returns: 子字符串
    public func substringTo(_ index: Int) -> String {
        
        guard index < wrappedValue.count else {
            assertionFailure("index beyound the length of the string")
            return ""
        }
        
        let theIndex = wrappedValue.index(wrappedValue.startIndex, offsetBy: index)
        
        return String(wrappedValue[wrappedValue.startIndex...theIndex])
    }
    
    /// 从第index个开始到结尾的字符
    ///
    /// - Parameter index: 开始索引
    /// - Returns: 子字符串
    public func substringFrom(_ index: Int) -> String {
        
        guard index < wrappedValue.count else {
            assertionFailure("index beyound the length of the string")
            return ""
        }
        
        guard index >= 0 else {
            assertionFailure("index can't be lower than 0")
            return ""
        }
        
        let theIndex = wrappedValue.index(wrappedValue.endIndex, offsetBy: index - wrappedValue.count)
        
        return String(wrappedValue[theIndex..<wrappedValue.endIndex])
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
        
        guard range.upperBound < wrappedValue.count else {
            assertionFailure("upperBound of the Range beyound the length of the string")
            return ""
        }
        let start = wrappedValue.index(wrappedValue.startIndex, offsetBy: range.lowerBound)
        let end = wrappedValue.index(wrappedValue.startIndex, offsetBy: range.upperBound + 1)
        
        return String(wrappedValue[start..<end])
    }
    
    /// 手机号字符串隐藏中间部分数字
    public mutating func hiddenTelphone() {
        
        if wrappedValue.count != 11 {
            return ;
        }
        
        let start = wrappedValue.index(wrappedValue.startIndex, offsetBy: 3)
        let end = wrappedValue.index(wrappedValue.endIndex, offsetBy: -4)
        
        let range = Range.init(uncheckedBounds: (lower: start, upper: end))
        
        wrappedValue.replaceSubrange(range, with: "****")
        //        self.replaceSubrange(3...6, with: "****")
    }
}



// MARK: - NSString属性
extension BaseNameSpaceWrapper where T == String {
    
    /// length
    public var length: Int {
        ///更改成其他的影响含有emoji协议的签名
        return wrappedValue.utf16.count
    }
    
    ///  doubleValue
    var doubleValue: Double {
        return (wrappedValue as NSString).doubleValue
    }
    
    ///  intValue
    var intValue: Int32 {
        return (wrappedValue as NSString).intValue
    }
    
    /// floatValue
    var floatValue: Float {
        return (wrappedValue as NSString).floatValue
    }
    
    /// integerValue
    var integerValue: Int {
        return (wrappedValue as NSString).integerValue
    }
    
    /// longLongValue
    var longLongValue: Int64 {
        return (wrappedValue as NSString).longLongValue
    }
    
    /// boolValue
    var boolValue: Bool {
        return (wrappedValue as NSString).boolValue
    }
}
