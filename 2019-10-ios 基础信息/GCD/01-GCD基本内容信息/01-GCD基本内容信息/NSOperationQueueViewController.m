//
//  NSOperationQueueViewController.m
//  01-GCD基本内容信息
//
//  Created by 我演示 on 2019/10/10.
//  Copyright © 2019 我演示. All rights reserved.
//

#import "NSOperationQueueViewController.h"

@interface NSOperationQueueViewController ()

@end

@implementation NSOperationQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /// 1: 创建队列信息
    /**
     并发： 全局鬓发队列，自己创建的connecterent
      串行 ： 主队列进行处理 自己床架 serial 的信息
     
      NSOperationQueue  主队列，凡是放到住对垒执行的任务都是放在主线程中执行
     
     串行队列：  alloc linit 的执行信息，同时具有了并发和串行的功能信息
     
     
     
     ///封装操作
      添加方法到队列中
     
     */
    
    
    
    ///2: 并发队列信息
    
    
    ///3: 全局并发队列执行
    
    
    
    ///4: 订单执行
    
    
    
    /// 5: 全局并发队列信息
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    /// 最大并发数控制，在这个数据中，处理并发的数量 默认最大并发数量是 -1
    
    queue.maxConcurrentOperationCount = 3 ;
    
    /// 控制并发数量的执行 暂停 和恢复的数据处理，在单品p为yes 的时候处理
    
    /// 在为No 的时候进行处理内容信息 需要等已经执行的循环执行结束
    
    
    /// 取消操作，不可逆操作
    [queue cancelAllOperations];
    
    
    queue.suspended = YES ;
    NSInvocationOperation *opt3 = [[NSInvocationOperation alloc] init];
    
    /// 实现c多线程并发的操作信息
    
    [queue addOperation:opt3];
    

    /// 最大的并发队列数处理 最大并发数的数量处理
    
    /// 掌握对应的数据处理内容
    
    /// 创建队列
//    chuang创建

// c 创建最大的并发数量 默认最大的并发数量是 -1
    
    ///
    
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
