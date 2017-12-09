//
//  RTool.h
//  RenRen
//
//  Created by Beyondream on 16/6/15.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RTool : NSObject
/**
 *  选择根控制器
 */
+ (void)chooseRootController;
/**
 *  无网
 */
+(UIImageView*)setViewPlaceHoldImage:(CGFloat)maxY WithBgView:(UIView*)bgView;

- (UIViewController *)getCurrentVC;

-(void)showHoldImg;

-(void)hideHoldImg;

@end
