//
//  SubmitLoadingView.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import SwiftHEXColors
import SnapKit

/*
/// 动画view
fileprivate class SubmitAnimationView : UIView {
    
    /// 时间
    var duration:TimeInterval = 1.0
    
    /// 圆柱体宽度
    var progressWidth: CGFloat  = 5.0
    
    /// 进度条颜色
    var progressColor: UIColor =  .red //UIColor(hex: 0x388CFF)!
    
    /// 是否正在动画
    var isAnimating: Bool = false
    
    /// layer
    lazy var shapeLayer: CAShapeLayer = {
        let _shapeLayer = CAShapeLayer()
        _shapeLayer.lineCap = .round
        _shapeLayer.lineWidth = self.progressWidth;
        _shapeLayer.strokeColor = self.progressColor.cgColor
        _shapeLayer.fillColor = UIColor.clear.cgColor
        _shapeLayer.strokeStart = 0.0
        _shapeLayer.strokeEnd = 1.0
        self.layer.addSublayer(_shapeLayer)
        return _shapeLayer
    }()
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLoadProgress()
    }
    
    /// 设置进度
    func setupLoadProgress() {
        let path = UIBezierPath(ovalIn: CGRect(x: self.progressWidth, y: self.progressWidth, width: self.bounds.width - self.progressWidth * 2.0, height: self.bounds.height - self.progressWidth * 2.0))
        self.shapeLayer.path = path.cgPath
        self.resetAnimation()
    }
    
    /// 重置动画
    func resetAnimation() {
        self.layer.removeAllAnimations()
        self.shapeLayer.removeAllAnimations()
        self.addAnimation()
    }
    
    
    /// 添加动画
    func addAnimation() {
        
        // 绕z轴旋转 使每次重合的位置不同
        let rotationAni = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAni.delegate = self
        rotationAni.fromValue = NSNumber(0.0)
        rotationAni.toValue = NSNumber(value: 2.0 * Double.pi)
        rotationAni.duration = 3.0
        rotationAni.repeatCount = MAXFLOAT
        self.layer.add(rotationAni, forKey: "roration")
        
        // strokeEnd 正向画出路径
        let endAni = CABasicAnimation(keyPath: "strokeEnd")
        endAni.fromValue = NSNumber(value: 0.0)
        endAni.toValue = NSNumber(value: 1.0)
        endAni.duration = self.duration
        endAni.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        // strokeStart 反向清除路径
        let startAni = CABasicAnimation(keyPath: "strokeStart")
        startAni.fromValue = NSNumber(value: 0.0)
        startAni.toValue = NSNumber(value: 1.0)
        startAni.duration = self.duration
        startAni.beginTime = 1.0
        startAni.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        /// 增加组合动画
        let group = CAAnimationGroup()
        group.animations = [endAni, startAni]
        group.repeatCount = MAXFLOAT
        group.fillMode = .forwards
        group.duration = 2.0 * self.duration
        self.shapeLayer.add(group, forKey: "group")
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

/// MARK: - SubmitAnimationView.通知
extension SubmitAnimationView {

    /// 进入后台
    @objc fileprivate func willEnterForegroundNotification(_ notif: Notification) {
        if !self.isAnimating {
            self.setupLoadProgress()
        }
    }
}

// MARK: - SubmitAnimationView.CAAnimationDelegate
extension SubmitAnimationView : CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        self.isAnimating = true
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isAnimating = false
    }
}
*/

/// toast样式
public struct SubmitLoadingStyle {
    
    /// 背景颜色
    public var backgroundColor: UIColor? = UIColor(hex: 0x0,alpha: 0.65)
    
    /// 圆角
    public var cornerRadius: CGFloat = 5.0
    
    /// 动画时间
    public var duration: CFTimeInterval = 1.12
    
    /// size
    public var size: CGSize = CGSize(width: 73.0, height: 60.0)
    
    /// animation
    public var animationName: String = "ck_loading"
}

/// 提交loading view
open class SubmitLoadingView: UIView {
    
    /// 是否正在动画
    open var isAnimating: Bool = false
    
    /// 动画view
    private lazy var animationView: UIImageView = {
        let view = UIImageView(image: UIImage.ck.resourceImage(theme.animationName))
        addSubview(view)
        return view
    }()
    
    // 样式
    private let theme: SubmitLoadingStyle = SubmitLoadingStyle()
    
    /// 浮层
    private lazy var maskedView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = theme.backgroundColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = theme.cornerRadius
        addSubview(view)
        return view
    }()
    
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        makeSubviewConstraints()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForegroundNotification(_:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    convenience init(addedTo view: UIView) {
        self.init()
        view.insertSubview(self, at: view.subviews.count)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        start()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /// 开始动画
    open func start() {
        if !isAnimating {
            startAnimation()
        }
    }
    
    /// 停止动画
    open func stop() {
        stopAnimation()
    }
    
    /// 设置约束
    private func makeSubviewConstraints() {
        
        maskedView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(self.theme.size)
        }
        
        animationView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}

extension SubmitLoadingView: CAAnimationDelegate {
    
    /// 进入后台
    @objc fileprivate func willEnterForegroundNotification(_ notif: Notification) {
       start()
    }
    
    /// 开启动画
    private func startAnimation() {
        animationView.layer.removeAllAnimations()
        // 绕z轴旋转 使每次重合的位置不同
        let rotationAni = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAni.delegate = self
        rotationAni.fromValue = NSNumber(0.0)
        rotationAni.toValue = NSNumber(value: 2.0 * Double.pi)
        rotationAni.duration = theme.duration
        rotationAni.repeatCount = MAXFLOAT
        animationView.layer.add(rotationAni, forKey: "roration")
    }
    
    /// 停止时间
    private func stopAnimation() {
        animationView.layer.removeAllAnimations()
    }
    
    
    open func animationDidStart(_ anim: CAAnimation) {
        isAnimating = true
    }
    
    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        isAnimating = false
    }
}
