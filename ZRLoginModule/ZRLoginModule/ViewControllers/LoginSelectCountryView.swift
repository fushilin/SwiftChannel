//
//  LoginTextView.swift
//  ZRLoginModule
//
//  Created by 1230 on 2019/8/15.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import UIKit

/// 选择国家和地区view
public class LoginSelectCountryView: UIView {
    
    /// 国家和地区label
    public var nameLabel: UILabel = UILabel()
    
    /// 选择城市label
    public lazy var countryLabel: UILabel = UILabel()
    
    /// 选择城市按钮
    public lazy var pressBtn: UIButton = UIButton()
    
    /// 线条line
    private lazy  var lineView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.init(hex: 0xA1A1A1)
        addSubview(view)
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(_ nameString:String , _ country: String , _ btnImageName: String) {
        self.init()
        nameLabel.textColor = .black
        nameLabel = UILabel.init(frame: CGRect.zero, text: nameString, textAlignment: .left, textFont: 16)
        /// 加粗
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(nameLabel)
        
        
        countryLabel.text = country
        countryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        countryLabel.textAlignment = .left
         addSubview(countryLabel)
        
        pressBtn.setImage(UIImage.login.resourceImage(btnImageName), for: .normal)
        pressBtn.contentHorizontalAlignment = .right
        addSubview(pressBtn)
        
        
        setUpLayout()
        
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension LoginSelectCountryView {
    private func setUpLayout(){
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(0)
            make.top.equalTo(self.snp_top).offset(0)
            make.bottom.equalTo(self.snp_bottom).offset(0)
            make.width.equalTo(80)
        }
        /// 按钮布局
        pressBtn.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(self)
            make.width.equalTo(40)
        }
        /// 右侧有一个按钮布局
        countryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp_right).offset(10.0)
            make.top.bottom.equalTo(self)
            make.right.equalTo(pressBtn.snp_left).offset(5.0)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(0.0)
            make.right.equalTo(self).offset(0.0)
            make.bottom.equalTo(self.snp_bottom).offset(0.0)
            make.height.equalTo(1.0)
        }
    }
}

extension LoginSelectCountryView {
    @objc private  func pressRightBtn() {
        print("点击右侧")
        ///也可以写成block方法
    }
}
