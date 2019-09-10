//
//  ForgetPassWordViewController.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/19.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit
import ZRCoreKit
import ZRNetwork

public class ForgetPassWordViewController: BaseViewController {
   
    private  var isTelephone: Bool = false
    private var isSecurity: Bool  = false
    
    let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: .main)
    private var telephoneNum: String = ""
    private var codeString: String =  ""
    /// 选择国家和地区view
    private lazy var loginSelContryView: LoginSelectCountryView = {
        let view = LoginSelectCountryView.init(LoginLoc("国家/地区"), LoginLoc("中国内地"), ("chose_country"))
        
        view.pressBtn.addTarget(self, action: #selector(pressSelectBtn), for: .touchUpInside)
        self.view.addSubview(view)
        return view
    }()
    
    ///选择手机号码view
    private lazy var loginTelView: LoginTelephoneView = {
        let view = LoginTelephoneView.init(LoginLoc("+86"), placeHolder: LoginLoc("请填写手机号码"))
        view.telTextField.delegate = self
        NotificationCenter.default.addObserver(self , selector: #selector(telphoneChange), name:UITextField.textDidChangeNotification , object: view.telTextField)
       self.view.addSubview(view)
        return view
    }()
    

    
    /// 验证码view
    private lazy var loginVeriView: LoginVerificationCodeView = {
        let view = LoginVerificationCodeView.init(veriString: LoginLoc("验证码"), vertiFilePlace: "请输入验证码")
        view.verifiBtn.addTarget(self , action: #selector(pressVertyCountDown), for: .touchUpInside)
        view.verifiBtn.isEnabled = false
        view.verifiTextField.delegate = self
        /// 监听变化
        NotificationCenter.default.addObserver(self , selector: #selector(observeValueSecurityChange), name:UITextField.textDidChangeNotification , object: view.verifiTextField)
        /// 内容需要改变，怎么通知变化，在text内部？
        self.view.addSubview(view)
        return view
    }()
    
    ///提交按钮
    private lazy var submitBtn : UIButton = {
        let btn = UIButton.init(title: LoginLoc("提交"), textColor: UIColor.init(hex: 0xFFFFFF), textFont: UIFont.systemFont(ofSize: 23), target: self, action: #selector(pressSubmitBtn))
        btn.backgroundColor = UIColor.init(hex: 0x8db9e4)
     
        /// 开始禁用
        btn.isEnabled = false
        btn.mask?.clipsToBounds = true
        btn.layer.cornerRadius = 2.0
        self.view.addSubview(btn)
        return btn
    }()
    
    /// 短信验证码登录
    private lazy var messageAuthBtn : UIButton = {
        let btn = UIButton.init(title: LoginLoc("短信验证码登录"), textColor: UIColor.init(hex: 0x1A6ED2), textFont: UIFont.systemFont(ofSize: 23), target: self, action: #selector(pressMessageAuthBtn))
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.view.addSubview(btn)
        return btn
    }()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = LoginLoc("忘记密码")
        self.view.backgroundColor = UIColor.init(hex: 0xf0f0f0)
//        setUpUI()
        
        setUpLayout()
        
    }
    
    deinit {
        codeTimer.cancel()
    }

    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    public override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
}

extension ForgetPassWordViewController {
//
//    private  func  setUpUI() {
//
//        /// 选择国家和地区
//        self.view.addSubview(loginSelContryView)
//        /// 电话号码
//        self.view.addSubview(loginTelView)
//        ///验证码
//        self.view.addSubview(loginVeriView)
//        /// 登录按钮
//        self.view.addSubview(submitBtn)
//
//        /// 短信验证码登录
//        self.view.addSubview(messageAuthBtn)
//    }
//
    
}

extension ForgetPassWordViewController {
    @objc private func pressSelectBtn() {
        print("点击t选择按钮")
        
    let select =  RegisterSelectCountryViewController()
        
        select.callBackFunction { [weak self]   (model) in
            self?.loginSelContryView.countryLabel.text = model.cn
            self?.loginTelView.teltimeZoneLabel.text = model.code
        }
        self.navigationController?.pushViewController(select, animated: true)
    }
    
    /// 点击了跳转按钮
    @objc private func pressSubmitBtn() {
        print("点击了提交按钮")
        /// 携带参数传递
        
        push(of: LoginModuleType.replaceMentController, parameter:  ["phone": telephoneNum ,"code": codeString], animated: true)
//        self.startLoading()
        
    /// 请求验证
        let network = Network<LoginForgetPasswordType>()
        network.request(LoginForgetPasswordType.loginForgetAuthCode(phone: telephoneNum, verificationCode: codeString)) {    [weak self ] (result) in
            self?.stopLoading()
            switch result{
            
            case .success(let rep):
                guard let res = LoginRequestCode(rawValue: rep.code) else {
                    self?.view.makeToast(LoginLoc("短信验证码登录") , type: .none, completion: nil)
                    return}
                switch res {
                case .success:
                    let vc = ReplaceMentController()
                    vc.telphoneString = self?.telephoneNum ?? ""
                    vc.codeString = self?.codeString ?? ""
                    //       push(of: LoginModuleType.replaceMentController, parameter:  ["phone": telephoneNum ,"code": codeString], animated: true)
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                    break
                default:
                    break
        
                }
                
                
            case .failure(_):
                break
            }
            
        }
        
        

        
    }
    @objc private func pressMessageAuthBtn() {
        print("点击了短信码登录")
        self.navigationController?.popViewController(animated: true)
        
    }

    
    /// 验证码按钮
    @objc private func pressVertyCountDown() {
        
        /// 菊花
        
        let network = Network<LoginForgetPasswordType>()
        network.request(LoginForgetPasswordType.loginForgetCode(phone: telephoneNum, countryCode: "0086"))  { [weak self ] (result) in
           
            switch result {
            case .success(let rep):
                guard  let res = LoginRequestCode(rawValue: rep.code) else  {
                    self?.view.makeToast(LoginLoc("请求失败"), type: .none, completion: nil)
                    return
                    
                }
                switch res {
                    
                case .success:
                     self?.view.makeToast("验证码已发送", type: .none) { }
                    var timer = 50
                    
                    self?.codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))
                    self?.codeTimer.setEventHandler {
                        timer = timer - 1
                        DispatchQueue.main.async {[weak self ] in
                            self?.loginVeriView.verifiBtn.isEnabled = false
                        }
                        if  timer <= 0 {
                            self?.codeTimer.cancel()
                            DispatchQueue.main.async {[weak self] in
                                self?.loginVeriView.verifiBtn.isEnabled = true
                                self?.loginVeriView.verifiBtn.setTitle(LoginLoc("重新发送"), for: .normal)
                            }
                            return
                        }
                        DispatchQueue.main.async {[weak self] in
                            self?.loginVeriView.verifiBtn.setTitle(LoginLoc("\(timer)s"), for: .normal)
                        }
                        
                    }
                    self?.codeTimer.activate()
                    
                   
                break
                    
                 default:
                    self?.view.makeToast(rep.msg, type: .none) { }
                    break
                }
                
                break
            case .failure(_):
                break
                
            }
            
        }
        /// 验证码按钮倒计时
        
    
    }
    
    /// 忘记密码按钮

    
    ////
    @objc private func telphoneChange(notion:Notification) {
        let text = notion.object as? UITextField
        /// 在这个地方验证信息密码  end 信息 这个位置保存
        /// 写验证手机号的方法,验证通过，改变改变状态 需要全局监听
        print(text?.text)
        guard let verty = text?.text?.isOnePhone() else {
            return
        }
        
        if verty == true {
                print("是一个手机号码 ")
            telephoneNum = text?.text ?? ""
               loginVeriView.verifiBtn.isEnabled = true
                isTelephone = true
                loginVeriView.verifiBtn.setTitleColor(UIColor.init(hex: 0x1A6ED2), for: .normal)
            
        }
        else{
            print("还不是手机号 ")
            loginVeriView.verifiBtn.setTitleColor(UIColor.init(hex: 0x8db9e4), for: .normal)
            loginVeriView.verifiBtn.isEnabled = false
            isTelephone = false
            telephoneNum = ""
        }
    }
    
    @objc private func observeValueSecurityChange(notion:Notification)  {
        guard  let text1 = notion.object as?  UITextField else {
            return
        }
        
        /// 在这个地方验证信息密码  end 信息 这个位置保存
        /// 写验证手机号的方法,验证通过，改变改变状态
        /// 需要双重验证规则
        
        guard let count =  text1.text?.count  else {
            return
        }
        
        if count > 5 {
            codeString = text1.text ?? ""
            isSecurity = true
        }else{
            isSecurity = false
            codeString = ""
        }
    
        makeSureChangeBtn(isTele: isTelephone, secText: isSecurity)
    }
    
    func makeSureChangeBtn(isTele: Bool , secText: Bool) {
        if isTele == true && secText == true {
            print("是一个手机号码 ")
            submitBtn.isEnabled = true
            submitBtn.backgroundColor = UIColor.init(hex: 0x1a6ed2)
            
            /// 写一个验证负责
        }else{
            /// 还不是手机号
            print("还不是手机号 ")
            submitBtn.backgroundColor = UIColor.init(hex: 0x8db9e4)
            submitBtn.isEnabled = false
        }
        
    }
    
}
extension ForgetPassWordViewController:UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {  return true  }
        print("-------\(text)")
        
        /// 删除单元格是""
        if string == ""{ return true}
        if(textField == self.loginTelView.telTextField && text.count >= 11  ) {
            
            print("电话号码输入框")
            print(textField.text)
            return false
        } else if ( textField == self.loginVeriView.verifiTextField && text.count >= 6) {
            print("密码输入框")
            print(textField.text)
            
            return false
        } else {
            return true
        }
        
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.loginTelView.telTextField {
            if textField.text?.isOnePhone() ?? false {
                
            }else{
                self.view.makeToast("号码输入有误", type: .none) {
                    
                }
            }
        }
    }
    
}

extension ForgetPassWordViewController {

    private func setUpLayout(){
            loginSelContryView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.top.equalTo(self.view.snp_top).offset(40)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.height.equalTo(45)
            }
        
            /// 填写电话号码view
            loginTelView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.height.equalTo(45)
            make.top.equalTo(loginSelContryView.snp_bottom).offset(0)
            }
        
            /// 验证码
            loginVeriView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.height.equalTo(45)
            make.top.equalTo(loginTelView.snp_bottom).offset(0)
            }
        
        
            /// 登录按钮
            submitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.top.equalTo(loginVeriView.snp_bottom).offset(65)
            make.height.equalTo(50)
            }
        
            /// 短信a验证
            messageAuthBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.top.equalTo(submitBtn.snp_bottom).offset(15)
            make.height.equalTo(15)
            }
        
            }
    
}
