//
//  LoginModuleRouter.swift
//  ZRLoginModule
//
//  Created by Zhuorui on 2019/7/29.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import Foundation
import ZRCoreKit

/// 配置协议 ,
enum LoginModuleType: MediatorTargetType{
    /// 登录
    case loginViewContoller
    
    /// 验证码
    case verifycodeViewController

    /// 忘记密码
    case forgetPassWord
    
    /// 设置密码
    case setUpPasswordViewController
    
    /// 重置密码
    case replaceMentController
    
    /// 选择区号
    case registerSelectCountry
    
    /// 服务与协议
    case serveAndPrivacy
}

/// url解析
extension LoginModuleType: MediatorRoutable {
    
    init?(url: URLConvertible) {
        if let path = url.path {
            switch path {
                
                
            default:
                return nil 
                
            }
        }
        return nil
    }
    
    static var moduler: String {
        return "login"
    }

}
/// 数据解析
extension LoginModuleType: MediatorSourceType {
    var viewController: UIViewController? {
        switch self {
        case .loginViewContoller:
            return LoginViewController()

        case .verifycodeViewController:
            return VerifyCodeViewController()
        case .forgetPassWord:
            return ForgetPassWordViewController()
        case .setUpPasswordViewController:
            return SetUpPasswordViewController()
        case .replaceMentController:
        return ReplaceMentController()
        
        case .registerSelectCountry:
            return RegisterSelectCountryViewController()
        
        case .serveAndPrivacy:
            return ServeAndPrivacyController()
        }
    }
}


