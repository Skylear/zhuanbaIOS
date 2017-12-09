//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+GR.h"
#define kopacity    0.7
@implementation MBProgressHUD (GR)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.labelFont =[UIFont systemFontOfSize:16];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}
+ (void)showIndicatorWithView:(UIView *)view
{
    if (view == nil) {
        
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.opacity = kopacity;
//    hud.labelText = @"第一次加载，等待下哦～";
//    hud.labelFont =[UIFont systemFontOfSize:16];
    [hud hide:YES afterDelay:2];
    hud.removeFromSuperViewOnHide = YES;
}
+ (void)showIndicator
{
    [self showIndicatorWithView:nil];
}
//菊花转动
+ (MBProgressHUD *)showLoadMess:(NSString *)message toView:(UIView *)view complication:(ComplicationOption)option
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    
    hud.labelText=message;
    hud.labelFont =[UIFont systemFontOfSize:16];
    // 1秒之后再消失
    [hud hide:YES afterDelay:2];
    
    return hud;

}
#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view complication:(ComplicationOption)option{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    //if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.labelText = message;
//    hud.labelFont =[UIFont systemFontOfSize:16];
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    hud.mode = MBProgressHUDModeText;
    hud.opacity = kopacity;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    hud.animationType = MBProgressHUDAnimationZoom;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.5];
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showLongError:(NSString*)error
{
 
    UIView * view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = error;
    hud.labelFont =[UIFont systemFontOfSize:16];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", @"error.png"]]];
    hud.alpha = 0.6;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:3];
}
+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message complication:(ComplicationOption)option
{
    return [self showMessage:message toView:nil complication:option];
}
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message complication:nil];
}
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) {
        
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}


+ (void)hideAllHUD
{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    
    [self hideAllHUDsForView:view animated:YES];
}
@end
