//
//  AppInformation.swift
//  ZRBaseModule
//
//  Created by Zhuorui on 2019/8/19.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// 全局常量
public let appInfo = AppInformation.shared

/// App信息,常量信息配置
public class AppInformation: NSObject {
    
    /// 静态初始化
    public static let shared: AppInformation = AppInformation()
    
    /// 默认动画时间
    public let animationDuration: TimeInterval = 0.25
    
    /// 后台时长
    public let foregroundDuration: TimeInterval = 1800.0
    
    /// app info
    public var info: [String: Any] {
        return Bundle.main.infoDictionary ?? [:]
    }
    
    /// app verion
    public var verion: String {
        return info["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /// build
    public var build: String {
        return info["CFBundleVersion"] as? String ?? ""
    }
    
    /// DisplayName
    public var displayName: String {
        return info["CFBundleDisplayName"] as? String ?? ""
    }
    
    /// bundleIdentifier
    public var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
}
