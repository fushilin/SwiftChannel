//
//  DouBanApiRequest.swift
//  moyo-ceshi-01
//
//  Created by 世霖mac on 2019/7/4.
//  Copyright © 2019 世霖mac. All rights reserved.
//

import Foundation

import Moya

// 请求分类信息 请求不同的类型数据，存在不同的获取信息位置

public enum DouBan{
    case channels // 获取频道列表
//    case playList(String)  //获取歌曲的信息
    
}
extension DouBan : TargetType
{
    public var baseURL: URL {
        switch self {
        case .channels:
            return URL.init(string: "https://jsonplaceholder.typicode.com/posts")!
//            return URL.init(string: "")??
//        case .playList(_) :
//            return URL.init(string: "https://jsonplaceholder.typicode.com/users/5")!
            
        default:
            break
        }
        
    }
    
//    每个请求的具体路径，详细地址应用
    
    
    public var path: String {
        switch self {
        case .channels:
//            字符串拼接为空
//            return "https://jsonplaceholder.typicode.com/posts"
            return ""
//        case .playList(_):
//            return  "https://jsonplaceholder.typicode.com/users/5"
           
        default:
            break
        }
    }
    
    //  请求的具体类型，get方法或者post的方法
    
//     注意，，注意，，注意，这个位置一定要使用moya。method的方法 或者get的方法
    public var method: Moya.Method {
        
//     return .get
        return .get
    }
    
//     这个是执行单元测试的模拟数据，只有a在单元数据的使用才能用的上
    
    public var sampleData: Data {
        return "".data(using:.utf8)!
    }
    
    //     5: 这个是请求任务事件，在这里请求人和的任务信息y，包括请求头，请求体，dict的信息等方法
    public var task: Task {
        switch self {
//        case .playList(let channel):
        case .channels:
            var parments: [String: Any] = [:]
            return .requestParameters(parameters:parments, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
        
    }
    
//    包含不包含请求头信息
    public var headers: [String : String]? {
        return nil
    }
}


// 初始化请求 信息
let DoubanProvider =  MoyaProvider<DouBan>()

