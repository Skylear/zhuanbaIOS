//
//  CodeButton.h
//  MIAOTUI2
//
//  Created by tangxiaowei on 16/5/24.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeButton : UIButton
@property (nonatomic) int timeOut; // 设置超时时间
-(void)startCountdown;// 倒计时
-(void)addTarget:(id)target action:(SEL)action;
@end
