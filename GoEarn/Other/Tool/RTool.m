//
//  RTool.m
//  RenRen
//
//  Created by Beyondream on 16/6/15.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "RTool.h"
#import "LoginVC.h"
#import "LeadVC.h"
#import "LSLaunchAD.h"
#import "RTabBarController.h"

@interface RTool ()

@property(nonatomic,strong)UIImageView  * holdImg;

@end

@implementation RTool
/**
 *  选择根控制器
 */
+ (void)chooseRootController
{
    NSString *key = @"CFBundleVersion";
    
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    appDelegate.homeTypeArr = [NSMutableArray array];
    if (!UserDefaultObjectForKey(@"firstLogin")||[UserDefaultObjectForKey(FIRST_LODING_FAIL) intValue] ==1) {
        UserDefaultSetObjectForKey(@"1", @"firstLogin")
        [appDelegate initDataWithChoice];
    }else
    {
        NSArray *localTypeData =[NSKeyedUnarchiver unarchiveObjectWithFile:LOCALMISSIONPATH];
        BOOL missionUpDate =[UserDefaultObjectForKey(MISSIONTYPEUPDATE) boolValue];
        //banner图下按钮
        if (missionUpDate ==YES) {
            [appDelegate initDataWithChoice];
        }else
        {
            [appDelegate.homeTypeArr addObjectsFromArray:localTypeData];
            appDelegate.selectedTypeModel = appDelegate.homeTypeArr[0];
        }
    }
    
    if ([currentVersion isEqualToString:lastVersion]) {
        
        NSString *adUrl = UserDefaultObjectForKey(LOCALADURL);
        if (adUrl&&![adUrl isEqualToString:@""]) {
            [LSLaunchAD showWithWindow:KEYWINDOW
                             countTime:3
                 showCountTimeOfButton:YES
                        showSkipButton:YES
                        isFullScreenAD:NO
                        localAdImgName:nil
                              imageURL:adUrl
                            canClickAD:YES
                               aDBlock:^(BOOL clickAD) {
                                   
                                   if (clickAD) {
                                       DLog(@"点击了广告");
                                   } else {
                                       [UIApplication sharedApplication].statusBarHidden = NO;
                                       UIApplication *al = [UIApplication sharedApplication];
                                       al.delegate.window.rootViewController = [[RTabBarController alloc]init];
                                       [al.delegate.window makeKeyAndVisible];
                                   }
                               }];
        }else
        {
            [UIApplication sharedApplication].statusBarHidden = NO;
            UIApplication *al = [UIApplication sharedApplication];
            al.delegate.window.rootViewController = [[RTabBarController alloc]init];
            [al.delegate.window makeKeyAndVisible];
        }     
    }
    else  { // 新版本
        [UIApplication sharedApplication].statusBarHidden = YES;
        UIApplication *al = [UIApplication sharedApplication];
        al.delegate.window.rootViewController = [LeadVC new];
        [al.delegate.window makeKeyAndVisible];
        // 存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
      }
}
+(UIImageView*)setViewPlaceHoldImage:(CGFloat)maxY WithBgView:(UIView*)bgView
{
     UIImageView *holdimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, bgView.boundsHeight)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, maxY, SCREEN_WIDTH-100, 30)];
    label.font = Font(17);
    label.tag = 101;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"网络出错，请检查网络设置";
    label.textColor =UIColorFromRGB(0x333333);
    [holdimgView addSubview:label];
    
    UILabel *onceAgainLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, label.maxY+20, 100, 50)];
    onceAgainLab.font = Font(17);
    onceAgainLab.text = @"重新加载";
    onceAgainLab.tag = 100;
    onceAgainLab.layer.borderWidth = 1;
    onceAgainLab.layer.borderColor = COLOR_GRAY_.CGColor;
    onceAgainLab.textColor =UIColorFromRGB(0x333333);
    onceAgainLab.textAlignment = NSTextAlignmentCenter;
    [holdimgView addSubview:onceAgainLab];
   
    [bgView addSubview:holdimgView];
    return holdimgView;
    
}
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
-(void)showHoldImg
{
    self.holdImg = [[UIImageView alloc]initWithFrame:KEYWINDOW.bounds];
    
    self.holdImg.image = [UIImage imageNamed:@"LaunchImage"];
    
    [KEYWINDOW addSubview:self.holdImg];
}
-(void)hideHoldImg
{
    [self.holdImg removeFromSuperview];
}
@end
