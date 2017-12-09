//
//  UITabBar+Editing.h
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/17.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Editing)

- (void)showBadgeOnItemIndex:(NSInteger)index;   ///<显示小红点

- (void)hideBadgeOnItemIndex:(NSInteger)index;  ///<隐藏小红点
@end
