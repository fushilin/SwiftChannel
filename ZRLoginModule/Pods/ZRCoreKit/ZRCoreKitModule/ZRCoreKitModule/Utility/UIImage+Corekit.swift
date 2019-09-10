//
//  UIImage+Corekit.swift
//  ZRCoreKitModule
//
//  Created by lam on 2019/7/18.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import UIKit



// MARK: - Color 拓展
extension UIImage {
    //用颜色生成图片
    convenience init(color: UIColor, size: CGSize = .zero) {
        let fullSize = (size != .zero ? size : CGSize(width: 1.0, height: 1.0))
        UIGraphicsBeginImageContext(fullSize)
        let path = UIBezierPath(rect: CGRect(origin: .zero, size: fullSize))
        color.set()
        path.fill()
        let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image.cgImage)!)
    }
}


extension CoreKitNameSpaceWrapper where T : UIImage {
    
    /// color 转image
    public static func imageFormColor(_ color: UIColor, size: CGSize = .zero) -> UIImage? {
        return autoreleasepool { () -> UIImage? in
            let fullSize = (size != .zero ? size : CGSize(width: 1.0, height: 1.0))
            let rect = CGRect(origin: CGPoint.zero, size: fullSize)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
            color.setFill()
            UIRectFill(rect)
            let image =  UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
            }
    }
    
    
    /// 将图片百分比缩放(不是指大小)
    public func convevt(quality: CGFloat) -> UIImage? {
        if let data = wrappedValue.jpegData(compressionQuality: quality), let photo = UIImage(data: data) {
            return photo
        }
        return nil
    }
    
    /// 将图片缩放宽高(参数自定义)
    public func reSizeImage() -> UIImage {
        //UIGraphicsBeginImageContext(reSize);
        let reSize = CGSize.init(width: 1000, height: 1000)
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale);
        wrappedValue.draw(in: CGRect.init(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    /// 将图片裁成正方形(仍可自定义)
    public func reCutImage() -> UIImage {
        let fixOrientationImage = self.fixOrientation()
        let cutFrame = CGRect.init(x: 0, y: (fixOrientationImage.size.height - fixOrientationImage.size.width) / 2, width: fixOrientationImage.size.width, height: fixOrientationImage.size.width)
        return UIImage.init(cgImage: (fixOrientationImage.cgImage?.cropping(to: cutFrame))!)
    }
    
    /// 调整图片的旋转方向   (回正)
    public func fixOrientation() -> UIImage {
        if wrappedValue.imageOrientation == .up {
            return wrappedValue
        }
        
        var transform = CGAffineTransform.identity
        
        switch wrappedValue.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: wrappedValue.size.width, y: wrappedValue.size.height)
            transform = transform.rotated(by: .pi)
            break
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: wrappedValue.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: wrappedValue.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
            
        default:
            break
        }
        
        switch wrappedValue.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: wrappedValue.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: wrappedValue.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(wrappedValue.size.width), height: Int(wrappedValue.size.height), bitsPerComponent: wrappedValue.cgImage!.bitsPerComponent, bytesPerRow: 0, space: wrappedValue.cgImage!.colorSpace!, bitmapInfo: wrappedValue.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        switch wrappedValue.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(wrappedValue.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(wrappedValue.size.height), height: CGFloat(wrappedValue.size.width)))
            break
            
        default:
            ctx?.draw(wrappedValue.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(wrappedValue.size.width), height: CGFloat(wrappedValue.size.height)))
            break
        }
        
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        
        return img
    }
}

// MARK: - UIImage便利获取 width, height
extension CoreKitNameSpaceWrapper where T : UIImage {
    public var width: CGFloat {
        return wrappedValue.size.width
    }
    
    public var height: CGFloat {
        return wrappedValue.size.height
    }
}
