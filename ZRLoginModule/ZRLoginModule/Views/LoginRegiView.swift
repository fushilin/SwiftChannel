//
//  LoginRegiView.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/21.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit
import ZRNetwork
import ZRCoreKit


/// 定义协议和代理
protocol loginReginDelegate {
    func loginReginSendParment(parment: [String:Any])
    func loginReginSendSuccess()
}

public class LoginRegiView: UIView {

    
    public var  telphoneTextLength: Int = 11
    /// 区信息 更改
    var codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: .global())
     var timer = 5
    public var phoneArea: String?  = "0086"{
        didSet {
            guard let newName = phoneArea else {return}
            registerSelContryView.countryLabel.text = newName
            registerTelView.teltimeZoneLabel.text = newName
            telphoneTextLength = 11
        }
    }
    
    /// 创建接收React的信息
    var  rect: CGRect = CGRect()
    
    /// 定义状态改变
    private var isTelphone: Bool = false
    private var isVerty : Bool = false
    
    var delegate:loginReginDelegate?
    
    /// 创建返回按钮属性
    private lazy var  registerBackBtn: UIButton = {
        let registerBackBtn = UIButton.init(title: "", textColor: .red, textFont: UIFont.systemFont(ofSize: 17),
                                image: UIImage.login.resourceImage("login_back"),
                                backgroundImage: UIImage.login.resourceImage(""), state: .normal,
                                target: self, action: #selector(pressBackBtn),
                                event: .touchUpInside )
        addSubview(registerBackBtn)
        return registerBackBtn
    }()
    
    /// 左侧登录注册
    private lazy var registeLabel: UILabel = {
        let registeLabel = UILabel.init(frame: .zero, text: LoginLoc("登录/注册"), textAlignment: .left, textFont: 25)
        registeLabel.textColor = UIColor.init(hex: 0x232323)
        registeLabel.font = UIFont.systemFont(ofSize: 25)
        addSubview(registeLabel)
        return registeLabel
    }()
    
    /// 选择国家和地区view
    public lazy var registerSelContryView: LoginSelectCountryView = {
        let registerSelContryView = LoginSelectCountryView.init(LoginLoc("国家/地区"), LoginLoc("中国内地"), LoginLoc("chose_country"))
        addSubview(registerSelContryView)
        return registerSelContryView
    }()
    
    ///选择手机号码view 默认固定写法
    public lazy var registerTelView: LoginTelephoneView = {
        let registerTelView = LoginTelephoneView.init("+86", placeHolder: "请填写手机号码")
        NotificationCenter.default.addObserver(self , selector: #selector(observeTelValueChange),
                                               name:UITextField.textDidChangeNotification ,
                                               object: registerTelView.telTextField)
        registerTelView.telTextField.delegate = self
        addSubview(registerTelView)
        return registerTelView
    }()
    
    /// 验证码view 监听变化
    public lazy var registerVeriView: LoginVerificationCodeView = {
        let registerVeriView = LoginVerificationCodeView.init(veriString: LoginLoc("验证码"), vertiFilePlace: "请输入验证码")
        registerVeriView.verifiBtn.isEnabled = false
        registerVeriView.verifiBtn.addTarget(self, action: #selector(pressVertyBtn), for: .touchUpInside)
        NotificationCenter.default.addObserver(self , selector: #selector(vertyTextChange),
                                               name: UITextField.textDidChangeNotification,
                                               object: registerVeriView.verifiTextField)
        registerVeriView.verifiTextField.delegate = self
        addSubview(registerVeriView)
        return registerVeriView
    }()
    
    ///登录按钮
    private lazy var registerLoginBtn : UIButton = {
        let btn = UIButton.init(title: LoginLoc("登录"), textColor: UIColor.init(hex: 0xFFFFFF), textFont: UIFont.systemFont(ofSize: 23), target: self, action: #selector(pressLoginBtn))
        btn.backgroundColor = UIColor.init(hex: 0x8DB9E4)
        btn.mask?.clipsToBounds = true
        btn.layer.cornerRadius = 2.0
        btn.isEnabled = false
        addSubview(btn)
        return btn
    }()
    
    ///手机号密码登录
    public lazy var registerTeleBtn: UIButton = {
        let btn = UIButton.init(title: LoginLoc("手机号密码登录"),
                                textColor: UIColor.init(hex: 0x1A6ED2),
                                textfont: UIFont.systemFont(ofSize: 13),
                                state: .normal)
        addSubview(btn)
        return btn
    }()
    
    /// 添加富文本点击属性 使用textView的信息
    public lazy var  regServeTextView: UITextView = {
        let str0 = LoginLoc("登录即表示阅读并同意")
        let str1 = LoginLoc("服务协议")
        let str2 = LoginLoc("和")
        let str3 = LoginLoc("隐私协议")
        let contentStr =  (str0+str1+str2+str3)
        rect  = UILabel.getTextRectSize(text: contentStr as NSString,
                                        font:UIFont.systemFont(ofSize: 11),
                                        size: CGSize(width: .max, height: 25))
        let textView = UITextView.init(label: contentStr)
        addSubview(textView)
        return textView
    }()
    deinit {
        self.codeTimer.cancel()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginRegiView {
    /// 返回按钮的点击
    @objc func pressBackBtn() {
    }
    
    @objc private func pressSelectBtn() {
    }
    
    /// 点击登录按钮，请求登录接口
    @objc private func pressLoginBtn() {
        
        self.ck.viewContoroller?.startLoading()
        let network = Network<LoginVertyType >()

        guard let telphoneString = registerTelView.telTextField.text else {return}
        guard let codeString = registerVeriView.verifiTextField.text else {return}
        guard let areaString = phoneArea else {return}
        
        network.request(LoginVertyType.loginCode(telphoneString, codeString, areaString)) { [weak self ] (result) in
            self?.ck.viewContoroller?.stopLoading()
            
            switch result {
            case .success(let rep):
                guard let res = LoginRequestCode(rawValue: rep.code) else {
                     self?.makeToast(rep.msg, type: .none, completion: { })
                    return
                    
                }
                switch res {
                case .success:
                    /// 成功传递信息
                    
                    break
                    
                    /// 进行代理使用
                case .notSetupSec:
                   self?.ck.viewContoroller?.push(of: LoginModuleType.setUpPasswordViewController)
                    break
                /// 跳转到设置状态
                default:
                   
         
                    break
                }
                
                break
            case .failure(_):
                
                break
                
            }
        }
        
    }
    
    /// 注册界面的按钮点击
    @objc private func pressTelephoneBtn() {
        print("手机号密码登录")
        /// 切换信息位置

    }
    /// 验证码点击
    @objc private func pressVertyBtn() {
        
        /// 验证码按钮倒计时
       
        if codeTimer.isCancelled {
            codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.main)
        }
        
        self.codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))
        self.codeTimer.setEventHandler {
            self.timer = self.timer - 1
            DispatchQueue.main.async {[weak self ] in
                self?.registerVeriView.verifiBtn.isEnabled = false
            }
            if  self.timer <= 0 {
                self.codeTimer.cancel()
                DispatchQueue.main.async {[weak self] in
                    self?.registerVeriView.verifiBtn.isEnabled = true
                    self?.registerVeriView.verifiBtn.setTitle(LoginLoc("重新发送"), for: .normal)
                    self?.timer = 5
                }
                return
            }
            DispatchQueue.main.async {[weak self] in
                guard let timeString = self?.timer else {return}
                self?.registerVeriView.verifiBtn.setTitle(LoginLoc("\(timeString)s"), for: .normal)
            }
        }
        self.codeTimer.resume()

      
//        self.ck.viewContoroller?.startLoading()
        let network = Network<LoginRegisteCode>()
        
        guard  let countryCode = phoneArea else {return}
        guard  let telphoneString = registerTelView.telTextField.text else { return}
        network.request(LoginRegisteCode.loginRegistecode(telphoneString, countryCode))  {[weak self] (result) in
            self?.ck.viewContoroller?.stopLoading()
            switch result{
                
            /// 只需要处理异常，其余的不管
            case .success(let rep):
                guard let res = LoginRequestCode(rawValue: rep.code) else{
                    
                    
                    return}
               
                switch res {
                case .success:
                     self?.ck.viewContoroller?.view.makeToast("验证码已发送", type: .none, completion:  nil)
                     print("验证码按钮点击")
       
                    break
                    
                case .parameterError:
                    break
                    
                default:
                  
                    
                    break
                }
                
                break
                
            case .failure(_):
                break
                
            }
            
        }
    }
   
}

