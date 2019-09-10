//
//  OptionSocketBackData.swift
//  ZRNetworkModule
//
//  Created by 1230 on 2019/8/1.
//  Copyright © 2019 lam. All rights reserved.
//

  /**
 ({
 dataType = 3;
 stockData =     (
 {
 ask1 = "8.73";
 "ask1_volume" = 15100;
 ask2 = "8.74";
 "ask2_volume" = 29000;
 ask3 = "8.75";
 "ask3_volume" = 13100;
 ask4 = "8.76";
 "ask4_volume" = 21700;
 ask5 = "8.77";
 "ask5_volume" = 3700;
 bid1 = "8.720000000000001";
 "bid1_volume" = 5200;
 bid2 = "8.710000000000001";
 "bid2_volume" = 12700;
 bid3 = "8.699999999999999";
 "bid3_volume" = 3900;
 bid4 = "8.69";
 "bid4_volume" = 1000;
 bid5 = "8.68";
 "bid5_volume" = 7000;
 code = 603100;
 date = "2019-08-01";
 time = "14:17:56";
 ts = SH;
 type = 2;
 }
 );
 }))
 */

import UIKit
import ObjectMapper

public class OptionSocketBackData: NSObject,Mappable {
    
     var  dataType:String = ""
//    var  stockData:[Array<Any>]
    var stockData = Array<OptionSocketBackDataStockData>()
    required public init?(map: Map) {
        super.init()
        mapping(map: map)
        
    }
    
    public func mapping(map: Map) {
        dataType   <- map["dataType"]
       stockData   <- map["stockData"]
    }

    
}
open class  OptionSocketBackDataStockData: Mappable {
    var ask1_volume:Int =  0
    var  ask2_volume: Int = 0
    var code: String = ""
    required public init?(map: Map) {
  
        mapping(map: map)
    }
    
    public func mapping(map: Map) {
        ask1_volume   <- map["ask1_volume"]
        ask2_volume   <- map["ask2_volume"]
//     code = 603100;
        code <- map["code"]
    }
}
