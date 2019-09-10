//
//  LocalTools.swift
//  CandleStickChart_Swift_Demo
//
//  Created by lam on 2019/7/8.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit


/// 沙盒类型枚
///
/// - home: 根目录
/// - documents: documents目录
/// - library: library目录
/// - caches: caches目录
/// - tmp: tmp目录
public enum SandBoxType {
    case home
    case documents
    case library
    case caches
    case tmp
    
    /// 获取路径
    public func path()->String {
        switch self {
            
        case .home:
            return NSHomeDirectory()
            
        case .documents:
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
            
        case .library:
            return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last!
            
        case .caches:
            return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
            
        case .tmp:
            return NSTemporaryDirectory()
        }
    }
    
    /// 获取绝对路径
    public func filePath(_ fileName: String)->String {
        let path = self.path()
        return (path as NSString).appendingPathComponent(fileName)
    }
}


/// 本地文件管理工具<沙盒文件，NSUserDefaults,keychain>
public class LocalTools {

    /// 判断本地是否有文件,绝对路径
    public class func fileExistsAtPath(_ path: String)-> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    /// 删除文件
    public class func removeItemAtPath(_ path: String)-> Bool {
        do {
            try FileManager.default.removeItem(at: URL.init(string: path)!)
            return true
        } catch _ {
            return false
        }
    }
    
    /// 删除文件,先判断本地是否有文件
    public class func removeFileExistsAtPath(_ path: String)-> Bool {
        if fileExistsAtPath(path) {
            return removeFileExistsAtPath(path)
        }
        return false
    }
}


