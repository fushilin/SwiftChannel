//
//  LanguageManager.swift
//  CandleStickChart_Swift_Demo
//
//  Created by lam on 2019/7/8.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit


/// 公共方法获取国际化语言字符
public func LocalizedString(_ key: String,_ table:String? = nil) -> String {
    return languageM.getString(key: key, with: table)
}

/// 全局管理器
public let languageM = LanguageManager.default

/// 语言管理器
public class LanguageManager: NSObject {

    /// 语言类型
    ///
    /// - none: 无选择，读取设备语音环境
    /// - english: 英语
    /// - cn_simplified: 简体中文
    /// - cn_hk: 繁体中文-香港
    /// - cn_traditional: 繁体中文-台湾
    public enum Language: String {
        case none = "none"
        case english = "en"
        case cn_simplified = "zh-Hans"
        case cn_hk = "zh-HK"
        case cn_traditional = "zh-hant"
        
        
        //// 上传服务器key
        public var serverKey: String {
            switch self {
            case .cn_simplified:
                return "zh_CN"
                
            case .english :
                return "en_US"
                
            case .cn_hk:
                return "zh_HK"
                
            case .cn_traditional:
                return "zh_TW"
                
            default:
                return "en_US"
            }
        }
    }
    
    
    /// 静态初始化
    public static let `default`: LanguageManager = LanguageManager(language: LocalTools.currentLanguage())
    
    /// 初始化
    public init(language: Language) {
        if language == .none {
            current = LanguageManager.localLanguageType()
        } else {
            current = language
        }
        super.init()
    }
    
    /// 当前语言
    public var current: Language {
        didSet {
            if oldValue != current {
                /// 保存数据
                LocalTools.saveCurrentLanguage(current)
                
                var userInfo: [String : Language] = [:]
                userInfo[LanguageManager.oldValueKey] = oldValue
                userInfo[LanguageManager.newValuekey] = current
                
                /// 发送通知
                NotificationCenter.default.post(name: LanguageManager.didChangedNotification,
                                                object: nil,
                                                userInfo: userInfo)
            }
        }
    }
    
    /// 上传服务器语言
    public var serverLanuage: String {
        return current.serverKey
    }
    
    /// 获取文字
    public func getString(key: String, with table: String?)-> String {
        return bundleFormTable(table).localizedString(forKey: key, value: nil, table: table)
    }
}

/// 扩展
extension LanguageManager {
    /// 获取本地语言
    private class func localLanguageType() -> Language {
        /// 默认
        var lang: Language = .english
        
        guard let localeLanguage = Locale.preferredLanguages.first else { return lang }
        
        let langString = localeLanguage.replacingOccurrences(of: "-", with: "_").lowercased()
        
        /// yingyu
        if langString.hasPrefix("en") {
            lang = .english
            
            /// zhongwen
        } else if langString.contains("zh_hans") || langString.contains("hans_us") || langString.contains("hans_cn") {
            lang = .cn_simplified
        } else if langString.contains("zh_hant") {
            
            /// taiwan
            if langString.contains("tw") {
                lang = .cn_traditional
            } else {
                lang = .cn_hk
            }
            
            /// 中国台湾
            if langString.contains("zh_tw") {
                lang = .cn_traditional
            }
            
            if langString.contains("zh_hk") || langString.contains("zh_mo") {
                lang = .cn_hk
            }
        }
        
        return lang
    }
    
    /// bundle获取语言
    private func bundleFormTable(_ table: String?) -> Bundle {
        
        let bundleKey = current.rawValue
        
        guard let url = Bundle.main.url(forResource: table, withExtension: "bundle") else { return .main }
        
        guard let resourceBundle = Bundle(url: url) else { return .main }
        
        guard let path = resourceBundle.path(forResource: bundleKey, ofType: "lproj") else { return .main }
        
        return Bundle(path: path) ?? .main
    }
}


// MARK: - Notification
extension LanguageManager {
    
    /// did changed language notification
    public static let didChangedNotification: NSNotification.Name = NSNotification.Name("LanguageChangedNotification")
    
    /// userinfo old value key
    public static let oldValueKey: String = "LanguageOldValue"
    
    /// user info new value key
    public static let newValuekey: String = "LanguageNewValue"
}



/// 分类存储
extension LocalTools {
    
    static let languageKey = "36b85419643f14cb618987778e3235b1"
    
    /// 获取
    fileprivate class func currentLanguage() -> LanguageManager.Language {
        let userDefaults = UserDefaults.standard
        let value = userDefaults.value(forKey: languageKey)
        guard let string = value as? String else { return .none }
        return LanguageManager.Language(rawValue: string) ?? .none
    }
    
    /// 保存
    @discardableResult
    fileprivate class func saveCurrentLanguage(_ lang: LanguageManager.Language)-> Bool{
        let userDefaults = UserDefaults.standard
        userDefaults.set(lang.rawValue, forKey: languageKey)
        return userDefaults.synchronize()
    }
}

