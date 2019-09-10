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
private var deviceUUID: String?
extension BaseNameSpaceWrapper where T: UIDevice {
    public static var UUID: String? {
        if deviceUUID == nil {
            if let uuid = LocalTools.UUIDForKeychain() {
                deviceUUID = uuid
            } else {
                let uuid = T.current.identifierForVendor?.uuidString
                LocalTools.keychainSaveUUID(uuid ?? "")
                deviceUUID = uuid
            }
        }
        return deviceUUID
    }
}

