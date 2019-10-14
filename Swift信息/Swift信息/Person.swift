//
//  Person.swift
//  Swift信息
//
//  Created by 我演示 on 2019/10/14.
//  Copyright © 2019 Jerry-Fu. All rights reserved.
//

import UIKit

class Person: NSObject {

    var name :String?
    var age : Int = 0
    var callBack:(() -> ())?
    
    /**返回值是可选类型的*/
    
    
    override init() {
         //可以写super 也可以不写
        super.init()
    }
    
    init(name: String ,age: Int) {
        self.name = name
        self.age = age
        
    }
    
    
    init(dict: [String: AnyObject]) {
        /// 从anyObject 转化为正常类型
        
        name = dict["name"] as? String
        
        
    }
    
    /**闭包类型（参数）-》 （返回值）
     
     */

  
    func request(callBack : () -> ()) {
        
    }
    
}
