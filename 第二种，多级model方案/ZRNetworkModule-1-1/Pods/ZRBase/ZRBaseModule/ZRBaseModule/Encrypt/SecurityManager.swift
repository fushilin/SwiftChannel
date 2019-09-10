//
//  SecurityManager.swift
//  DYBaseModule
//
//  Created by lam on 2019/7/15.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import CryptoSwift


/// 加解密管理
public class SecurityManager {
    /// 加密的key
    private static let key = "CDC640C2D0024839"
    
    /// iv
    private static let iv = "ujhfwe9ihv0as89w"
    
    
    /// en
    public class func AES128EncryptedData(_ data: Data) -> Data? {
        guard let aes = try? AES(key: key.bytes,blockMode: CBC(iv: iv.bytes), padding: .pkcs7) else { return nil }
        
        guard let encrypted = try? aes.encrypt(data.bytes) else { return nil }
        
        return Data(encrypted).base64EncodedData()
    }
    
    /// de
    public class func AES128DecryptedData(_ data: Data)-> Data? {
        
        guard var base64Str = String(data: data, encoding: .utf8) else { return nil }
        
        base64Str =  base64Str.replacingOccurrences(of: "\"", with: "")
        
        guard let base64Data = Data(base64Encoded: base64Str, options: []) else {
            return nil
        }
        
        guard let aes = try? AES(key: key.bytes,blockMode: CBC(iv: iv.bytes), padding: .pkcs7) else { return nil }
        
        guard let decrypted = try? aes.decrypt(base64Data.bytes) else { return nil }
        
        return Data(decrypted)
    }
}
