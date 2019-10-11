//
//  DownLoadViewController.m
//  01-GCD基本内容信息
//
//  Created by 我演示 on 2019/10/11.
//  Copyright © 2019 我演示. All rights reserved.
//

#import "DownLoadViewController.h"

@interface DownLoadViewController ()

/**线程字典*/
@property(nonatomic,strong) NSMutableDictionary *operations;


@end

@implementation DownLoadViewController

-(NSMutableDictionary *)operations {
    if (_operations == nil) {
        _operations = [NSMutableDictionary dictionary];
        
    }
    return _operations;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSBlockOperation *download = [NSBlockOperation blockOperationWithBlock:^{
       
        /// 图片下载完成，之后回调主线程
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           /// 赋值信息
            
        }];
        
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
