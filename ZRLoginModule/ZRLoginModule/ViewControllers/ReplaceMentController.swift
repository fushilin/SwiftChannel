//
//  ReplaceMentController.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/19.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit
import ZRCoreKit
import ZRNetwork



public class ReplaceMentController: BaseViewController {
    
    public var telphoneString = ""
    public var codeString = ""
    public var password = ""
    private lazy var registerPassWordView: RegisterPasswordView = {
    
        let registerPassWordView = RegisterPasswordView.init(nameString: LoginLoc("新密码"), placeHolderString: LoginLoc("6-20位组合密码"),
                                             image: UIImage.login.resourceImage("hide_password_eye"),
                                             selectImage: UIImage.login.resourceImage("login_openeyes"))
        registerPassWordView.showTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidReplceChange),
                                           name: UITextField.textDidEndEditingNotification, object: registerPassWordView.showTextField)
        self.view.addSubview(registerPassWordView)
        return registerPassWordView
    }()
    
    /// 两个提示框信息
    private lazy var reminderFirst : UILabel = {
        let reminderFirst = UILabel.init(frame: .zero, text: LoginLoc("*大、小写字母，数字或标点至少含有两种"), textAlignment: .left, textFont: 13)
        reminderFirst.textColor = UIColor.init(hex: 0xFF0000)
        reminderFirst.font = UIFont.systemFont(ofSize: 13)
        reminderFirst.isHidden = true
        reminderFirst.numberOfLines = 2
        self.view.addSubview(reminderFirst)
        return reminderFirst
    }()
    
    /// 确认密码View
    private lazy var makeSurePassWord: RegisterPasswordView = {
        let makeSurePassWord = RegisterPasswordView.init(nameString: LoginLoc("确认密码"),
                                             placeHolderString: LoginLoc("请再次确认"),
                                             image: UIImage.login.resourceImage("hide_password_eye"),
                                             selectImage: UIImage.login.resourceImage("hide_password_eye"))
        NotificationCenter.default.addObserver(self, selector: #selector(makesureTextFieldDidChangeValue),
                                               name: UITextField.textDidChangeNotification, object: makeSurePassWord.showTextField)
        self.view.addSubview(makeSurePassWord)
        return makeSurePassWord
        }()
    
    private lazy var reminderSecond : UILabel = {
        let reminderSecond =  UILabel.init(frame: .zero, text: LoginLoc("*两次密码输入不一致"), textAlignment: .left, textFont: 13)
        reminderSecond.textColor = UIColor.init(hex: 0xFF0000)
        reminderSecond.font = UIFont.systemFont(ofSize: 13)
        reminderSecond.isHidden = true
        reminderSecond.numberOfLines = 2
        self.view.addSubview(reminderSecond)
        return reminderSecond
    }()
    
    ///确认重置按钮
    private lazy var confirmBtn : UIButton = {
        let confirmBtn = UIButton.init(title: LoginLoc("确认重置"), textColor: UIColor.init(hex: 0xFFFFFF), textFont: UIFont.systemFont(ofSize: 23), target: self, action: #selector(pressConfirmBtn))
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
        let messageAuthBtn = UIButton.init(title: LoginLoc("短信验证码登录"), textColor: UIColor.init(hex: 0x1A6ED2), textFont: UIFont.systemFont(ofSize: 23), target: self, action: #selector(pressConfirmAuthBtn))
        messageAuthBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.view.addSubview(messageAuthBtn)
        return messageAuthBtn
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = LoginLoc("重置密码")
        self.view.backgroundColor = UIColor.init(hex: 0xf0f0f0)
        
        setUpLayouts()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    public override func routerReceiveParameter(url: String, parameter: [String : Any]?) {
        print(parameter)
        
        /// 全局变量，接收参数
    }
}

extension ReplaceMentController {
    
    @objc   private func textFieldDidReplceChange(notion:Notification){
        
        let text = notion.object as? UITextField
        print(text?.text)
        password = text?.text ?? ""
        /// 丢出去验证
//        String regex = "([A-Z]+[a-z]+[0-9]+[\\d\\w]*)|([A-Z]+[0-9]+[a-z]+[\\d\\w]*)|([0-9]+[a-z]+[A-Z]+[\\d\\w]*)" +
//        "|([0-9]+[A-Z]+[a-z]+[\\d\\w]*)|([a-z]+[0-9]+[A-Z]+[\\d\\w]*)|([a-z]+[A-Z]+[0-9]+[\\d\\w]*)";
//        .*[(¿)|(?)|(?)|(!)|(。)|(.)|(¡)|(!)|(!)|(！)].*$
        
        
        //  let regex = "^[A-Za-z0-9\\^\\$\\.\\+\\*_@!#%&~=-]{6,32}$"
//        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//        let isMatch:Bool = predicate.evaluate(with: passStr)
//        return isMatch
//
//        let string = text?.text
        
        let zimu = "@#$^^%^&*("
        /// 八种排列方式包含其中两种
        let regex1 = "([A-Z]+[a-z]+[\\d\\w]*)" /// 大小写字母
//        let regex2 = "([A-Z]+[0-9]+[\\d\\w]*)" /// 大写+数字
//        let regex3 = "([0-9]+[a-z]+[\\d\\w]*)"  /// 小写+数字
//        let regex4 =  zimu + "([0-9]+[\\d\\w]*)"
        
        
        let regex = regex1
//            + regex2 + regex3
//            + regex4
//            "([A-Z]+[a-z]+[0-9]+[\\d\\w]*)|([A-Z]+[0-9]+[a-z]+[\\d\\w]*)|([0-9]+[a-z]+[A-Z]+[\\d\\w]*)" +  "|([0-9]+[A-Z]+[a-z]+[\\d\\w]*)|([a-z]+[0-9]+[A-Z]+[\\d\\w]*)|([a-z]+[A-Z]+[0-9]+[\\d\\w]*)"
        
//        let pattern2 = "^1[0-9]{10}$"
        
        
//        if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: string) {
//            print("输入正确")
//            reminderFirst.isHidden = true
//            
//        }else {
//            reminderFirst.isHidden = false
//        }
  
        
    }
    
    @objc   private func makesureTextFieldDidChangeValue(notion: Notification){
        let text = notion.object as? UITextField
        print(text?.text)
    }
    
    @objc private func pressConfirmBtn (){
        print("点击了重置按钮")
        
        /// 重置按钮
        /// 请求参数
        let network = Network<LoginForgetPasswordType>()
        network.request(LoginForgetPasswordType.loginForgetResetPassword(phone: telphoneString, verificationCode: codeString, newLoginPassword: password)) { (result) in
            switch result {
            case .success(let rep):
                guard let res = LoginRequestCode(rawValue: rep.code) else {return}
                switch res {
                case .success:
                    print("密码成功")
                    break
                default:
                    break
                }
                
            case .failure(_):
                break
                
            default:
                break
                
            }
        }
    }
    
    @objc private func pressConfirmAuthBtn() {
        print("点击了短信验证码登录")
        self.navigationController?.popToRootViewController(animated: true)
        
    }
}


extension ReplaceMentController : UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {  return true  }
        print("-------\(text)")
        
        /// 删除单元格是""
        if string == ""{ return true}
        if(textField == self.registerPassWordView.showTextField  ) {
            reminderFirst.isHidden = true
            
            if text.count >= 10 {
                return false
            }else{
                return true
            }
            
        } else if ( textField == self.makeSurePassWord.showTextField ) {
            print("密码输入框")
            print(textField.text)
            
            return  true
        } else {
            return true
        }
        
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == self.registerPassWordView.showTextField ) {
            
            if textField.text?.count ?? -1  < 6{
                reminderFirst.text = LoginLoc("密码不能少于六位")
                    reminderFirst.isHidden = false
            }else{}
            
            print("电话号码输入框")
            print(textField.text)
        
        }
    }
    
    
}

