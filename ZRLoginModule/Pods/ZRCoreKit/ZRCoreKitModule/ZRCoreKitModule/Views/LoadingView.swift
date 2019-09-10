//
//  LoadingView.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import SwiftHEXColors
import ZRBase

/// toast样式
public struct LoadingStyle {
    
    /// 背景颜色
    public var backgroundColor: UIColor? = UIColor(hex: 0x0,alpha: 0.65)
    
    /// 文字字体
    public var font: UIFont = UIFont.systemFont(ofSize: 17.0)
    
    /// 文字颜色
    public var textColor: UIColor? = .white
    
    /// 圆角
    public var cornerRadius: CGFloat = 10.0
    
    /// max width
    public var maxWidthScale: CGFloat = 0.8
    
    /// top botoom
    public var topBottomPadding: CGFloat = 18.0
    
    /// left right
    public var leftRightPadding: CGFloat = 16.0
    
    /// 文字和图片
    public var imageTextPadding: CGFloat = 15.0
    
    /// 动画时间
    public var duration: CFTimeInterval = 1.12
}

/// Loading view，用于界面加载，gif类型
open class LoadingView: UIView {

    /// private img view
    private lazy var loadingView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.ck.resourceImage("ck_loading")
        addSubview(imgView)
        return imgView
    }()
    
    private lazy var bgView: UIView =  {
        let view = UIImageView()
        view.backgroundColor = theme.backgroundColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = theme.cornerRadius
        insertSubview(view, at: 0)
        return view
    }()
    
    /// private label
    private lazy var tipsLabel: UILabel = {
        let lb = UILabel(kCoreKitLoc("正在加载"),
                         textColor: theme.textColor,
                         font: theme.font,
                         textAlignment: .center,
                         numberOfLines: 0,
                         lineBreakMode: .byTruncatingTail)
        addSubview(lb)
        return lb
    }()
    
    open var theme: LoadingStyle = LoadingStyle()
    
    /// 提示文案
    open var text: String? {
        set {
            self.tipsLabel.text = newValue
        }
        get {
            return self.tipsLabel.text
        }
    }
    
    /// 是否正在动画
    open var isAnimating: Bool = false
    
    /// 开始动画
    open func start() {
        if !isAnimating {
            startAnimation()
        }
    }
    
    /// w停止动画
    open func stop() {
        stopAnimation()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewFrame()
    }
    
    deinit {
//        removeObserver(self, forKeyPath: "bounds")
    }
   
}

extension LoadingView: CAAnimationDelegate {
    
    /// 进入后台
    @objc fileprivate func willEnterForegroundNotification(_ notif: Notification) {
        start()
    }
    
    /// 开启动画
    private func startAnimation() {
        loadingView.layer.removeAllAnimations()
        // 绕z轴旋转 使每次重合的位置不同
        let rotationAni = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAni.delegate = self
        rotationAni.fromValue = NSNumber(0.0)
        rotationAni.toValue = NSNumber(value: 2.0 * Double.pi)
        rotationAni.duration = theme.duration
        rotationAni.repeatCount = MAXFLOAT
        loadingView.layer.add(rotationAni, forKey: "roration")
    }
    
    /// 停止时间
    private func stopAnimation() {
        loadingView.layer.removeAllAnimations()
    }
    
    
    open func animationDidStart(_ anim: CAAnimation) {
        isAnimating = true
    }
    
    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        isAnimating = false
    }
}


extension LoadingView {
    
    private func setupSubviewFrame() {
        
        guard bounds != .zero else { return }
        
        //计算文字高度
        let maxWidth: CGFloat = bounds.width * theme.maxWidthScale
        let maxTextWidth = maxWidth - theme.leftRightPadding * 2.0
        let maxTextHeight: CGFloat = CGFloat.greatestFiniteMagnitude
        let maxTextSize = CGSize(width: maxTextWidth, height: maxTextHeight)
        
        let msgSize = tipsLabel.text?.base.size(tipsLabel.font, maxTextSize) ?? .zero
        
        var imagsSize: CGSize = .zero
        
        if let image = loadingView.image {
            imagsSize = image.size
        }
        
        let height: CGFloat = theme.topBottomPadding * 2.0 + theme.imageTextPadding + msgSize.height + imagsSize.height
        let width: CGFloat = min(max(msgSize.width, imagsSize.width) + theme.leftRightPadding * 2.0, maxWidth)
        
        var x = (bounds.width - width) / 2.0
        var y = (bounds.height - height) / 2.0
        bgView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        x = (bounds.width - imagsSize.width) / 2.0
        y = bgView.frame.minY + theme.topBottomPadding
        loadingView.frame = CGRect(origin: CGPoint(x: x, y: y), size: imagsSize)
        
        x = (bounds.width - msgSize.width) / 2.0
        y = bgView.frame.maxY - msgSize.height - theme.topBottomPadding
        tipsLabel.frame = CGRect(origin: CGPoint(x: x, y: y), size: msgSize)
    }
}
