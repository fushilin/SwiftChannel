//
//  Student.h
//  DEMO
//
//  Created by 我演示 on 2019/10/15.
//  Copyright © 2019 Jerry-Fu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject

/** 姓名*/
@property (nonatomic,copy) NSString *name;

/**<#type#>*/
@property(nonatomic,assign) NSInteger age ;

-(instancetype)initWithName:(NSString *)name age: (NSInteger)age ;

/// 将对象本身插入数据库
-(void)insertStudent;



@end

NS_ASSUME_NONNULL_END
