//
//  OptionPort.swift
//  ZRNetworkModule
//
//  Created by 1230 on 2019/7/30.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import ObjectMapper

public class OptionPort: Mappable {
    var currentPage: String = ""
    var datas : [OptionData] = [OptionData]()
    var pageSize: String = ""
    var totalPage: String = ""
    var totalRecord: String = ""
    
    required public init?(map: Map) {
        mapping(map: map  )
    }
    
    public func mapping(map: Map) {
    currentPage   <- map["currentPage"]
    datas <- map["datas"]
    pageSize   <- map["pageSize"]
    totalPage   <- map["totalPage"]
     totalRecord  <- map["totalRecord"]
    }
}


