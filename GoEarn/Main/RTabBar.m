//
//  RTabBar.m
//  MiaoChat
//
//  Created by Beyondream on 16/6/15.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "RTabBar.h"
@interface RTabBar ()


@end

@implementation RTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)setTabCount:(int)tabCount
{
    _tabCount = tabCount;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    //设置其他按钮的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / _tabCount;
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIView *button in self.subviews) {
        
        //如果是系统的按钮，继续执行
        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        
        CGFloat buttonX = buttonW * ((index > _tabCount -1) ? (index + 1) : index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        //索引+1
        index ++;
    }
    
}


@end
