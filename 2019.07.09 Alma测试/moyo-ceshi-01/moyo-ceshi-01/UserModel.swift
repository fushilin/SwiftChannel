//
//  UserModel.swift
//  moyo-ceshi-01
//
//  Created by 世霖mac on 2019/7/5.
//  Copyright © 2019 世霖mac. All rights reserved.
//

import Foundation
import MapKit
import ObjectMapper
/**
 "userId": 10,
 "id": 94,
 "title": "qui qui voluptates illo iste minima",
 "body": "aspernatur expedita soluta quo ab ut similique\nexpedita dolores amet\nsed temporibus distinctio magnam saepe deleniti\nomnis facilis nam ipsum natus sint similique omnis"
 */
/**
 声明类的应用信息
 */

class UserModel: Mappable {
    var userId : String?
    var id : String?
    var title: String?
    var body: String?
    
   
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        id <- map["id"]
        title <- map["title"]
        body <- map["body"]
        
        
    }
    

}
