//
//  SQLiteManger.swift
//  Swift信息
//
//  Created by 我演示 on 2019/10/15.
//  Copyright © 2019 Jerry-Fu. All rights reserved.
//

import UIKit


class SQLiteManger: NSObject {

    ///1: 创建类的实例变量
    static let instance = SQLiteManger()
    
    /// let 是线程安全的
    
    ///2: 对外提供单利的接口
    
    class func shareInstance() {
        
    }
 
    func openDB() -> Bool {
        ///1: 封装创建表sql语句
        
        ///2: 执行sql语句
        
        return true
    }
    
}
