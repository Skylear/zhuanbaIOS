//
//  MTPushTool.m
//  MIAOTUI2
//
//  Created by Beyondream on 16/6/2.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//
static NSString * const JPUSHAPPKEY = @"92322d5d43d1e820cbdf7e2a"; // 极光appKey
static NSString * const channel = @"Publish channel"; // 固定的

#ifdef DEBUG // 开发

static BOOL const isProduction = FALSE; // 极光FALSE为开发环境

#else // 生产

static BOOL const isProduction = TRUE; // 极光TRUE为生产环境

#endif

#import "MTPushTool.h"
#import "JPUSHService.h"
#import "NoticeModel.h"
#import "EBForeNotification.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h> // 这里是iOS10需要用到的框架
#endif

@interface MTPushTool ()<JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>

@end

@implementation MTPushTool

- (void)setupWithOptions:(NSDictionary *)launchOptions {
    
    // 注册apns通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) // iOS10
    {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //监听回调事件
        center.delegate = self;
        
        //iOS 10 使用以下方法注册，才能得到授权
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                              }];
        
        //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
        }];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) // iOS8, iOS9
    {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    else // iOS7
    {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
    // 如不需要使用IDFA，advertisingIdentifier 可为nil
    // 注册极光推送
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAPPKEY channel:channel apsForProduction:isProduction advertisingIdentifier:ADVERTISINGID];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            // iOS10获取registrationID放到这里了, 可以存到缓存里, 用来标识用户单独发送推送
            DLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            DLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    [JPUSHService setLogOFF];
    
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //1. 处理通知
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}
+ (void)mtApplicationWillResignActive:(UIApplication *)application {
}


+ (void)mtApplicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}


+ (void)mtApplicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [JPUSHService setBadge:0];
}


+ (void)mtApplicationDidBecomeActive:(UIApplication *)application {
    [JPUSHService setBadge:0];
}


+ (void)mtApplicationWillTerminate:(UIApplication *)application {
}

// ---------------------------------------------------------------------------------
#pragma mark - 注册推送回调获取 DeviceToken
#pragma mark -- 成功
+ (void)mtApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 注册成功
    // 极光: Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    DLog(@"**-****设置别名成功*****1");
    
    [JPUSHService setAlias:[LWAccountTool account].no callbackSelector:@selector(aliasSuccess) object:nil];
    
    DLog(@"**-****设置别名成功*****2");
    
}
-(void)aliasSuccess
{
    DLog(@"**-****设置别名成功********3");
}
#pragma mark -- 失败
+ (void)mtApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // 注册失败
    DLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// 这部分是官方demo里面给的, 也没实现什么功能, 放着以备不时之需
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
+ (void)mtApplication:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
}

+ (void)mtApplication:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    
}

+ (void)mtApplication:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    
}
#endif

// ---------------------------------------------------------------------------------
+ (void)mtApplication:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{    
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

// ---------------------------------------------------------------------------------

#pragma mark - iOS7: 收到推送消息调用
+ (void)mtApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // iOS7之后调用这个
    [JPUSHService handleRemoteNotification:userInfo];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:FRESHCENTERDATE object:nil];
    DLog(@"收到通知数据-------%@",userInfo);
    
    if (application.applicationState == UIApplicationStateInactive) {
       DLog(@"app在前台时收到通知--------");
        //系统声音弹窗
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312];
        
        //指定声音文件弹窗
        [EBForeNotification handleRemoteNotification:userInfo customSound:@"my_sound.wav"];
    }else
    {
        // 程序在前台或通过点击推送进来的会弹这个alert
        NSDictionary *userInfoDic =userInfo[@"aps"];
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        badge++;
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        NSString *title    = [NSString stringWithFormat:@"%@",userInfo[@"title"]];
        NSString *message  = [NSString stringWithFormat:@"%@",userInfoDic[@"alert"]];
        NSString *cover    = [NSString stringWithFormat:@"%@",userInfo[@"cover"]];
        NSString *link     = [NSString stringWithFormat:@"%@",userInfo[@"link"]];
        NSString *time     = [NSString stringWithFormat:@"%@",userInfo[@"time"]];
        NSString *group    = [NSString stringWithFormat:@"%@",userInfo[@"group"]];
        NSDictionary *TDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"TITLE",message,@"MESSAGE",cover,@"COVER",link,@"LINK",time,@"TIME",group,@"GROUP", nil];
        
        if ([userInfo[@"action"] isEqualToString:@"cancelTask"]||[userInfo[@"action"] isEqualToString:@"submitTask"]||[userInfo[@"action"] isEqualToString:@"completeTask"])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:CANCELTAST object:nil];
        }
        
        if ([userInfo[@"group"] isEqualToString:@"notice"]) {
            [[NoticeDataBase sharedNoticeDatabase]insertHistoryItem:TDic WithSql:NoticeTypeSend];
        }else{
            [[NoticeDataBase sharedNoticeDatabase]insertHistoryItem:TDic WithSql:NoticeTypeSystem];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YXHNOTICE" object:nil];
        //设备绑定通知
        if ([userInfo[@"action"] isEqualToString:@"bindDevice"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICERELOAD" object:nil];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SETTINGRELOAD" object:nil];
    completionHandler(UIBackgroundFetchResultNewData);
    }
}

