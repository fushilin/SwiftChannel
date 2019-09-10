//
//  JerryOptionTypeTools.swift
//  ZRNetworkModule
//
//  Created by 我演示 on 2019/8/4.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import Foundation
import Network
import NetworkExtension
import ZRBase
import Starscream
import Gzip
import ObjectMapper

  /**
 自选股票数据
 */
public enum optionPort {
    case  port(ts:String , currentPage: Int , pageSize: Int )
    case addPort(type:Int,ts: String , code: String)
}

///数据处理Net信息
extension optionPort:NetworkAPI{
    public var path: String {
        switch self {
        case .port:
            let url = "/stock-market/api/stock/selected/v1/view/list"
            return url
        case .addPort:
            let url = "/stock-market/api/stock/selected/v1/view/add"
            return url
        }
    }
    
   public var parameters: [String : Any] {
        switch self {
        case .port(let ts , let currentPage,  let pageSize):
            
            var dict = [String:Any]()
            dict["ts"]  = ts
            dict["currentPage"] = currentPage
            dict["pageSize"] = pageSize
            
            return dict
        case .addPort(let type, let ts, let code):
            var dict = [String:Any]()
            dict["type"]  = type
            dict["ts"] = ts
            dict["code"] = code
            
            return dict
            
        }
    }
}
 public enum socketSendPackageResult {
    case succes
    case failur(Error)
}




