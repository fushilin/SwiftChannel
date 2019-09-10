//
//  CountryModel.swift
//  ZRModelModule
//
//  Created by Zhuorui on 2019/8/19.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import ObjectMapper

public class CountryModel: NSObject,Mappable {
    
    /// 中文
    public var cn: String = ""
    
    /// 中文拼音
    public var cn_py: String = ""
    
    /// 繁体
    public var hant: String = ""
    
    /// 繁体拼音
    public var hant_py: String = ""
    
    /// 英文
    public var en: String = ""
    
    /// 区号
    public var code: String = ""
    
    /// 是否常用
    public var used: Bool = false
    
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        cn <- map["cn"]
        cn_py <- map["cn_py"]
        hant <- map["hant"]
        hant_py <- map["hant_py"]
        en <- map["en"]
        code <- map["code"]
        used <- map["used"]
    }
}

// MARK: - 本地读取
extension CountryModel {
    public class func countryContentsOfFiles() -> [CountryModel]? {
        let bundle = Bundle.resourceBundle(ModelResource.self)
        guard let path = bundle.path(forResource: "Countrys", ofType: nil) else { return nil }
        guard let jsonString = try? String(contentsOfFile: path) else { return nil }
        return [CountryModel].init(JSONString: jsonString)
    }
}
