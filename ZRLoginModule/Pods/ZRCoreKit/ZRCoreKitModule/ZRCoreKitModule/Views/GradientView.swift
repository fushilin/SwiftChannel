//
//  GradientView.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/19.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

/// 渐变view
open class GradientView: UIView {
    
    /// 映射 layer.startPoint
    open var startPoint: CGPoint? {
        set {
            if let layer = self.layer as? CAGradientLayer, let value = newValue {
                layer.startPoint = value
            }
        }
        get {
            guard let layer = self.layer as? CAGradientLayer else { return nil }
            return layer.startPoint
        }
    }
    
    /// 映射 layer.endPoint
    open var endPoint: CGPoint? {
        set {
            if let layer = self.layer as? CAGradientLayer, let value = newValue {
                layer.endPoint = value
            }
        }
        get {
            guard let layer = self.layer as? CAGradientLayer else { return nil }
            return layer.endPoint
        }
    }
    
    /// 映射 layer.colors
    open var colors: [UIColor]? {
        set {
            if let layer = self.layer as? CAGradientLayer, let value = newValue {
                var cs = [CGColor]()
                for color in value {
                    cs.append(color.cgColor)
                }
                layer.colors = cs
            }
        }
        get {
            if let layer = self.layer as? CAGradientLayer, let colors = layer.colors as? [CGColor] {
                var cs = [UIColor]()
                for cgColor in colors {
                    cs.append(UIColor(cgColor: cgColor))
                }
                return cs
            }
            return nil
        }
    }
    
    /// 映射 layer.locations
    open var locations: [NSNumber]? {
        set {
            if let layer = self.layer as? CAGradientLayer {
                layer.locations = newValue
            }
        }
        
        get {
            guard let layer = self.layer as? CAGradientLayer else { return nil }
            return layer.locations
        }
    }
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
