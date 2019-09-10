//
//  JerryAesSec.swift
//  moyo-ceshi-01
//
//  Created by 我演示 on 2019/7/9.
//  Copyright © 2019 世霖mac. All rights reserved.
//

import Foundation
import  CryptoSwift

///调用对应的方法

class JerryAesSec: NSObject {
    
    ///调用莫一种方法信息
    
    func AES128(nameDate: String) -> (String) {
        
        /**
         
         //            let ase = try AES(key: "1234567890123456", iv: "1234567890123456", padding: .pkcs5)
         //
         //            print(ase)
         //            let name = "hahahaha"
         //            let showAse = try ase.encrypt(Array(name.utf8))
         //
         //            print(showAse.toHexString())
         ////
         //////             再进行base64转码
         //            let showStringPrint = showAse.toBase64()
         //
         //            print(showStringPrint )
         //
         */
        
        
        var showStringPring: String? = ""
        do {
            let ase = try AES(key: "1234567890123456", iv: "1234567890123456", padding: .pkcs5)
            
            let name = nameDate
            
            let showAse = try ase.encrypt(Array(name.utf8))
            
            print(showAse.toHexString())
            
//            base64转码
            showStringPring =  showAse.toBase64()
            print( showStringPring )
//            r eturn  showStringPring!
            
            
        } catch  {
            print(error)
            
        }
        
        return showStringPring!
        
    }
    
}
