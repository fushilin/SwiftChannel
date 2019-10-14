//
//  HttopsTools.m
//  Swift信息
//
//  Created by 我演示 on 2019/10/14.
//  Copyright © 2019 Jerry-Fu. All rights reserved.
//

#import "HttopsTools.h"

@interface HttopsTools ()

/** 糊掉Blcok*/
@property (nonatomic,copy) void (^callBack)();


@end

@implementation HttopsTools
-(void)requestData:(void (^)())callBack {
    
    self.callBack  = callBack;
    NSLog(@"haha");
    callBack();
}

@end
