//
//  SQLiteManger.m
//  DEMO
//
//  Created by 我演示 on 2019/10/15.
//  Copyright © 2019 Jerry-Fu. All rights reserved.
//

#import "SQLiteManger.h"

@implementation SQLiteManger
static id _instance ;

+(instancetype)shareInstance {

    
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
    
}

-(BOOL)openDB {
    /// 数据库文件存放的路径
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] ;
    
    filePath = [filePath stringByAppendingPathComponent:@"demo.sqlite"] ;
    
    /// 打开一个数据库类型
//    sqlite3

    return  YES;
}
-(BOOL)createTable {
    
    
    return  YES;
}

@end
