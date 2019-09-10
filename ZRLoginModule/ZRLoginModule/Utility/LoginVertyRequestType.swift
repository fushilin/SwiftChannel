//
//  LoginVertyRequestType.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/20.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit
import ZRNetwork


///phone  手机号   verificationCode  验证码   string  phoneArea
/// 短信密码登录
enum LoginVertyType {
    
    /// 密码登录
    case loginVerity(_ phone: String , _ loginPassword: String , _ phoneArea: String )
    
    /// 验证码登录
    case loginCode(_ phone: String , _ loginPassword: String , _ phoneArea: String )
    
    /// 第一次设置密码
    case loginSetPassword( phone: String ,  phoneArea: String,  verificationCode:String ,  loginPassword:String)
}
extension LoginVertyType: NetworkAPI {
    
    /// 接口信息
    var path: String {
        switch self {
        case .loginVerity( _  ,  _ , _ ):
            return "/as_user/api/user_account/v1/user_login_pwd"
        case .loginCode(_ , _ , _):
            return  "/as_user/api/user_account/v1/user_login_code"
        case .loginSetPassword(_ , _ , _, _ ):
            return "/as_user/api/user_account/v1/set_login_password"
        }
    }
    
    
    /// 参数拼接
    var parameters: [String : Any]? {
        switch self {
        case .loginVerity(let phone  , let loginPassword ,let phoneArea ):
            var  dict :[String : String] = [:]
            dict["phone"] = phone
            dict["password"] = loginPassword
            dict["phoneArea"] = phoneArea
            
            print(dict)
            return dict
        case .loginCode(let phone  , let loginPassword ,let phoneArea ):
            var  dict :[String : String] = [:]
            dict["phone"] = phone
            dict["verificationCode"] = loginPassword
            dict["phoneArea"] = phoneArea
            return dict
        case .loginSetPassword(let  phone , let  phoneArea, let  verificationCode , let  loginPassword):
            var  dict :[String : String] = [:]
            dict["phone"] = phone
            dict["verificationCode"] = verificationCode
            dict["phoneArea"] = phoneArea
            dict["loginPassword"] = loginPassword
            print(dict)
            return dict
            
        }
    }
}




///验证码接口。抽离
enum LoginRegisteCode {
    case loginRegistecode(_ phone: String , _ countryCode: String )
}
extension LoginRegisteCode:NetworkAPI{
    var path: String {
        switch self {
        case .loginRegistecode(_ , _):
            return "/as_user/api/sms/v1/send_login_code"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .loginRegistecode(let phone, let country):
            var dict: [String: String] = [:]
            dict["phone"]  = phone
            dict["countryCode"] = country
            return dict
        }
    }
}

