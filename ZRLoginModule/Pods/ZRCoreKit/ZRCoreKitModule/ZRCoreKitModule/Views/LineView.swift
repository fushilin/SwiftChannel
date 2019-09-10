//
//  LineView.swift
//  ZRCoreKitModule
//
//  Created by Zhuorui on 2019/7/25.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import SwiftHEXColors

/// 线view
open class LineView: UIImageView {
    
    /// 颜色
    open var lineColor: UIColor? {
        set {
            self.backgroundColor = newValue
        }
        
        get {
            return self.backgroundColor
        }
    }
    
    /// 便利初始化
    public convenience init(_ lineHex: Int) {
        self.init()
        self.backgroundColor = UIColor(hex: lineHex)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
