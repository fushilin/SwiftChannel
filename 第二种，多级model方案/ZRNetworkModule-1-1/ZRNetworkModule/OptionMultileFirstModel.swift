//
//  OptionMultileModel.swift
//  ZRNetworkModule
//
//  Created by 我演示 on 2019/8/4.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// 多添加三个参数信息，用来进行改变

class OptionMultileFirstModel: NSObject {
    var index:NSInteger = 0
    var optionMultileSecondeModel:OptionMultileSecondModel = OptionMultileSecondModel()
 override convenience init() {
       self.init()
    
    }
    
    
}
class OptionMultileSecondModel: NSObject {
    var type:String = ""
    var optiondata: OptionData =  OptionData()
    
 convenience override init() {
        self.init()
    
    }
}
