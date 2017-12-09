//
//  LocalNotificationTool.m
//  GoEarn
//
//  Created by Beyondream on 2016/11/8.
//  Copyright © 2016年 Beyondream. All rights reserved.
//
#import <UserNotifications/UserNotifications.h>
#import "LocalNotificationTool.h"
#import "EBForeNotification.h"
@implementation LocalNotificationTool
// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime message:(NSString*)message{
    //普通弹窗(系统声音)
    [EBForeNotification handleRemoteNotification:@{@"aps":@{@"alert":message}} soundID:1312];
    /*
    if ([[UIDevice currentDevice].systemVersion floatValue]>=10) {
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        // 创建一个本地通知
        UNMutableNotificationContent *content_1 = [[UNMutableNotificationContent alloc] init];
        content_1.badge = [NSNumber numberWithInteger:1];
        content_1.body = [NSString localizedUserNotificationStringForKey:message arguments:nil];
        content_1.sound = [UNNotificationSound defaultSound];
        // 设置触发时间
        UNTimeIntervalNotificationTrigger *trigger_1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
        // 创建一个发送请求
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
        content:content_1 trigger:trigger_1];
        
        //添加推送成功后的处理！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            DLog(@"-----");
        }];
      
    }else
        {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    
    DLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = [NSDate date];
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    
    // 通知内容
    notification.alertBody =  message;
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"app下载完成，请打开试完！" forKey:@"key"];
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSDayCalendarUnit;
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
   }
     */
}
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;  
            }  
        }  
    }  
}
@end
