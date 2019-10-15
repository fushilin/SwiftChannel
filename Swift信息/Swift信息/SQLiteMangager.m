//
//  SQLiteMangager.m
//  Swift信息
//
//  Created by 我演示 on 2019/10/15.
//  Copyright © 2019 Jerry-Fu. All rights reserved.
//

#import "SQLiteMangager.h"

@implementation SQLiteMangager


static id _instance;


+(instancetype) shareInstance{
    
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance ;
    
}


@end
