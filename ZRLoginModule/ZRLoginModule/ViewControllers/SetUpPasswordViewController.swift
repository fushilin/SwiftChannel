//
//  SetUpPasswordViewController.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/20.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit
import ZRCoreKit
import ZRNetwork

/// 首次设置密码界面
class SetUpPasswordViewController: BaseViewController {
  
    /// 第一个设置密码的textView
    private lazy var setupPassWordView: RegisterPasswordView = {
        let setupPassWordView = RegisterPasswordView.init(nameString: LoginLoc("登录密码"), placeHolderString: LoginLoc("6-20位组合密码"),
                                             image: UIImage.login.resourceImage("hide_password_eye"),
                                             selectImage: UIImage.login.resourceImage("login_openeyes"))
        setupPassWordView.showTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(setUpPasswordChange),
                                               name: UITextField.textDidEndEditingNotification, object: setupPassWordView.showTextField)
        self.view.addSubview(setupPassWordView)
        return setupPassWordView
    }()
    
    /// 第二个设置密码的textView
    private lazy var reminderFirst : UILabel = {
        let reminderFirst = UILabel.init(frame: CGRect.zero, text: LoginLoc("*大、小写字母，数字或标点至少含有两种"), textAlignment: .left, textFont: 13)
        reminderFirst.textColor = UIColor.init(hex: 0xFF0000)
        reminderFirst.font = UIFont.systemFont(ofSize: 13)
        reminderFirst.isHidden = true
        reminderFirst.numberOfLines = 2
        self.view.addSubview(reminderFirst)
        return reminderFirst
    }()
    
    /// 确认密码View
    private lazy var setUpSurePassWordView: RegisterPasswordView = {
    
        let setUpSurePassWordView = RegisterPasswordView.init(nameString: LoginLoc("确认密码"), placeHolderString: LoginLoc("请再次确认"),
                                             image: UIImage.login.resourceImage("hide_password_eye"),
                                             selectImage: UIImage.login.resourceImage("hide_password_eye"))
        NotificationCenter.default.addObserver(self, selector: #selector(setUpSurePasswordChangeValue),
                                               name: UITextField.textDidChangeNotification, object: setUpSurePassWordView.showTextField)
        self.view.addSubview(setUpSurePassWordView)
        return setUpSurePassWordView
    }()
    
    /// 第二个提示label label信息回变化
    private lazy var reminderSecond : UILabel = {
        let reminderSecond = UILabel.init(frame: .zero, text: LoginLoc("*两次密码输入不一致"), textAlignment: .left, textFont: 13)
        reminderSecond.textColor = UIColor.init(hex: 0xFF0000)
        reminderSecond.isHidden = true
        reminderSecond.numberOfLines = 2
        self.view.addSubview(reminderSecond)
        return reminderSecond
    }()
    
    ///确认重置按钮
    private lazy var confirmBtn : UIButton = {
        let confirmBtn = UIButton.init(title: LoginLoc("完成"), textColor: UIColor.init(hex: 0xFFFFFF), textFont: UIFont.systemFont(ofSize: 23), target: self, action: #selector(pressConfirmBtn))
        confirmBtn.backgroundColor = UIColor.init(hex: 0x8db9e4)
        
        /// 开始禁用
        confirmBtn.isEnabled = false
        confirmBtn.mask?.clipsToBounds = true
        confirmBtn.layer.cornerRadius = 2.0
        self.view.addSubview(confirmBtn)
        return confirmBtn
    }()
    
    /// 短信验证码登录
    private lazy var messageAuthBtn : UIButton = {
    
        let messageAuthBtn = UIButton.init(title: LoginLoc("短信验证码登录"),
                            textColor: UIColor.init(hex: 0x1A6ED2),
                            textFont: UIFont.systemFont(ofSize: 23),
                            target: self,
                            action: #selector(pressConfirmAuthBtn))
        messageAuthBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.view.addSubview(messageAuthBtn)
        return messageAuthBtn
    }()
    
    override public func viewDidLoad() {
   
        super.viewDidLoad()
        self.title = LoginLoc("设置密码")
        self.view.backgroundColor = UIColor.init(hex: 0xf0f0f0)
        setUpLayouts()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

}

extension SetUpPasswordViewController {
    
    @objc   private func setUpPasswordChange(notion:Notification) {
         let text = notion.object as? UITextField
        compareTextField()
    }
    
    @objc private func setUpSurePasswordChangeValue(notion: Notification) {
        let text = notion.object as? UITextField
        print(text?.text)
        
        compareTextField()
    }
    
    private func compareTextField() {
        
        guard let text =  self.setUpSurePassWordView.showTextField.text else {
            return
        }
        
        if text.count > 0 && isPassword(passWord: text) == true {
            if self.setUpSurePassWordView.showTextField.text == self.setupPassWordView.showTextField.text {
                self.confirmBtn.backgroundColor = UIColor(hex: 0x1a6ed2)
                self.confirmBtn.isEnabled = true
            } else {
                self.confirmBtn.backgroundColor = UIColor(hex: 0x8db9e4)
                self.confirmBtn.isEnabled = false
            }
        }
       
    }
    ////重置密码的接口
    @objc private func pressConfirmBtn (){
        
        print("点击了设置按钮")
        ///  跳转到初始界面
        
        /// 传递数据

        
        self.navigationController?.popToRootViewController(animated: true)
        

        ///点击验证信息
//        let network = Network<LoginVertyType>()
//        network.request(LoginVertyType.loginSetPassword(phone: , phoneArea: <#T##String#>, verificationCode: <#T##String#>, loginPassword: <#T##String#>)) { (<#ResponseResult#>) in
//            <#code#>
//        }
        
    }
    
    @objc private func pressConfirmAuthBtn() {
        print("点击了短信验证码登录")
        self.navigationController?.popToRootViewController(animated: true)
    }
}


extension SetUpPasswordViewController : UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        guard let text = textField.text else {  return true  }
        /// 删除单元格是""
        if string == ""{ return true}
      
        if (textField == self.setupPassWordView.showTextField ) {
            reminderFirst.isHidden = true
            
            if text.count >= 10 {
                return false
            }else{
                return true
            }
         
        } else if (textField == self.setUpSurePassWordView.showTextField ) {
            return false
        } else {
             return true
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == self.setupPassWordView.showTextField ) {
            
            if textField.text?.count ?? -1  < 6{
                reminderFirst.text = LoginLoc("*密码不能少于六位")
                reminderFirst.isHidden = false
          
            }else if ( textField.text?.count ?? -1 >= 20 ){
                reminderFirst.text = LoginLoc("*密码不能大于20位")
                reminderFirst.isHidden = false
            }
            else{
                if  isPassword(passWord: textField.text!) == false {
                    reminderFirst.text = LoginLoc("*大、小写字母，数字或标点至少含有两种")
                    reminderFirst.isHidden = false
                }
            }
        }
    }
    
//      /^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)(?!([^(0-9a-zA-Z)]|[])+$)([^(0-9a-zA-Z)]|[]|[a-z]|[A-Z]|[0-9]){6,}$/
//      "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"  6-20位字母数字
    
    /**
     --密码为8~20位数字,英文,符号至少两种组合的字符
     ^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)(?![,\.#%'\+\*\-:;^_`]+$)[,\.#%'\+\*\-:;^_`0-9A-Za-z]{8,20}$
     */

    public func isPassword(passWord:String) -> Bool {
        let pwd =   "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"
        let regext = NSPredicate(format: "SELF MATCHES %@", pwd)
        if (regext.evaluate(with: passWord) == true) {
            return true
        }else{
            return false
        }
        
    }
    
}

