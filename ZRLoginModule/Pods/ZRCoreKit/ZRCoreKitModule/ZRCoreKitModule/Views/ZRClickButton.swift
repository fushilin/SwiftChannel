//
//  ZRClickButton.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// 点击闭包回调 button
open class ZRClickButton: UIButton {
    
    // 按钮点击事件回调
    public typealias ZRClickClosure = (_ sender: ZRClickButton?) -> Void
    
    open var clickClosure: ZRClickClosure?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonClick(_ sender: UIButton) {
        self.clickClosure?(self)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
