//
//  Signer.swift
//  ZRNetworkModule
//
//  Created by lam on 2019/7/16.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import SwiftyRSA

/// 签名
public class Signer {
    /// 签名key
    static let signKey = "MIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAg8V2L+rhNAdcxt+LbYV4Y9lHDsLqJk7HEuyaAfRqRyZY7gYE6UbxgTHAmbs9PMLIsGyivKO3BLzyw6HzbMgKiwIDAQABAkA5fPyDC0YVHOEtInoB3ikX5sNJfWAKNnRDnVXTZH65ay9fh/1Hwhrc10tnHcj31TykODejvasSWHVXE7Ezq92BAiEA1fYk1SizxFSg2R60dlduagLAAVNrin9qI+xXxnE8MzcCIQCdqU8X1KLpR59MolcAAUfdzkscEzfBOKZCBg3KWx/1TQIhALYvjVVj/w5h8URvfMJ32DC0fsGiQqP/smU8TdFPgi8pAiByNR1YU+4XMozQxKBlHohiwndiRQGUdGbrWNtQhKYn2QIgUv3SsItetsk+J2Whn+dHOHbajPeF2DtZh76YLgtreNg="
    
    /// 签名
    public class func signed(_ dic:[String : Any])-> String {
        
        // 秘钥
        guard let privateKey = try? PrivateKey(base64Encoded: signKey) else { return "" }
        /// 升序json
        let json = self.jsonStringForOrder(dic)
        
        /// clear
        guard let clear = try? ClearMessage(string: json, using: .utf8) else { return "" }
        
        /// signature
        guard let signature = try? clear.signed(with: privateKey, digestType: .sha1) else { return "" }
        return signature.base64String
    }
    
    /// Json升序
    private class func jsonStringForOrder(_ dic: [String : Any])-> String {
        
        /// json类型不对
        if JSONSerialization.isValidJSONObject(dic) ==  false {
            return ""
        }
        
        if #available(iOS 11.0, *) {
            guard let data = try? JSONSerialization.data(withJSONObject: dic, options: [.sortedKeys])else { return "" }
            guard let jsonString = String(data: data, encoding: .utf8) else {return ""}
            return jsonString
            
        } else {
            var namedPaird = [String]()
            
            // 排序
            let sortedKeysAndValues = dic.sorted{$0.0 < $1.0}
            /// 提取元素
            for(key, value) in sortedKeysAndValues {
                
                /// 防止嵌套
                if value is [String:Any] {
                    namedPaird.append("\"\(key)\":\(self.jsonStringForOrder(value as! [String : Any]))")
                    /// 数组
                }else if value is [Any] {
                    namedPaird.append("\"\(key)\":\(value)")
                }else{
                    namedPaird.append("\"\(key)\":\"\(value)\"")
                }
            }
            let returnString = namedPaird.joined(separator:",")
            return"{\(returnString)}"
        }
    }
}
