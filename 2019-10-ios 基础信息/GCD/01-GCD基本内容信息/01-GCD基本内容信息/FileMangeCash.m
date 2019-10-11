//
//  FileMangeCash.m
//  01-GCD基本内容信息
//
//  Created by 我演示 on 2019/10/11.
//  Copyright © 2019 我演示. All rights reserved.
//

#import "FileMangeCash.h"

@implementation FileMangeCash

///沙盒缓存


/// 内容缓存


/// 数据保存在哪里

/**
Document  数据会备份，不允许存放缓存数据
Library 「 cache  perference  」 缓存信息

cache： 存放缓存数据信息


perference： 一些固定信息内容


tmp  临时文件夹，s

*/


-(instancetype)init {
    self = [super init];
    
    if (self ){
        /// cache路径
        
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        /// 缓存路径信息
        /// 拿到文件名




        NSString *fileName = @"skjdfol";
        
        /// 拼接文件全路径信息
        NSString *fullePath = [caches stringByAppendingPathComponent:fileName];
        
        
        
        /// 内容处理
        ///  写入对应的数据库
        NSData *data = [NSData dataWithContentsOfURL:@""];
        
        [data writeToFile:fullePath atomically:YES];
        
        /// 信息存放
        
        
        
    }
    return  self;
    
}

@end
