//
//  PriceDataMdoel.swift
//  CELText
//
//  Created by 我演示 on 2019/8/4.
//  Copyright © 2019 我演示. All rights reserved.
//

import UIKit

class PriceDataMdoel: NSObject {

    
    var nameString:String =  ""
    var tsString : String = ""
    var newPriceString: String = ""
    var UpString : String = ""
    convenience init(name:String,tsName: String , newPrice: String , upString: String) {
        self.init()
        self.nameString = name
        self.tsString = tsName
        self.newPriceString = newPrice
        self.UpString = upString
        
    }
    
}