// ---------------------------------------------------------------------------------

#pragma mark - iOS10: 收到推送消息调用(iOS10是通过Delegate实现的回调)
#pragma mark- JPUSHRegisterDelegate
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// 当程序在前台时, 收到推送弹出的通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
   
    [[NSNotificationCenter defaultCenter]postNotificationName:FRESHCENTERDATE object:nil];
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    DLog(@"-----ios10前台 通知消息%@",userInfo);
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
        NSDictionary *userInfoDic =userInfo[@"aps"];
        
        // 更新显示的徽章个数
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        badge++;
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        
        
        NSString *title    = [NSString stringWithFormat:@"%@",userInfo[@"title"]];
        NSString *message  = [NSString stringWithFormat:@"%@",  userInfoDic[@"alert"]];
        NSString *cover    = [NSString stringWithFormat:@"%@",userInfo[@"cover"]];
        NSString *link     =  [NSString stringWithFormat:@"%@",userInfo[@"link"]];
        NSString *time     = [NSString stringWithFormat:@"%@",userInfo[@"time"]];
        NSString *group    = [NSString stringWithFormat:@"%@",userInfo[@"group"]];
        NSDictionary *TDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"TITLE",message,@"MESSAGE",cover,@"COVER",link,@"LINK",time,@"TIME",group,@"GROUP", nil];
        
        if ([userInfo[@"action"] isEqualToString:@"cancelTask"]||[userInfo[@"action"] isEqualToString:@"submitTask"]||[userInfo[@"action"] isEqualToString:@"completeTask"])
        {
          [[NSNotificationCenter defaultCenter]postNotificationName:CANCELTAST object:nil];  
        }
        
        if ([userInfo[@"group"] isEqualToString:@"notice"]) {
            [[NoticeDataBase sharedNoticeDatabase]insertHistoryItem:TDic WithSql:NoticeTypeSend];
        }else{
            [[NoticeDataBase sharedNoticeDatabase]insertHistoryItem:TDic WithSql:NoticeTypeSystem];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YXHNOTICE" object:nil];
        //设备绑定通知
        if ([userInfo[@"action"] isEqualToString:@"bindDevice"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICERELOAD" object:nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SETTINGRELOAD" object:nil];
    }
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}


// 程序关闭后, 通过点击推送弹出的通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    DLog(@"-----ios10程序关闭 通知消息%@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
        NSDictionary *userInfoDic =userInfo[@"aps"];
        
        // 更新显示的徽章个数
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        badge++;
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        
        NSString *title    = [NSString stringWithFormat:@"%@",userInfo[@"title"]];
        NSString *message  = [NSString stringWithFormat:@"%@",  userInfoDic[@"alert"]];
        NSString *cover    = [NSString stringWithFormat:@"%@",userInfo[@"cover"]];
        NSString *link     =  [NSString stringWithFormat:@"%@",userInfo[@"link"]];
        NSString *time     = [NSString stringWithFormat:@"%@",userInfo[@"time"]];
        NSString *group    = [NSString stringWithFormat:@"%@",userInfo[@"group"]];
        NSDictionary *TDic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"TITLE",message,@"MESSAGE",cover,@"COVER",link,@"LINK",time,@"TIME",group,@"GROUP", nil];
        
        if ([userInfo[@"group"] isEqualToString:@"notice"]) {
            [[NoticeDataBase sharedNoticeDatabase]insertHistoryItem:TDic WithSql:NoticeTypeSend];
        }else{
            [[NoticeDataBase sharedNoticeDatabase]insertHistoryItem:TDic WithSql:NoticeTypeSystem];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YXHNOTICE" object:nil];
        //设备绑定通知
        if ([userInfo[@"action"] isEqualToString:@"bindDevice"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICERELOAD" object:nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SETTINGRELOAD" object:nil];

    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif
@end
