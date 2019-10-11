//
//  ConnectNSOperationViewController.m
//  01-GCD基本内容信息
//
//  Created by 我演示 on 2019/10/11.
//  Copyright © 2019 我演示. All rights reserved.
//

#import "ConnectNSOperationViewController.h"

@interface ConnectNSOperationViewController ()

@end

@implementation ConnectNSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /// 线程之间的通信
    
    ///1: 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    ///2: 下载图片
    [queue addOperationWithBlock:^{
        
        /// 调用主线程刷新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [NSThread currentThread]  显示线程
        }];
        
    }];
    
    
    NSBlockOperation *down1 =  [NSBlockOperation blockOperationWithBlock:^{
        /// 1 : 下载
        
    }];
    NSBlockOperation *down2 =  [NSBlockOperation blockOperationWithBlock:^{
        /// 1 : 下载
        
    }];
    
    
    /// 3: 信息处理结束
    NSBlockOperation *conn = [ NSBlockOperation blockOperationWithBlock:^{
       /// 主线程处理
        
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
