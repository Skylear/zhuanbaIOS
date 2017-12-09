//
//  TimeLabel.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/11.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "TimeLabel.h"
#import "AppDelegate.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface TimeLabel()
@property(nonatomic,assign)BOOL  fromList;
@end

@implementation TimeLabel

- (id)initWithFrame:(CGRect)frame withAlign:(NSTextAlignment)align fromList:(BOOL)list{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = align;
        _fromList = list;
    }
    return self;
}
-(void)setWeb:(UIWebView *)web
{
    _web = web;
}
-(void)setTimeString:(NSString *)timeString
{
    _timeString = timeString;
}
-(void)setTimerBegain:(BOOL)timerBegain
{
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];

}
- (void)timeHeadle{
    
    self.second--;
    if (self.second==-1) {
        self.second=self.minute ==0?0:59;
        self.minute--;
        if (self.minute==-1) {
            self.minute=0;
            self.hour =0;
        }
    }

    NSString *timeOutString = [NSString stringWithFormat:@"%02ld:%02ld",(long)self.minute,(long)self.second];
    NSString * str = [NSString stringWithFormat:@"setCountdown('%@')",timeOutString];
    [_web stringByEvaluatingJavaScriptFromString:str];


    if (_fromList ==YES) {
        self.text = [NSString stringWithFormat:@"进行中%02ld:%02ld",(long)self.minute,(long)self.second];
        self.textColor = UIColorFromRGB(0xff4c61);
    }else
    {
        self.text = [NSString stringWithFormat:@"%@",self.timeString];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:self.text];
        if ([self.timeString isEqualToString:@"请在倒计时结束前完成"])
        {
            [attribute addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] range:NSMakeRange(0, 10)];
            [attribute addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] range:NSMakeRange(10, self.text.length -10)];
        }else
        {
            [attribute addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] range:NSMakeRange(0, 4)];
            [attribute addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] range:NSMakeRange(4, self.text.length -4)];
        }
        
        self.attributedText = attribute;
    }
    
    if (self.second==0 && self.minute==0 && self.hour==0) {
        [self.timer invalidate];
        self.timer = nil;
        //刷新首页 把之前app计时滞空
       AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        app.second = 0;
        app.selectedListModel = nil;
        [app.appOverTimer invalidate];
        app.appOverTimer = nil;
        [app.openAppTimer invalidate];
        app.openAppTimer = nil;
        app.is_upload = 0;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:MISSONDONENOTIFICATION object:nil];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
