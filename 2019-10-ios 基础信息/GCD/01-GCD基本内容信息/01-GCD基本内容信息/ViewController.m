//
//  ViewController.m
//  01-GCD基本内容信息
//
//  Created by 我演示 on 2019/10/10.
//  Copyright © 2019 我演示. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /**
     1： 创建并发队列信息
     */
//    dispatch_queue_t queque  = dispatch_queue_create("com.520.download", <#dispatch_queue_attr_t  _Nullable attr#>)
//

}



/**
 线程之间的通信
 GCD 的任务中心
 1： 任务
 2： 队列功能
 
 b自动把队列的z东西取出，自动执行对应的功能
 
 同步：只能在当前的线程中执行任务，不具有开启新线程的能力
 异步： 可以在新的线程中执行任务，具备开启新线程的能力
 
 dispatch_sync(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
 
 并发队列：可以让多个任务同时进行执行
 并发队列只能在异步函数下才能执行
 
 串行队列：
 
 /**
 1: 异步参数 队列
 
 2： block 在里面封装任务
 dispatch_sync(<#dispatch_queue_t  _Nonnull queue#>, ^{
 <#code#>
 })
 
 
 栅栏函数： 分割控制并发队列的执行顺序处理

 
 */


-(void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"++++");
        
    });
}


-(void) applay {
    
    /**
     1： 第一个参数： 迭代的次数
     2： 第二个参数在那个队列中执行
     3：第三个参数： block要执行的任务
     
     */
    
    dispatch_queue_t queue = dispatch_queue_create("2", DISPATCH_CURRENT_QUEUE_LABEL);
    
    dispatch_apply(10, queue, ^(size_t index) {
        
    });
    
    
    
    
}


/// 队列组信息处理
-(void)group {
    //1: 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    
    /// 开启子线程下载图片
    /// 创建并发队列信息
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0 );
    
    
    /// 先等上面的数据处理结束，再执行
    
    dispatch_group_async(group, queue, ^{
       /// 信息处理
    });
 
    
    /// 合成信息 图片合成信息
    dispatch_group_notify(group, queue, ^{
        /// 开启图片上下文
        
        // 开始绘制图片信息
        
        ///3：对信息处理
        
        ///4:根据图片上下文拿到图片处理
        
        ///5:关闭上下文、
        
        ///6: 图片信息处理
//        dispatch_async_f(<#dispatch_queue_t  _Nonnull queue#>, <#void * _Nullable context#>, <#dispatch_function_t  _Nonnull work#>)
        
    });
    
}


/**
  队列组：
 1：分别异步执行两个耗时操作，
 2： 等两个异步操作执行结束后，再回到主线程执行操作
  group
 
 
 
 */


/// 条件编译
#if __has_feature(objc_arc)

#else

#endif

@end
