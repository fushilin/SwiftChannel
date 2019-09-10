//
//  LoginView.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/21.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit
import ZRNetwork
import ZRCoreKit


/// 定义协议和代理
protocol loginViewDelegate {
    func sendTelephoneAndSec(telephone: String , sec: String)
}

public class LoginView: UIView {
    
    /// Bool为真，tel 为真
    public var isTelephone: Bool = false
    
    /// 判定密码输入状态
    public var isSecurity: Bool  = false
    
    var delegate: loginViewDelegate?
    
    /// 创建接收React.计算服务于协议的富文本宽度
    private var  rect: CGRect = .zero
    public var  telphoneTextLength: Int = 11
    /// 接收不同国家的电话号码区号以及名称
    public var areaCode: String? = "0086" {
        didSet {
            /// 验空
            guard let newName = areaCode  else { return}
            loginSelContryView.countryLabel.text = newName
            loginTelView.teltimeZoneLabel.text = newName
            telphoneTextLength = 11
         }
    }
    
    /// *按钮属性
    public lazy var backBtn: UIButton = {
        let backBtn = UIButton.init()
        backBtn.setImage(UIImage.login.resourceImage("login_back"), for: .normal)
        addSubview(backBtn)
        return backBtn
    }()
  
    ///左上角登录label
    private lazy var loginLabel: UILabel = {
        let loginLabel = UILabel.init(frame: .zero, text: LoginLoc("登录"), textAlignment: .left, textFont: 25)
        loginLabel.textColor = UIColor.init(hex: 0x232323)
        loginLabel.font = UIFont.systemFont(ofSize: 25)
        addSubview(loginLabel)
        return loginLabel
    }()
    
    /// 选择国家和地区view
      public lazy var loginSelContryView: LoginSelectCountryView = {
        let loginSelContryView = LoginSelectCountryView.init(LoginLoc("国家/地区"), LoginLoc("中国内地"), "chose_country")
        addSubview(loginSelContryView)
        return loginSelContryView
    }()
    
    ///选择手机号码view 区号，限定数位，限定数字键盘，
    public lazy var loginTelView: LoginTelephoneView = {
        let loginTelView = LoginTelephoneView.init(LoginLoc("+86"), placeHolder: LoginLoc("请填写手机号码"))

        loginTelView.telTextField.keyboardType =  UIKeyboardType.numberPad
        loginTelView.telTextField.delegate = self
        NotificationCenter.default.addObserver(self , selector: #selector(observeValueChange),
                                               name:UITextField.textDidChangeNotification ,
                                               object: loginTelView.telTextField)
        
        addSubview(loginTelView)
        return loginTelView
    }()
    
