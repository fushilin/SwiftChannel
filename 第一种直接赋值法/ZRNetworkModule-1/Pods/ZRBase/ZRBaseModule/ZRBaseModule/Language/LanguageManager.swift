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
    return LanguageManager.default.getString(key: key, with: table)
}

/// 通知
public let LanguageChangedNotification: NSNotification.Name = NSNotification.Name("CXLanguageChangedNotification")
///
public let LanguageOldValue: String = "LanguageOldValue"
///
public let LanguageNewValue: String = "LanguageNewValue"

/// 语言管理器
public class LanguageManager: NSObject {
    
    /// 语言类型
    ///
    /// - English: 英语
    /// - Chinese: 简体中文
    /// - CN_Hongkong: 繁体中文-香港
    /// - CN_Taiwan: 繁体中文-台湾
    public enum Language:String {
        case none = "none"
        case English = "en"
        case Chinese = "zh-Hans"
        case CN_Hongkong = "zh-HK"
        case CN_Taiwan = "zh-hant"
    }
    
    
    /// 静态初始化
    public static let `default`: LanguageManager = LanguageManager(language: LocalTools.currentLanguage())
    
    /// 初始化
    public init(language: Language) {
        if language == .none {
            current = LanguageManager.localeCurrentLanguageType()
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
                
                var userInfo  = [String:Language]()
                userInfo[LanguageOldValue] = oldValue
                userInfo[LanguageNewValue] = current
                
                /// 发送通知
                NotificationCenter.default.post(name: LanguageChangedNotification, object: nil, userInfo: userInfo)
            }
        }
    }
    
    /// 上传服务器语言
    public var serverLanuage: String {
        switch current {
        case .Chinese:
            return "zh_CN"
            
        case .English :
            return "en_US"
        
        case .CN_Hongkong:
            return "zh_HK"
        
        case .CN_Taiwan:
            return "zh_TW"
            
        default:
            return ""
        }
        
    }
    
    /// 获取文字
    public func getString(key: String, with table: String?)-> String {
        if let bundle = bundleFormTable(table) {
            return bundle.localizedString(forKey: key, value: nil, table: table)
        } else {
            return Bundle.main.localizedString(forKey: key, value: nil, table: table)
        }
    }
}

/// 扩展
fileprivate extension LanguageManager {
    /// 获取本地语言
    class func localeCurrentLanguageType()-> Language {
        
        var lang: Language = .English
        
        if let localeLanguage = Locale.preferredLanguages.first {
            let langString = localeLanguage.replacingOccurrences(of: "-", with: "_").lowercased()
            
            /// yingyu
            if langString.hasPrefix("en") {
                lang = .English
                
                /// zhongwen
            } else if langString.contains("zh_hans") || langString.contains("hans_us") || langString.contains("hans_cn") {
                lang = .Chinese
            } else if langString.contains("zh_hant") {
                
                /// taiwan
                if langString.contains("tw") {
                    lang = .CN_Taiwan
                } else {
                    lang = .CN_Hongkong
                }
                
                /// 中国台湾
                if langString.contains("zh_tw") {
                    lang = .CN_Taiwan
                }
                
                if langString.contains("zh_hk") || langString.contains("zh_mo") {
                    lang = .CN_Hongkong
                }
            }
            
        }
        return lang
    }
    
    /// bundle获取语言
    func bundleFormTable(_ table: String?)-> Bundle? {
        let bundleKey = current.rawValue
        var resourceBundle: Bundle?
        if let resourceBundleURL = Bundle.main.url(forResource: table, withExtension: "bundle") {
            resourceBundle = Bundle(url: resourceBundleURL)
        }
        resourceBundle = resourceBundle ?? Bundle.main
        let path = resourceBundle?.path(forResource: bundleKey, ofType: "lproj")
        return Bundle(path: path ?? "")
    }
}


/// 分类存储
fileprivate extension LocalTools {
    static let languageKey = "36b85419643f14cb618987778e3235b1"
    
    /// 获取
    class func currentLanguage()->LanguageManager.Language {
        let userDefaults = UserDefaults.standard
        let value = userDefaults.value(forKey: languageKey)
        if let string =  value as? String, let lang = LanguageManager.Language(rawValue: string) {
            return lang
        }
        return .none
    }
    
    /// 保存
    @discardableResult class func saveCurrentLanguage(_ lang: LanguageManager.Language)-> Bool{
        let userDefaults = UserDefaults.standard
        userDefaults.set(lang.rawValue, forKey: languageKey)
        return userDefaults.synchronize()
    }
}
