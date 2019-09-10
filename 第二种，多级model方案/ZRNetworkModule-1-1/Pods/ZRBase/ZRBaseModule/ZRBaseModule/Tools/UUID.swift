//
//  UUID.swift
//  CandleStickChart_Swift_Demo
//
//  Created by lam on 2019/7/10.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import KeychainAccess

/// keychain uu id
private let kKeychainUUIDIdentifier = "com.dy.base.uuid"

// MARK: - keychain
extension LocalTools {
    fileprivate static var keychainService: String {
        if let info = Bundle.main.infoDictionary {
            if let name = info[String(kCFBundleIdentifierKey)] as? String {
                return name
            }
        }
        return ""
    }
    
    /// 保存uuid
    @discardableResult
    fileprivate class func keychainSaveUUID(_ UUID: String) -> Bool{
        let keychain = Keychain(service: self.keychainService)
        keychain[kKeychainUUIDIdentifier] = UUID
        _ = keychain.synchronizable(true)
        return true
    }
    
    /// 获取uuid
    @discardableResult
    fileprivate class func UUIDForKeychain() -> String? {
        let keychain = Keychain(service: self.keychainService)
        _ = keychain.synchronizable(true)
        return keychain[kKeychainUUIDIdentifier]
    }
}


///MARK: - UUID
extension UIDevice {
    public class var UUID: String? {
        
        /// 单例结构体
        struct DXUUIDSingleton {
            // 单例数据
            static var UUID: String?
        }
        
        if DXUUIDSingleton.UUID == nil {
            DispatchQueue.once("UUID.uuidString") {
                if let uuid = LocalTools.UUIDForKeychain() {
                     DXUUIDSingleton.UUID = uuid
                } else {
                    let uuid = self.current.identifierForVendor?.uuidString
                    LocalTools.keychainSaveUUID(uuid ?? "")
                    DXUUIDSingleton.UUID = uuid
                }
            }
        }
        return DXUUIDSingleton.UUID
    }
}

