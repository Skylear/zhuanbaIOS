//
//  TimeLabel.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/11.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLabel : UILabel
@property(nonatomic,strong)UIWebView  * web;
@property (nonatomic,assign)NSInteger second;
@property (nonatomic,assign)NSInteger minute;
@property (nonatomic,assign)NSInteger hour;
@property(nonatomic,assign)BOOL timerBegain;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic,strong)NSString *timeString;
- (id)initWithFrame:(CGRect)frame withAlign:(NSTextAlignment)align fromList:(BOOL)list;
@end
