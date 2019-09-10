//
//  LoginResource.swift
//  ZRLoginModule
//
//  Created by Zhuorui on 2019/8/14.
//  Copyright © 2019 Zhuorui. All rights reserved.
//

import Foundation
import ZRBase

/// bundle name
private let loginBundleName = "Login"

// MARK: - Bundle
/// bundle
internal struct LoginResource : ResourceType {
    static var bundleName: String = loginBundleName
}

extension LoginNameSpaceWrapper where T: UIImage {
    internal static func resourceImage(_ name: String)-> UIImage? {
        return UIImage(named: name, in: Bundle.resourceBundle(LoginResource.self), compatibleWith: nil)
    }
}

// MARK: - 国际化 过问
public func LoginLoc(_ key: String) -> String {
    return LocalizedString(key, loginBundleName)
}

extension LoginNameSpaceWrapper where T: UILabel {
    internal static func resourceLabel( frame:CGRect , text: String,textColor: UIColor , textAligent: NSTextAlignment , textFont: CGFloat)-> UILabel? {
        return UILabel.init(frame: frame, text: text, textColor: textColor, textAlignment: textAligent, textFont: textFont)
        
    }
}
