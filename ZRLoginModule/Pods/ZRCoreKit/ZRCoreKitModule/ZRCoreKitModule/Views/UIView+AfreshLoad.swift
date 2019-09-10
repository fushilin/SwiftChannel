//
//  UIView+AfreshLoad.swift
//  ZRCoreKitModule
//
//  Created by Zhuorui on 2019/8/22.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import SnapKit

private var afreshLoadViewKey: String = "afreshLoadViewKey"

extension UIView {
    /// 重新加载view
    public var afreshLoadView: AfreshLoadView? {
        set {
            objc_setAssociatedObject(self, &afreshLoadViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &afreshLoadViewKey) as? AfreshLoadView)
        }
    }
    
    /// 是否显示
    public var isShowAfreshLoadView: Bool {
        guard let view = afreshLoadView else { return false }
        guard view.superview != nil else { return false }
        return true
    }
    
    
    public func showAfreshLoadView(text: String?, closure: AfreshLoadView.AfreshClosure?) {
        removeAfreshLoadView()
        let loadView = AfreshLoadView(addedTo: self, closure: nil)
        loadView.text = text
        loadView.closure = closure
        self.afreshLoadView = loadView
    }
    
    /// 移除view
    public func removeAfreshLoadView() {
        afreshLoadView?.removeFromSuperview()
        afreshLoadView = nil
    }
}


/// 重试view
open class AfreshLoadView: UIView {
    
    /// 闭包
    public typealias AfreshClosure = (()->Void)
    
    /// private img view
    lazy private var imgView: UIImageView = {
        let imageV = UIImageView(image: UIImage.ck.resourceImage("ck_afreshload"))
        addSubview(imageV)
        return imageV
    }()
    
    /// private label
    lazy private var tipsLabel: UILabel = {
        let label = UILabel(kCoreKitLoc("点击屏幕，重新加载"),
                            textColor: UIColor(hex: 0xE1E4F0),
                            font: UIFont.systemFont(ofSize: 15.0),
                            textAlignment: .center,
                            numberOfLines: 0,
                            lineBreakMode: .byTruncatingTail)
        addSubview(label)
        return label
    }()
    
    open var text: String? {
        set {
            self.tipsLabel.text = newValue ?? kCoreKitLoc("点击屏幕，重新加载")
        }
        
        get  {
            return self.tipsLabel.text
        }
    }
    
    open var closure: AfreshClosure?
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        makeSubviewConstraints()
    }
    
    convenience init(addedTo view: UIView, closure: AfreshClosure?) {
        self.init(frame: view.bounds)
        backgroundColor = view.backgroundColor
        self.closure = closure
        view.insertSubview(self, at: view.subviews.count)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 设置约束
    private func makeSubviewConstraints() {
        
        imgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50.0)
        }
        
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-20.0)
            make.top.equalTo(self.imgView.snp_bottom).offset(17.0)
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /// 点击回调
        closure?()
    }
}