extension SetUpPasswordViewController {

    /// 布局控件
    private func  setUpLayouts(){
        setupPassWordView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.top.equalTo(self.view.snp_top).offset(60)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.height.equalTo(40)
        }
        
        reminderFirst.snp.makeConstraints { (make) in
        
            make.left.equalTo(setupPassWordView.snp_left).offset(80)
            make.right.equalTo(setupPassWordView.snp_right).offset(0)
            make.top.equalTo(setupPassWordView.snp_bottom).offset(4)
            make.height.equalTo(35)
        }
        
        
        setUpSurePassWordView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.top.equalTo(setupPassWordView.snp_bottom).offset(45)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.height.equalTo(40)
        }
        /// 确认重置
        reminderSecond.snp.makeConstraints { (make) in
            make.left.equalTo( setUpSurePassWordView.snp_left).offset(80)
            make.top.equalTo(setUpSurePassWordView.snp_bottom).offset(4)
            make.right.equalTo(setUpSurePassWordView.snp_right).offset(0)
            make.height.equalTo(35)
        }
        
        /// 确认重置按钮
        
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.top.equalTo(setUpSurePassWordView.snp_bottom).offset(65)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.height.equalTo(50)
        }
        
        messageAuthBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.top.equalTo(confirmBtn.snp_bottom).offset(15)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.height.equalTo(15)
        }
    }
}
