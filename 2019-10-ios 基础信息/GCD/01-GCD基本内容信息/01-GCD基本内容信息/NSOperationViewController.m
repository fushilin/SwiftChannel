//
//  NSOperationViewController.m
//  01-GCD基本内容信息
//
//  Created by 我演示 on 2019/10/10.
//  Copyright © 2019 我演示. All rights reserved.
//

#import "NSOperationViewController.h"

@interface NSOperationViewController ()

@end

@implementation NSOperationViewController

/**
 高封装性
 低耦合度信息
 只要nsoperationBlock 内部的数据大于一的时候，就出现异步执行的操作
 
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSInvocationOperation *op = [[ NSInvocationOperation alloc] initWithTarget:self selector:@selector(download ) object:nil];
    
    /// 开始启动操作信息
    
    [op start];
}

-(void)download {
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        
    }];
    
    [op1 addExecutionBlock:^{
       /// 追加操作信息
        
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
