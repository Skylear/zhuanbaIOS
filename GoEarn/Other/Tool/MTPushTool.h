//
//  MTPushTool.h
//  MIAOTUI2
//
//  Created by Beyondream on 16/6/2.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import <Foundation/Foundation.h>
/********************
 
 CFNetwork.framework
 CoreFoundation.framework
 CoreTelephony.framework
 SystemConfiguration.framework
 CoreGraphics.framework
 Foundation.framework
 UIKit.framework
 Security.framework
 Xcode7需要的是libz.tbd；Xcode7以下版本是libz.dylib
 Adsupport.framework (获取IDFA需要；如果不使用IDFA，请不要添加)

 
 在项目的info.plist中添加一个Key：NSAppTransportSecurity，类型为字典类型。
 然后给它添加一个NSExceptionDomains，类型为字典类型；
 把需要的支持的域添加給NSExceptionDomains。其中jpush.cn作为Key，类型为字典类型。
 每个域下面需要设置2个属性：NSIncludesSubdomains、NSExceptionAllowsInsecureHTTPLoads。 两个属性均为Boolean类型，值分别为YES、YES。

********************/
@interface MTPushTool : NSObject

// 在应用启动的时候调用
- (void)setupWithOptions:(NSDictionary *)launchOptions;

+ (void)mtApplicationWillResignActive:(UIApplication *)application;
+ (void)mtApplicationDidEnterBackground:(UIApplication *)application;
+  (void)mtApplicationWillEnterForeground:(UIApplication *)application;
+ (void)mtApplicationDidBecomeActive:(UIApplication *)application;
+ (void)mtApplicationWillTerminate:(UIApplication *)application;
+ (void)mtApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
+ (void)mtApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
+ (void)mtApplication:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;
+ (void)mtApplication:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler;
+ (void)mtApplication:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler;
+ (void)mtApplication:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;
+ (void)mtApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
