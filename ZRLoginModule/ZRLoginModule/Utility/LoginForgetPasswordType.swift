//
//  LoginForgetPasswordType.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/21.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit
import ZRCoreKit
import ZRNetwork

/// 忘记密码接口组合
enum  LoginForgetPasswordType {
    
    /// 请求重置验证码
    case loginForgetCode(phone:String , countryCode: String)
    
    /// 后台验证重置验证码
    case loginForgetAuthCode(phone: String,verificationCode: String)

    /// 重置密码请求
    case loginForgetResetPassword(phone: String , verificationCode: String,newLoginPassword: String)
    
    

}


extension LoginForgetPasswordType:NetworkAPI {
    var path: String {
        switch self {
            /// 请求验证码
        case .loginForgetCode(_ , _):
            return "/as_user/api/sms/v1/send_forget_code"
            
       /// 验证
        case .loginForgetAuthCode(_,_):
            return "/as_user/api/user_account/v1/forgot_password_code"
           
            /// 重置密码
        case .loginForgetResetPassword(_,_,_):
            return "/as_user/api/user_account/v1/reset_login_password"
      
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .loginForgetCode( let phone,let  countryCode):
            var dict: [String: String] = [:]
            dict["phone"] = phone
            dict["countryCode"] = countryCode
            return dict
    
        case .loginForgetAuthCode(let phone, let verificationCode):
            var dict: [String: String] = [:]
            dict["phone"] = phone
            dict["verificationCode"] = verificationCode
            return dict
        case .loginForgetResetPassword(let phone, let verificationCode, let newLoginPassword):
            var dict: [String: String] = [:]
            dict["phone"] = phone
            dict["verificationCode"] = verificationCode
            dict["newLoginPassword"] = newLoginPassword
            
            return dict
            
        }
        
    }
    
    
}
