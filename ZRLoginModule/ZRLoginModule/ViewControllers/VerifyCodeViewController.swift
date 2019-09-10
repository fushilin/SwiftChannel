//
//  ReigisterViewController.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/15.
//  Copyright © 2019 Zhuorui. All rights reserved.
//


import UIKit
import ZRCoreKit
import ZRNetwork



/// 首次设置密码界面
public class VerifyCodeViewController:BaseViewController {
    /// 记录telephone
    public var  telphoneString:String!
    
    /// 记录code 传值
    public var  codeString:String!
    
    /// 手机区号
    public var  phoneArea:String!
    
    /// 密码
    private var passwordString: String = ""
    
    /// 创建接收React.计算服务于协议的富文本宽度
    var  rect: CGRect = .zero
    
    /// 创建返回按钮属性
    private lazy var  backBtn: UIButton = {
        let backBtn = UIButton.init(title: "",
                                textColor: .red,
                                textFont: UIFont.systemFont(ofSize: 17),
                                image: UIImage.login.resourceImage("resign_login_back"),
                                backgroundImage: UIImage.login.resourceImage(""),
                                state: .normal,
                                target: self,
                                action: #selector(pressRegisterBackBtn), event: .touchUpInside)
        /// 缺少一个高亮状态的按钮
        
        self.view.addSubview(backBtn)
        return backBtn
    }()

    /// 确认密码text
    private lazy var registerPassWordView: RegisterPasswordView = {
        let resg = RegisterPasswordView.init(nameString: LoginLoc("登录密码"),
                                             placeHolderString: LoginLoc("6-20位组合密码"),
                                             image: UIImage.login.resourceImage("hide_password_eye"),
                                             selectImage: UIImage.login.resourceImage("login_openeyes"))
        
        resg.showTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChangeValue),
                                               name: UITextField.textDidChangeNotification,
                                               object: resg.showTextField)
        self.view.addSubview(resg)
        return resg
        
    }()
    
    /// 确认密码View
    private lazy var makeSurePassWord: RegisterPasswordView = {
        let resg = RegisterPasswordView.init(nameString: LoginLoc("确认密码"), placeHolderString: LoginLoc("请再次确认"), image: UIImage.login.resourceImage("hide_password_eye"), selectImage: UIImage.login.resourceImage("hide_password_eye"))
        
        NotificationCenter.default.addObserver(self, selector: #selector(makesureTextFieldDidChangeValue), name: UITextField.textDidChangeNotification, object: resg.showTextField)
        self.view.addSubview(resg)
        return resg
    }()
    
    ///登录按钮
    private lazy var makeSureBtn : UIButton = {
        let makeSureBtn = UIButton(title: LoginLoc("完成"), textColor: UIColor.init(hex: 0xFFFFFF), textFont: UIFont.systemFont(ofSize: 25), target: self, action: #selector(pressMakeSureBtn))
        makeSureBtn.isEnabled = false
        makeSureBtn.backgroundColor = UIColor.init(hex: 0x8DB9E4)
        makeSureBtn.clipsToBounds = true
        makeSureBtn.layer.cornerRadius = 2.0
        self.view.addSubview(makeSureBtn)
        return makeSureBtn
    }()

    /// 添加富文本点击属性 使用textView的信息
    private lazy var  serveLabel: UITextView = {
        let servString = LoginLoc("登录即表示阅读并同意服务协议和隐私协议")
        rect  = UILabel.getTextRectSize(text:servString as NSString,
                                        font:UIFont.systemFont(ofSize: 11),
                                        size: CGSize(width: .max, height: 25))
        let serveViewLabel = UITextView.init(label: servString)
        self.view.addSubview(serveViewLabel)
        return serveViewLabel
    }()
    
    /// 移除通知
    deinit {NotificationCenter.default.removeObserver(self)  }
    
    public  override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  UIColor.init(hex: 0xf0f0f0)
        self.title = LoginLoc("设置密码")
        self.view.addSubview(backBtn)
        setUpRegisterLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override public func routerReceiveParameter(url: String, parameter: [String : Any]?) {
    
    }
    
}


extension VerifyCodeViewController {
    
    @objc private func pressRegisterBackBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
     /// 请求接口信息
    @objc private func pressMakeSureBtn() {
        print("点击了完成按钮,验证登录密码信息")
        
        /// 请求密码jiekou
        let network = Network<LoginVertyType>()
        
        network.request(LoginVertyType.loginSetPassword(phone: telphoneString, phoneArea: phoneArea, verificationCode: codeString, loginPassword: passwordString.md5())) { (result) in
            switch result{
                
            case .success(let rep):
                guard let res = LoginRequestCode(rawValue: rep.code) else {return}
                switch res {
                case .success:
                    break
                case .parameterError:
                    break
                case .forbid:
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
    ///  需要添加两次吗？？
    @objc private func textFieldDidChangeValue(notion:Notification) {
        /// 完成输入之后才去验证
        guard    let textField = notion.object as? UITextField else {
            return
        }
        
        if textField.text!.count < 6 {
            
        }else{
            /// 提示用户
        }
   
        /// 单独验证自身密码 密码组合规则是什么？？？？ 应该在点击按钮的位置验证信息，
        verifySecurityCode()
        
    }
    
    @objc private func makesureTextFieldDidChangeValue(notion: Notification) {
        verifySecurityCode()
        }
    
    /// 验证密码是否符合规则
    func verifySecurityCode() {
        if registerPassWordView.showTextField.text == makeSurePassWord.showTextField.text {
            makeSureBtn.backgroundColor = UIColor.init(hex: 0x1A6ED2)
            makeSureBtn.isEnabled = true
        }else{
            makeSureBtn.backgroundColor = UIColor.init(hex: 0x8DB9E4)
            makeSureBtn.isEnabled = false
        }
    }
}


/// 点击服务器按钮信息
extension VerifyCodeViewController: UITextViewDelegate {

    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "first" {
            print("点击111111")
            return false
        }
        if URL.scheme == "second" {
            print("点击222222")
            return false
        }
        return true
    }
    
}


///布局控件位置
extension VerifyCodeViewController {
    
    @objc private func setUpRegisterLayout(){
        
        /// 登录密码View
        registerPassWordView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.top.equalTo(self.view.snp_top).offset(50)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.height.equalTo(45)
        }
        
        /// 确认密码View
        makeSurePassWord.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.top.equalTo(registerPassWordView.snp_bottom).offset(0)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.height.equalTo(45)
        }
        
        makeSureBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.top.equalTo(makeSurePassWord.snp_bottom).offset(40)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.height.equalTo(50)
        }
        
        /// 布局富文本信息
        serveLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp_centerX).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(-22)
            make.height.equalTo(45)
            make.width.equalTo(rect.width+10)
            
        }
        
    }
    
}


extension VerifyCodeViewController: UITextFieldDelegate {
    
}
