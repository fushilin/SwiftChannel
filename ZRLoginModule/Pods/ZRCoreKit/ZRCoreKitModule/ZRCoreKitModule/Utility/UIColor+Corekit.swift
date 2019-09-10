//
//  UIColor+Corekit.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/18.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit
import SwiftHEXColors



// MARK: - image
extension CoreKitNameSpaceWrapper where T: UIColor {
    /// 转image
    public func toImage(_ size: CGSize = .zero) -> UIImage {
        return UIImage.ck.imageFormColor(wrappedValue) ?? UIImage()
    }
}