    /// 密码view
    public lazy var loginVeriView: LoginTelephoneView = {
        let loginVeriView =  LoginTelephoneView.init(LoginLoc("密码"), placeHolder:  LoginLoc("请输入密码"))
        loginVeriView.telTextField.isSecureTextEntry = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(observeValueSecurityChange),
                                               name:UITextField.textDidChangeNotification ,
                                               object: loginVeriView.telTextField)
        loginVeriView.telTextField.delegate = self
        addSubview(loginVeriView)
        return loginVeriView
    }()
    
    /// 验证码登录注册按钮
    public lazy var loignVerifyBtn: UIButton = {
        let loignVerifyBtn = UIButton.init(title: LoginLoc("验证码登录注册"),
                                textColor: UIColor.init(hex: 0x1A6ED2),
                                textfont: UIFont.systemFont(ofSize: 13))
        
        loignVerifyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        loignVerifyBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left;
        addSubview(loignVerifyBtn)
        return loignVerifyBtn
    }()
    
    ///忘记密码按钮
     public lazy var forgetPasswordBtn: UIButton = {
        let forgetPasswordBtn = UIButton.init(title: LoginLoc("忘记密码"),
                                textColor: UIColor.init(hex: 0x1A6ED2),
                                textfont: UIFont.systemFont(ofSize: 13))
        forgetPasswordBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        forgetPasswordBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right;
        addSubview(forgetPasswordBtn)
        return forgetPasswordBtn
    }()
    
    
    ///登录按钮
     public lazy var loginBtn : UIButton = {
        let loginBtn = UIButton.init(title: LoginLoc("登录"),
                                textColor: UIColor.init(hex: 0xFFFFFF),
                                textfont: UIFont.systemFont(ofSize: 23), state: .normal)
        loginBtn.backgroundColor = UIColor.init(hex: 0x8db9e4)
        /// 开始禁用
        loginBtn.isEnabled = false
        loginBtn.addTarget(self, action: #selector(pressLoginBtn), for: .touchUpInside)
        loginBtn.mask?.clipsToBounds = true
        loginBtn.layer.cornerRadius = 2.0
        addSubview(loginBtn)
        return loginBtn
    }()
    
    /// 添加富文本点击属性 使用textView的信息
    public lazy var  loginViewServeView: UITextView = {
        let servString = LoginLoc("登录即表示阅读并同意服务协议和隐私协议")
        rect  = UILabel.getTextRectSize(text:servString as NSString,
                                font:UIFont.systemFont(ofSize: 11),
                                size: CGSize(width: .max, height: 25))
        let loginViewServeView = UITextView.init(label: servString)
        addSubview(loginViewServeView)
        return loginViewServeView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hex: 0xf0f0f0)
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginView {

    ///登录按钮点击
    @objc private func pressLoginBtn() {
    
//        print("点击了登录按钮")
        self.ck.viewContoroller?.startLoading()
        
        let netWork = Network<LoginVertyType>()
        /// 验空
        guard let telString  =  loginTelView.telTextField.text else {return}
        guard let secString = loginVeriView.telTextField.text else {return}
        guard let telAreaString = areaCode else {return }
        
//        self.ck.viewContoroller?.push(of: LoginModuleType.forgetPassWord , parameter: <#T##[String : Any]?#>, animated: <#T##Bool#>)
        
    
        netWork.request(LoginVertyType.loginVerity(telString, secString.md5(), telAreaString)) {[weak self ] (result) in
        
            self?.ck.viewContoroller?.stopLoading()
            switch result {
            case .success(let rep ):
                guard let resu = LoginRequestCode(rawValue: rep.code) else {
                    return
                }
               switch  resu {
                case .success:
                    
                
                    
                break
               case .notSetupSec:
                /// 传递一个delegate出去
                self?.ck.viewContoroller?.push(of: LoginModuleType.setUpPasswordViewController)
                break

               default:  break
            
            }
            case .failure(_):
            break
        
            }
        }
    }
    
   
    /// 接收电话号码变化的通知
    @objc func observeValueChange(notion:Notification) {
    
        let text = notion.object as? UITextField
        guard let verty = text?.text?.isOnePhone() else {return}
        if verty == true {
            isTelephone = true
        }
        else{
            isTelephone = false
        }
           makeSureChangeBtn(isTele: isTelephone, secText: isSecurity)
    }
    
    /// 接收密码输入框改变的通知
    @objc func observeValueSecurityChange(notion:Notification)  {
        guard  let text1 = notion.object as?  UITextField else { return}
        guard let count =  text1.text?.count  else { return  }
        if count > 5 {
            isSecurity = true
        }else{
            isSecurity = false
        }
        makeSureChangeBtn(isTele: isTelephone, secText: isSecurity)
}
 
    /// 双重验证
    private func makeSureChangeBtn(isTele: Bool , secText: Bool) {
    
        if isTele == true && secText == true {
            loginBtn.backgroundColor = UIColor.init(hex: 0x1a6ed2)
            loginBtn.isEnabled = true
        }else{
            loginBtn.backgroundColor = UIColor.init(hex: 0x8db9e4)
            loginBtn.isEnabled = false
    }
    }
}

/// 限制指定位数

extension LoginView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {  return true  }
        print("-------\(text)")
        
        /// 删除单元格是""
        if string == ""{ return true}
        if(textField == self.loginTelView.telTextField && text.count >= telphoneTextLength  ) {
            
            print("电话号码输入框")
            print(textField.text)
            return false
        } else if ( textField == self.loginVeriView.telTextField && text.count >= 15) {
            print("密码输入框")
            print(textField.text)
            
            return false
        } else {
            return true
        }
        
    }
    
}


/// 布局信息
extension LoginView{
    
    func setUpLayout() {
        
       backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.top.equalTo(self.snp_top).offset(36)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        loginLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.top.equalTo(self.snp_top).offset(95)
            make.height.equalTo(30)
            make.width.equalTo(115)
        }
        
        loginSelContryView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.top.equalTo(self.loginLabel.snp_bottom).offset(40)
            make.right.equalTo(self.snp_right).offset(-30)
            make.height.equalTo(45)
        }
        
        /// 填写电话号码view
        loginTelView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.right.equalTo(self.snp_right).offset(-30)
            make.height.equalTo(45)
            make.top.equalTo(loginSelContryView.snp_bottom).offset(0)
        }
        
        /// 验证码
        loginVeriView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.right.equalTo(self.snp_right).offset(-30)
            make.height.equalTo(45)
            make.top.equalTo(loginTelView.snp_bottom).offset(0)
        }
        
        /// 验证码z登录注册
        loignVerifyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.top.equalTo(loginVeriView.snp_bottom).offset(6)
            make.width.equalTo(100)
            make.height.equalTo(15)
        }
        
        /// 忘记密码 目前忘记密码的界面没有
        forgetPasswordBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp_right).offset(-30)
            make.top.equalTo(loginVeriView.snp_bottom).offset(6)
            make.width.equalTo(100)
            make.height.equalTo(15)
        }
        
        /// 登录按钮
        loginBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.right.equalTo(self.snp_right).offset(-30)
            make.top.equalTo(loignVerifyBtn.snp_bottom).offset(20)
            make.height.equalTo(50)
        }
        /// 布局富文本信息
        /// 传入文字信息，进行布局
     
        loginViewServeView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX).offset(0)
            make.bottom.equalTo(self.snp_bottom).offset(-22)
            make.width.equalTo(rect.width+10)
            make.height.equalTo(40)
            
        }
    }
    

}

