//
//  RegisterPasswordView.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/15.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit




/// 按钮的状态切换
enum LoginEyesClose {
    case close
    case open
}

///  设置密码的view 以及小眼睛
public class RegisterPasswordView: UIView {
    
    /// 状态控制
    private var  eyeState:LoginEyesClose = .close

    /// 密码文字
    public var nameLabel : UILabel = UILabel()
    
    /// 密码输入框
    public var showTextField: UITextField = UITextField()
    
    /// line
    private  lazy var lineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: 0xA1A1A1)
        return view
    }()
    
    /// eye 图片
    public var registerEyeBtn: UIButton = UIButton()
    
    public convenience init (nameString: String,placeHolderString:String ,image: UIImage? ,selectImage: UIImage?){
        self.init()
        nameLabel = UILabel.init(nameString, textColor: UIColor.init(hex: 0x232323), font: UIFont.systemFont(ofSize: 16))
        nameLabel.textAlignment = .left

        nameLabel.font = UIFont.systemFont(ofSize: 16)
        addSubview(nameLabel)
        
        showTextField.placeholder = placeHolderString
        showTextField.textAlignment = .left
        showTextField.font = UIFont.systemFont(ofSize: 15)
        showTextField.textColor = UIColor.init(hex: 0x282828)
        showTextField.isSecureTextEntry = true
        addSubview(showTextField)
        
        
        registerEyeBtn = UIButton.init(type: .custom)
        registerEyeBtn.setImage(image, for: .normal)
        registerEyeBtn.addTarget(self, action: #selector(pressEyeBnt), for: .touchUpInside)

        addSubview(registerEyeBtn)
        
        
        addSubview(lineView)
        
        
        setUpPasswordViewLayout()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension RegisterPasswordView {
   private func   setUpPasswordViewLayout() {
    
    nameLabel.snp.makeConstraints { (make) in
        make.left.bottom.top.equalTo(0)
        make.width.equalTo(70)
    }
    
    lineView.snp.makeConstraints { (make) in
        make.left.equalTo(nameLabel.snp_right).offset(10)
        make.right.bottom.equalTo(self)
        make.height.equalTo(1)
    }

    showTextField.snp.makeConstraints { (make) in
        make.left.equalTo(nameLabel.snp_right).offset(10)
        make.top.bottom.right.equalTo(self)
    }
    /// 加载eyes btn
    registerEyeBtn.snp.makeConstraints { (make) in
        make.top.right.bottom.equalTo(self)
        make.width.equalTo(20)
    }
    
    }
    
}

extension RegisterPasswordView {
    @objc private func pressEyeBnt() {
        print("点击了眼睛按钮")
        switch self.eyeState {
        case .close:
            self.eyeState = .open
            registerEyeBtn.setImage(UIImage.login.resourceImage("login_openeyes"), for: .normal)
            showTextField.isSecureTextEntry = false
            break
        case .open:
               self.eyeState = .close
               registerEyeBtn.setImage(UIImage.login.resourceImage("hide_password_eye"), for: .normal)
                showTextField.isSecureTextEntry = true
            break
    
        }
    }
}