/// 接收通知
extension LoginRegiView {
    
    //电话号码判断
    @objc private func observeTelValueChange(notion: NSNotification) {
        
        let text = notion.object as? UITextField
        guard let verty = text?.text?.isOnePhone() else {return}
        if verty == true {
            isTelphone = true
            /// 验证码按钮状态改变
            registerVeriView.verifiBtn.setTitleColor(UIColor.init(hex: 0x1a6ed2), for: .normal)
            registerVeriView.verifiBtn.isEnabled = true
        }
        else{
            isTelphone = false
            registerVeriView.verifiBtn.setTitleColor(UIColor.init(hex: 0x8db9e4), for: .normal)
            registerVeriView.verifiBtn.isEnabled = false
        }
        makeVertyTelAndVer(isVerty: isVerty, isTel: isTelphone)
    }
    
    
    /// 验证码检测位置
    @objc private func vertyTextChange(notion: Notification) {
        let textField = notion.object as? UITextField
        guard let textString = textField?.text else {
           return
        }
        if textString.count == 6 {
            isVerty = true
        } else {
            isVerty = false
        }
        
        makeVertyTelAndVer(isVerty: isVerty, isTel: isTelphone)
        /// 验证电话号码和验证码同时存在，并且正确
    }
    
    /// 验证电话号码以及验证码的正确性
    private func makeVertyTelAndVer(isVerty: Bool , isTel: Bool){
        if isVerty == true && isTel == true {
            registerLoginBtn.isEnabled = true
            registerLoginBtn.backgroundColor = UIColor.init(hex: 0x1a6ed2)
        }else{
            registerLoginBtn.backgroundColor = UIColor.init(hex: 0x8db9e4)
            registerLoginBtn.isEnabled = false
        }
    }
    
}

