//
//  LoginViewController.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/15.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit
import ZRCoreKit
import ZRNetwork


/// 登录Controller
public class LoginViewController: BaseViewController {
    
    /// 添加loginView
    private lazy var loginView: LoginView = {
        let loginView = LoginView()
        
        loginView.backBtn.addTarget(self , action: #selector(loginPressBackBtn), for: .touchUpInside)
        
        ///验证码登录注册按钮
        loginView.loignVerifyBtn.addTarget(self , action: #selector(pressResign), for: .touchUpInside)
        
        ///选择城市信息
        loginView.loginSelContryView.pressBtn.addTarget(self, action: #selector(pressSelectBtn), for: .touchUpInside)
        
        /// 忘记密码按钮
        loginView.forgetPasswordBtn.addTarget(self , action: #selector(pressForgetBtn), for: .touchUpInside)

       
        self.view.addSubview(loginView)
        return loginView
    }()
    
    /// 添加loginRegisterView
    private lazy var loginRegisterView: LoginRegiView = {
        let loginRegisterView = LoginRegiView.init(frame: CGRect.zero)
        loginRegisterView.isHidden = true
        
        ///c选择城市n按钮
        loginRegisterView.registerSelContryView.pressBtn.addTarget(self , action: #selector(pressSelectBtn), for: .touchUpInside)
        
        /// 手机号登录按钮切换
        loginRegisterView.registerTeleBtn.addTarget(self, action: #selector(pressTelBtn), for: .touchUpInside)
        

        self.view.addSubview(loginRegisterView)
        
        return loginRegisterView
    }()
   

    override public func viewDidLoad() {
        super.viewDidLoad()
       self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.init(hex: 0xf0f0f0)
        
        setLayout()
        
    }
    
    @objc private func pressSelectBtn() {
        print("按钮点击选择国家地区")
        let vc = RegisterSelectCountryViewController()
        
        vc.callBackFunction { (model) in
            self.loginView.loginSelContryView.countryLabel.text = model.cn
            self.loginView.loginTelView.teltimeZoneLabel.text = model.code
            
            
            self.loginRegisterView.registerSelContryView.countryLabel.text = model.cn
            self.loginRegisterView.registerTelView.teltimeZoneLabel.text = model.code
        }
        
        self.navigationController?.pushViewController(vc, animated: true)

        
//        self.push(of: LoginModuleType.registerSelectCountry)
    }
    
    @objc private func loginPressBackBtn() {
        self.loginView.removeFromSuperview()
    }
  
    public override func viewWillAppear(_ animated: Bool) {
    }
    public override func viewWillDisappear(_ animated: Bool) {
       
    }
    
    override public func routerReceiveParameter(url: String, parameter: [String : Any]?) {
        var string = parameter?["haha"]
        self.loginView.loginSelContryView.countryLabel.text = "haha"
        print(string)
    
    }
}

extension LoginViewController {
    
    private  func  setLayout() {
        /// X号按钮
        loginView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        loginRegisterView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
  
}

/// 按钮处理动作
extension LoginViewController {
 
    /// 切换对应的view
    
    @objc private func pressResign() {
        print("点击登录验证注册")
        self.loginView.isHidden = true
        self.loginRegisterView.isHidden = false
    }
    
    /// 点击了切换按钮
    @objc private func pressTelBtn() {
        self.loginRegisterView.isHidden = true
        self.loginView.isHidden = false
    }
    
    @objc private func pressForgetBtn() {
        print("点击了忘记密码的按钮")
        
//        self.push(of: LoginModuleType.forgetPassWord, parameter: <#T##[String : Any]?#>, animated: Lo)
        self.push(of: LoginModuleType.forgetPassWord)
        
    }

}


/// 处置协议和代理 在view内部控制
extension LoginViewController: loginViewDelegate,RegisterSelectCountryDelegate,loginReginDelegate {
       public func loginReginSendParment(parment: [String : Any]) {
        
    }
    
   
    public func loginReginSendSuccess() {
        
        
        self.push(of: LoginModuleType.forgetPassWord)
    }
    
    public  func selectCountrySendName(name: String) {
        print("-----------\(name)")
        loginView.areaCode = name
        loginRegisterView.phoneArea = name
    }
    
    func sendTelephoneAndSec(telephone: String, sec: String) {
        print("\(telephone)-------\(sec)")
    }
    
    /// 协议传递成功 问题：如何区分两个不同的view
    
    
    /// 值传递成功
 
}

extension LoginViewController: UITextViewDelegate {

    
}
