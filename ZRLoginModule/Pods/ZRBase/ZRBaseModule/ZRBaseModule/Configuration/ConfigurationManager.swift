//
//  ConfigurationManager.swift
//  CandleStickChart_Swift_Demo
//
//  Created by lam on 2019/7/8.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import XCGLogger

// Log
public let Log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)

/// 当前环境配置
///
/// - DEV: 开发环境
/// - TEST: 测试环境
/// - RELEASE: 生成环境
public enum AppEnvironments {
    case DEV
    case TEST
    case RELEASE
}

/// 全局管理器
public let configurationM = ConfigurationManager.default

/// 配置管理器,可以环境配置,其他可以做扩展
public class ConfigurationManager {
    /// 静态初始化
    public static let `default`: ConfigurationManager = ConfigurationManager()
    
    /// 当前环境
    public var current:AppEnvironments = .DEV
    
    /// 初始化
    init() {
        congfigLog()
    }
    
    fileprivate func congfigLog() {
        
        //控制台输出
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
        
        //设置控制台输出的各个配置项
        systemDestination.outputLevel = .debug
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = true
        systemDestination.showLevel = true
        systemDestination.showFileName = true
        systemDestination.showLineNumber = true
        systemDestination.showDate = true
        
        Log.add(destination: systemDestination)
        
        //日志文件地址
        let cachePath = FileManager.default.urls(for: .cachesDirectory,
                                                 in: .userDomainMask)[0]
        let logURL = cachePath.appendingPathComponent("log.txt")
        //文件出输出
        let fileDestination = FileDestination(writeToFile: logURL,
                                              identifier: "advancedLogger.fileDestination",
                                              shouldAppend: true, appendMarker: "-- Relauched App --")
        
        //设置各个配置项
        fileDestination.outputLevel = .warning
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = true
        fileDestination.showThreadName = true
        fileDestination.showLevel = true
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true
        
        // 文件输出在后台处理
        fileDestination.logQueue = XCGLogger.logQueue
        
        //logger对象中添加控制台输出
        Log.add(destination: fileDestination)
        
        
        /// 输出类型
        #if DEBUG
        Log.setup(level: .debug, showThreadName: true, showLevel: true,
                  showFileNames: true, showLineNumbers: true)
        #else
        Log.setup(level: .severe, showThreadName: true, showLevel: true,
                  showFileNames: true, showLineNumbers: true)
        #endif
        
        //开始启用
        Log.logAppDetails()
    }
}
