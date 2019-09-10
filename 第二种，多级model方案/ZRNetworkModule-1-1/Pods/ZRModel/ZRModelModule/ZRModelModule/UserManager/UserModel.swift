//
//  UserModel.swift
//  ZRModelModule
//
//  Created by lam on 2019/7/16.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import ObjectMapper

public class UserModel: NSObject, Mappable {
    
    
    public var userId: Int = 0
    
    public var token: String? = ""
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        userId <- map["userId"]
        token  <- map["token"]
    }
    
    override init() {
        super.init()
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
    }
}
