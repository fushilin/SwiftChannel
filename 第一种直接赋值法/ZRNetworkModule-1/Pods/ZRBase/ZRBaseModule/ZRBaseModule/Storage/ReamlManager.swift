//
//  ReamlManager.swift
//  DYBaseModule
//
//  Created by lam on 2019/7/12.
//  Copyright © 2019 lam. All rights reserved.
//

import Foundation
import RealmSwift
import CryptoSwift


/// 数据库升级协议
public protocol RealmMigrationType {
    static func migrationRealm(_ migration: Migration, _ oldSchemaVersion: UInt64)
}


/// Realm管理器
open class RealmManager {
    
    /// 静态初始化
    public static let `default`: RealmManager = RealmManager()
    
    /// db版本号
    public var version:UInt64 = 0
    
    /// db路径
    fileprivate let path:String = SandBoxType.documents.filePath("db.realm")
    
    /// 加密必须64位
    fileprivate lazy var encryptionKey: Data? = {
        if ConfigurationManager.default.current == AppEnvironments.RELEASE {
            return ("encryption".md5() + "key".md5()).data(using: .utf8)
        } else {
            return nil
        }
    }()
    
    /// 数据库升级update
    fileprivate var migrationTypes:[RealmMigrationType.Type] = []
    
    /// 数据
    public lazy var realm:Realm =  {
        /// 获取数据
        let defaultRealm = try! Realm(configuration: realmConfiguration())
        return defaultRealm
    }()
    
    /// 获取配置信息
    fileprivate func realmConfiguration(migrationBlock: MigrationBlock? = nil)->Realm.Configuration {
        return Realm.Configuration (
            fileURL: URL(string: path)!,
            encryptionKey: encryptionKey,
            schemaVersion: version,
            migrationBlock:{ (migration, oldSchemaVersion) in
                /// 循环
                for target in self.migrationTypes {
                    target.migrationRealm(migration, oldSchemaVersion)
                }
            })
    }
    
    /// 配置url
    func congifurationRealm() {
        
        Realm.Configuration.defaultConfiguration = self.realmConfiguration()
    }
    
    public static func addMigrationType(_ target:RealmMigrationType.Type) {
        self.default.migrationTypes.append(target)
    }
}

