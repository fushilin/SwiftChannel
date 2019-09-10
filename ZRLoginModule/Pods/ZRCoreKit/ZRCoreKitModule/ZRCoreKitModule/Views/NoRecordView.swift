//
//  NoRecordView.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import SnapKit

/// 暂无记录view
open class NoRecordView: UIView {
    
    /// 暂无记录文案
    open var tips: String? {
        set {
            self.tipsLabel.text = newValue
        }
        get  {
            return self.tipsLabel.text
        }
    }
    
    /// label
    lazy private var tipsLabel: UILabel = {
        let lb = UILabel(kCoreKitLoc("暂无记录"), textColor: .red,font: UIFont.systemFont(ofSize: 14.0), textAlignment: .center)
        self.addSubview(lb)
        
        lb.snp.makeConstraints({ (make: ConstraintMaker) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        
        return lb
    }()
    
    /// image
    private var tipsImgView: UIImageView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        _ = self.tipsLabel
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
