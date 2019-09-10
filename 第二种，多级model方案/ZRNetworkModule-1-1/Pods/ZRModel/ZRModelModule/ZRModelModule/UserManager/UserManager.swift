//
//  UserManager.swift
//  ZRModelModule
//
//  Created by lam on 2019/7/16.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit
import ZRBase


/// model管理器
public final class UserManager {
    /// 静态初始化
    public static let `default`: UserManager = UserManager()
    
    /// model
    public var user: UserModel = UserModel()
    
    /// 是否登录
    public var isLogon:Bool {
        return user.userId > 0 && user.token != nil && user.token!.count > 0
    }
    
    /// 是否登录过
    public var isLogged:Bool {
        return user.userId > 0
    }
    
    /// 初始化
    init() {
        self.user = fileToUserModel()
    }
    
}

extension UserManager {
    /// 保存 ,user = nil 保存当前user，非nil self.user = user 再执行缓存方法
    @discardableResult
    public func save(_ user: UserModel? = nil)-> Bool {
        if let u = user {
            self.user = u
        }
        return saveUserToFile(user: self.user)
    }
    
    /// 清理
    @discardableResult
    public func clean()-> Bool{
        self.user = UserModel()
        return self.cleanUserFile()
    }
    
    /// 登出
    public func logout() {
        self.user.token = nil
        self.save()
    }
}

fileprivate let userPath: String = SandBoxType.documents.filePath("user.archiver")
/// 储存
extension UserManager {
    
    /// 清理
    fileprivate func cleanUserFile()-> Bool {
        if LocalTools.fileExistsAtPath(userPath) {
           return LocalTools.removeItemAtPath(userPath)
        }
        return true
    }
    
    /// 本地提取user
    fileprivate func fileToUserModel()-> UserModel {
        
        let url = URL(fileURLWithPath: userPath)
        
        guard let data = try? Data(contentsOf: url) else { return UserModel() }
        
        /// 解密
        guard let deData = SecurityManager.AES128DecryptedData(data) else { return UserModel() }
        
        guard let json = String(data: deData, encoding: .utf8) else { return UserModel() }
        
        guard let user = UserModel(JSONString: json) else { return UserModel() }
        
        return user
    }
    
    /// 保存user
    fileprivate func saveUserToFile(user: UserModel)-> Bool {
        
        guard let json = user.toJSONString() else {return false}

        guard let data  = json.data(using: .utf8) else { return false }
        
        guard let enData = SecurityManager.AES128EncryptedData(data) else { return false }
        
        let url = URL(fileURLWithPath: userPath)
        do {
            try enData.write(to: url)
            return true
        } catch _ {
            return false
        }
    }
}










