//
//  CodeButton.m
//  MIAOTUI2
//
//  Created by tangxiaowei on 16/5/24.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import "CodeButton.h"

@implementation CodeButton

-(void)addTarget:(id)target action:(SEL)action{
    [super addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
-(void)startCountdown{
    __weak CodeButton *btn = self;
    __block int timeout=self.timeOut; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                btn.titleLabel.textAlignment = NSTextAlignmentRight;
                btn.userInteractionEnabled = YES;
            });
        }
        else
        {
            // int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示 根据自己需求设置
                // NSLog(@"____%@",strTime);
                [btn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

@end
