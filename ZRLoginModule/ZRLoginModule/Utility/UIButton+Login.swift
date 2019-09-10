//
//  Extension.swift
//  ZRloginController
//
//  Created by 1230 on 2019/8/15.
//  Copyright © 2019 1230. All rights reserved.
//

import UIKit
import ZRCoreKit

/// 自定义btn 扩展
extension UIButton {
    public convenience init(title: String , textColor: UIColor? ,textfont: UIFont?, state: UIControl.State = .normal  ){
     self.init(type:.custom)
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = textfont
    }
}