/// 代理监听变化
extension LoginRegiView: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {  return true  }
        print("-------\(text)")
        
        
        /// 删除单元格是""
        if string == ""{ return true}
        if(textField == self.registerTelView.telTextField && text.count >= telphoneTextLength  ) {
            
            print("电话号码输入框")
            print(textField.text)
            return false
        } else if ( textField == self.registerVeriView.verifiTextField && text.count >= 6) {
            print("验证码输入框")
            print(textField.text)
            
            return false
        } else {
            return true
        }
    }
}




/// 布局UI和位置
extension LoginRegiView {
    
    private func setUpLayout() {
        registerBackBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.top.equalTo(self.snp_top).offset(36)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        registeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.top.equalTo(self.snp_top).offset(95)
            make.height.equalTo(30)
            make.width.equalTo(115)
        }
        
        registerSelContryView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.top.equalTo(self.registeLabel.snp_bottom).offset(40)
            make.right.equalTo(self.snp_right).offset(-30)
            make.height.equalTo(45)
        }
        
        /// 填写电话号码view
        registerTelView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.right.equalTo(self.snp_right).offset(-30)
            make.height.equalTo(45)
            make.top.equalTo(registerSelContryView.snp_bottom).offset(0)
        }
        
        /// 验证码
        registerVeriView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.right.equalTo(self.snp_right).offset(-30)
            make.height.equalTo(45)
            make.top.equalTo(registerTelView.snp_bottom).offset(0)
        }
        
        /// 登录按钮
        registerLoginBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.right.equalTo(self.snp_right).offset(-30)
            make.top.equalTo(registerVeriView.snp_bottom).offset(20)
            make.height.equalTo(50)
        }
        
        registerTeleBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(30)
            make.right.equalTo(self.snp_right).offset(-30)
            make.top.equalTo( registerLoginBtn.snp_bottom).offset(15)
            make.height.equalTo(20)
        }
        
        regServeTextView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp_centerX).offset(0)
            make.bottom.equalTo(self.snp_bottom).offset(-22)
            make.width.equalTo(rect.width+10)
            make.height.equalTo(40)
        }
    }
}
