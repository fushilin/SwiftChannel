//
//  UIDevice+Corekit.swift
//  ZRCoreKitModule
//
//  Created by Zhuorui on 2019/8/19.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit

public enum DeviceWidthType: CGFloat {
    /// 设备320的寛 4,4s,5,5s,5se,5c
    case _320 = 320.0
    
    /// 设备375的寛 6,6s,7,8,x,xs
    case _375 = 375.0
    
    /// 设备414的寛 6p,6sp,7p,8p,xr,xs max
    case _414 = 414.0
}


public enum DeviceHeightType: CGFloat {
    /// 设备480的高  4,4s,
    case _480 = 480.0
    
    /// 设备568的高 5,5s,5se,5c
    case _568 = 568.0
    
    /// 设备667的高 6,6s,7,8
    case _667 = 667.0
    
    /// 设备736的高 6p,6sp,7p,8p
    case _736 = 736.0
    
    /// 设备812的高 x,xs
    case _812 = 812.0
    
    /// 设备896的高度 xr max
    case _896 = 896.0
}

public struct DeviceSizeType {
    
    var width: DeviceWidthType
    
    var height: DeviceHeightType
}

//// 设备320的寛 4,4s,5,5s,5se,5c
//public let kDEVICE_WIDTH_320: CGFloat  = 320.0
//
//// 设备375的寛 6,6s,7,8,x,xs
//public let kDEVICE_WIDTH_375: CGFloat  = 375.0
//
//// 设备414的寛 6p,6sp,7p,8p,xr,xs max
//public let kDEVICE_WIDTH_414: CGFloat  = 414.0
//
//// 设备480的高  4,4s,
//public let kDEVICE_HEIGHT_480: CGFloat  = 480.0
//
//// 设备568的高 5,5s,5se,5c
//public let kDEVICE_HEIGHT_568: CGFloat  = 568.0
//
//// 设备667的高 6,6s,7,8
//public let kDEVICE_HEIGHT_667: CGFloat  = 667.0
//
//// 设备736的高 6p,6sp,7p,8p
//public let kDEVICE_HEIGHT_736: CGFloat  = 736.0
//
//// 设备812的高 x,xs
//public let kDEVICE_HEIGHT_812: CGFloat  = 812.0
//
///// 设备896的高度 xr max
//public let kDEVICE_HEIGHT_896: CGFloat  = 896.0


// MARK: - UIDevice
extension CoreKitNameSpaceWrapper where T: UIDevice {
    
    /// 设备Size
    public static var size: CGSize {
        return UIScreen.ck.mainSize
    }
    
    /// 设备宽
    public static var width: CGFloat {
        return size.width
    }
    
    /// 设备高
    public static var height: CGFloat {
        return size.height
    }
    
    /// 导航条高度
    public static var navigationBarHeight: CGFloat {
        return 44.0
    }
    
    /// tabbar高度
    public static var tabbarHeight: CGFloat {
        return 49.0
    }
    
    /// 状态栏高度
    public static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    /// home bar
    public static var homeBarHeight: CGFloat {
        return 34.0
    }
    
    /// home 偏移
    public static var homeOffet: CGFloat {
        return isXLater ? homeBarHeight : 0.0
    }
    
    
    /// 设备宽
    public static var widthType: DeviceWidthType? {
        return DeviceWidthType(rawValue: width)
    }
    
    /// 设备高
    public static var heightType: DeviceHeightType? {
        return DeviceHeightType(rawValue: height)
    }
    
    ///
    public static var sizeType: DeviceSizeType? {
        guard let width = widthType, let height = heightType else { return nil }
        return DeviceSizeType(width: width, height: height)
    }
    
    /// 宽度缩放适配 ,以4.7寸为基准
    public func adaptationWidth(_ width: CGFloat) -> CGFloat {
        return width / DeviceWidthType._375.rawValue  * UIDevice.ck.width
    }
    
    /// 高度缩放适配,以4.7寸为基准
    public func adaptationHeight(_ height: CGFloat) -> CGFloat {
        return height / DeviceHeightType._667.rawValue  * UIDevice.ck.height
    }
    
    //// 字体SIZE适配 , 以4.7寸为基准
    public func adaptationFontSize(_ size: CGFloat) -> CGFloat {
        return adaptationWidth(size)
    }
    
    /// 是否iPhone x 以后的机型，x，xs，xsr，xs max
    public static var isXLater: Bool {
        guard width >= DeviceWidthType._375.rawValue, height >= DeviceHeightType._812.rawValue  else {
            return false
        }
        return true
    }
    
    /// 线像素
    public func linePixels(_ height: CGFloat) -> CGFloat {
        return height / UIScreen.main.scale
    }
}
