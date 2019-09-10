//
//  ReusltCode.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/20.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit
import ZRCoreKit
import ZRNetwork


enum LoginRequestCode:String {
    
    /// 成功
    case  success = "000000"
    
    /// 参数校验错误
    case   parameterError = "000103"
    
    /// 用户被禁止
    case  forbid = "010004"
    
    /// 手机号或者密码不正确
    case  telephone =  "010005"
    
    /// 密码错误
    case  passwordError = "010006"
    
    ///不同设备
     case  equipmentError = "010007"
    
    /// 系统繁忙，请稍后再试
    case  systemBusy = "000001"
    
    // 用户未设置登陆密码（引导到设置密码页）
    case  notSetupSec = "010003"
    
}
