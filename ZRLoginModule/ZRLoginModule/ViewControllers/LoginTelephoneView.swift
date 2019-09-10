//
//  LoginTelephoneView.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/15.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit
import ZRCoreKit

/// 电话号码View 以及输入框
public class LoginTelephoneView: UIView {
    
    /// 1：属性公开，左侧使用的+86 或者 密码等label信息
    public var teltimeZoneLabel: UILabel = UILabel()
    
    ///2： 信息输入框
    public var telTextField: UITextField = UITextField()
    
    ///3： 底线lineView
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor.init(hex: 0xA1A1A1)
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(_ teltimeZoneString: String, placeHolder: String) {
        self.init()
        
        ///添加布局
        teltimeZoneLabel = UILabel.init(frame: .zero, text: teltimeZoneString, textAlignment: .left, textFont: 16)
        addSubview(teltimeZoneLabel)
        
        telTextField.placeholder = placeHolder
        telTextField.textAlignment = .left
        telTextField.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(telTextField)
        
        addSubview(lineView)
        
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// 布局
extension LoginTelephoneView {
    
    @objc private func setUpLayout() {
        teltimeZoneLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(self)
            make.width.equalTo(80)
        }
        
        telTextField.snp.makeConstraints { (make) in
            make.left.equalTo(teltimeZoneLabel.snp_right).offset(10)
            make.top.right.bottom.equalTo(self)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(1)
        }
        
    }
}
