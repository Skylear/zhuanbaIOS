//
//  FYShuaxingHeader.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/7.
//  Copyright © 2016年 Fyus. All rights reserved.  刷新动画文件
//
#import "FYShuaxingHeader.h"

@implementation FYShuaxingHeader

-(void)prepare{
    [super prepare];
    self.backgroundColor = UIColorFromRGB(0xf2f5f7);
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:@"0000__layer"];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 0; i<=44; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"00%02d__layer",i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

@end