extension ReplaceMentController {
    
    
private func  setUpLayouts() {
        ///
    
    registerPassWordView.snp.makeConstraints { (make) in
       make.left.equalTo(self.view.snp_left).offset(30)
        make.top.equalTo(self.view.snp_top).offset(60)
        make.right.equalTo(self.view.snp_right).offset(-30)
        make.height.equalTo(40)
        }

        reminderFirst.snp.makeConstraints { (make) in
        make.left.equalTo(registerPassWordView.snp_left).offset(80)
        make.right.equalTo(registerPassWordView.snp_right).offset(0)
        make.top.equalTo(registerPassWordView.snp_bottom).offset(4)
        make.height.equalTo(35)
        }


        makeSurePassWord.snp.makeConstraints { (make) in
        make.left.equalTo(self.view.snp_left).offset(30)
        make.top.equalTo(registerPassWordView.snp_bottom).offset(45)
        make.right.equalTo(self.view.snp_right).offset(-30)
        make.height.equalTo(40)
        }
        /// 确认重置
        reminderSecond.snp.makeConstraints { (make) in
        make.left.equalTo( makeSurePassWord.snp_left).offset(80)
        make.top.equalTo(makeSurePassWord.snp_bottom).offset(4)
        make.right.equalTo(makeSurePassWord.snp_right).offset(0)
        make.height.equalTo(35)
        }

        /// 确认重置按钮
        confirmBtn.snp.makeConstraints { (make) in
        make.left.equalTo(self.view.snp_left).offset(30)
        make.top.equalTo(makeSurePassWord.snp_bottom).offset(65)
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
