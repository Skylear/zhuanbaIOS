//
//  UIViewController+scrollerHidden.h
//  GoEarn
//
//  Created by Beyondream on 2016/9/23.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSUInteger, HYHidenControlOptions) {
    
    HYHidenControlOptionLeft = 0x01,
    HYHidenControlOptionTitle = 0x01 << 1,
    HYHidenControlOptionRight = 0x01 << 2,
    
};

@interface UIViewController (NavBarHidden)

- (void)setKeyScrollView:(UIScrollView *)keyScrollView scrolOffsetY:(NSString*)scrolOffsetY options:(HYHidenControlOptions)options;
- (void)setNavBarBackgroundImage:(UIImage *)navBarBackgroundImage;
/** 清除默认导航条的背景设置 */
- (void)setInViewWillAppear;
- (void)setInViewWillDisappear;
@end
