//
//  LoginVerificationCodeView.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/15.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit


/// 验证码View 以及输入框
public class LoginVerificationCodeView: UIView {
    
    /// 1： 左侧验证码Label
    public var verifiLabel: UILabel = UILabel()
    
    /// 2:验证码输入框
    public var verifiTextField: UITextField = UITextField()
    
    ///3： 验证码点击
    public var verifiBtn: UIButton = UIButton()
    private var lineView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.init(hex: 0xA1A1A1)
            return view
        }()
 
    
    convenience init(veriString: String ,  vertiFilePlace: String){
        self.init()
        verifiLabel = UILabel.init(frame: CGRect.zero, text: veriString, textAlignment: .left, textFont: 16)
        verifiLabel.textAlignment = .left
        verifiLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(verifiLabel)
        
        verifiTextField.placeholder = vertiFilePlace
        verifiTextField.font = UIFont.systemFont(ofSize: 16)
        verifiTextField.textAlignment = .left
        addSubview(verifiTextField)
        
        verifiBtn = UIButton.init(title: LoginLoc("发送验证码"), textColor: UIColor.init(hex: 0x8DB9E4), textfont: UIFont.systemFont(ofSize: 13), state: .normal)
        verifiBtn.isEnabled = false
        addSubview(verifiBtn)
        
        addSubview(lineView)
        setUpLayout()
        
        
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoginVerificationCodeView {
    private  func setUpLayout(){
        verifiLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(80)
        }
        
        verifiBtn.snp.makeConstraints { (make) in
            make.right.bottom.top.equalTo(self)
            make.width.equalTo(80)
        }
        verifiTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(verifiLabel.snp_right).offset(10)
            make.right.equalTo(verifiBtn.snp_left).offset(-10)
            
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(1)
        }
    }
}
