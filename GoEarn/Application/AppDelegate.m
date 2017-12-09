//
//  AppDelegate.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/23.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "BackgroundAudioPlay.h"
#import "ScoreModel.h"
#import "BackgroundAudioPlay.h"
#import "LLShareSDKTool.h"
#import "SystemModel.h"
#import "SystemCatchModel.h"
#import "HomeListType.h"
#import "RTool.h"
#import "HomeViewModel.h"
#import "MTPushTool.h"

#import <AdSupport/AdSupport.h>
#include <objc/runtime.h>
#import <CoreLocation/CoreLocation.h>
#import <Bugly/Bugly.h>

// 极光推送
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h> // 这里是iOS10需要用到的框架
#endif

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
#import "ProTool.h"

@interface AppDelegate ()<UIAlertViewDelegate>
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,strong) NSString  * mobilesiteStr;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //极光推送
    [[[MTPushTool alloc]init] setupWithOptions:launchOptions];

    [self goMain];
    
    return YES;
}

- (void)goMain
{
    NSString *IDFAStr = @"^[0\\-]*$";//ios10 匹配开启限制广告跟踪
    NSPredicate *reIDFAStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IDFAStr];
    DLog(@"advertisingid----%@",ADVERTISINGID);
    if ([reIDFAStr evaluateWithObject:ADVERTISINGID]== YES)
    {
        //弹框提示关闭限制广告跟踪
        ViewController *vc = [[ViewController alloc]init];
        self.window.rootViewController = vc;
        [self.window makeKeyAndVisible];
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"进入设置 - 隐私 - 广告 - 关闭【限制广告跟踪】" delegate:self cancelButtonTitle:nil otherButtonTitles:@"设置完成", nil];
        [alt show];

    }else
    {
        self.window.backgroundColor = [UIColor whiteColor];
        
        self.homeTypeArr = [NSMutableArray array];
        
        //微信注册
        [WXApi registerApp:@"wx944279fc8cce7fdc"];
        
        //shareSDK第三方分享
        [LLShareSDKTool initialize];
        
        //收集信息
        [Bugly startWithAppId:@"1347e26a89"];
        
        //获取广告
        [self getADUrl];
        //获取系统信息
        [self initLocalMessage];
        //获取体现信息
        [self systemGetCashInfor];
        //获取用户
        [self GetUserinformationRequest];
        
        UserDefaultSetObjectForKey(@"0", @"firstReg")
        //后台运行
        //[self gotoBackGround];
        
        ViewController *vc = [[ViewController alloc]init];
        self.window.rootViewController = vc;
        
        [self.window makeKeyAndVisible];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self goMain];
}
//登录
-(void)GetUserinformationRequest{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1" forKey:@"os"];
    [dic setValue:[AppUntils getUUID] forKey:@"uuid"];

    DLog(@"key ++=====%@",[AppUntils getUUID]);
    
    typeof(self) weakSelf = self;
    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetUserLoginURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        if (error) {
            NSString *message = @"网络异常\n请连接网络后重试";
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //获取广告
                [self getADUrl];
                
                //获取系统信息
                [self initLocalMessage];
                //获取用户
                [self GetUserinformationRequest];
            }];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            //改变message的大小和颜色
            NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
            [messageAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, message.length)];
            
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:3];
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
            
            [messageAtt addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, message.length)];
            
            [alert setValue:messageAtt forKey:@"attributedMessage"];
            
            [alert addAction:tryAgain];
            [alert addAction:cancle];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }else{
            if ([responseObject[@"code"] intValue] ==0) {
                NSArray *arr =responseObject[@"data"];
                if (arr.count==0) {
                    //返回数据为nil，注册user
                    [weakSelf GetUserIforRegisterURL];
                }
                else{
                    NSDictionary *dict =responseObject[@"data"];
                    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
                    [userDict setObject:dict[@"no"] forKey:@"no"];
                    [userDict setObject:dict[@"session"] forKey:@"session"];
                    [weakSelf secrectGerUserInfomation:userDict];
                 UserDefaultSetObjectForKey(dict[@"session"], @"LWASESSION");
                    [RTool chooseRootController];
                }
            }else
            {
               [MBProgressHUD showError:@"登陆失败，请重新打开App！"];
            }
        }}];
}

//UUID
-(void)GetUserUpdateInforRequest{
    NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
 
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:string forKey:@"session"];
    [dic setValue:ADVERTISINGID forKey:@"device_idfa"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetUserUpdateURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
         }];
}

//广告
-(void)getADUrl
{
    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetADURL] parameters:[NSMutableDictionary dictionary] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        if (error) {
            
        }else{
        if ([responseObject[@"code"] intValue] ==0) {
          NSDictionary *dataDic = responseObject[@"data"];
          UserDefaultSetObjectForKey(dataDic[@"img"], LOCALADURL)
        }
        }
    }];
}
//获取用户信息
-(void)secrectGerUserInfomation:(NSMutableDictionary*)userDic
{
    //保存用户编码与表示修改密码备用
    UserDefaultSetObjectForKey(userDic[@"no"], USER_INFO_NUM);
    UserDefaultSetObjectForKey(userDic[@"session"], USER_INFO_LOGIN)
    typeof(self) weakSelf = self;
     [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetUserInfoData] parameters:userDic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
         if (responseObject[@"data"]) {
          DLog(@"-----0000%@",responseObject[@"nickname"]);
             // 存储用户信息
             LWAccount *account = [LWAccount mj_objectWithKeyValues:responseObject[@"data"]];
             [LWAccountTool saveAccount:account];
             [weakSelf GetUserUpdateInforRequest];//上传IDF
         }
     }];
}
//注册
-(void)GetUserIforRegisterURL{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1" forKey:@"os"];
    [dic setValue:[AppUntils getUUID] forKey:@"uuid"];
    typeof(self) weakSelf = self;
    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetUserRegisterURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id   responseObject, NSError *error) {
            if ([responseObject[@"code"] intValue] ==0)
            {
                NSDictionary *dic = responseObject[@"data"];
                NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
                [userDict setObject:dic[@"no"] forKey:@"no"];
                [userDict setObject:dic[@"session"] forKey:@"session"];
                //[weakSelf bindingUser:userDict];//绑定联系人
                UserDefaultSetObjectForKey(@"1", @"firstReg")
                [weakSelf secrectGerUserInfomation:userDict];
                [weakSelf GetUserinformationRequest];
        }
    }];
}
//绑定联系人
-(void)bindingUser:(NSMutableDictionary *)Tdic{
    
    NSString *signTimestring = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *signString = [NSString generateFradomCharacter];
    [Tdic setObject:signTimestring forKey:@"signTime"];
    [Tdic setObject:signString forKey:@"signStr"];
    [Tdic removeObjectForKey:@"sign"];
    NSString *sign       = [ProTool encoingWithDic:Tdic Withcharacter:signString];
    
    NSString *no         = Tdic[@"no"];
    NSString *session    = Tdic[@"session"];
    
    NSString *SIGNURL = [NSString stringWithFormat:@"no=%@&session=%@&sign=%@&signStr=%@&signTime=%@",no,session,sign,signString,signTimestring];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",self.mobilesiteStr,BingUserURL,SIGNURL]]];
}

#pragma mark -- 受到safari传来的消息

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{

       return YES;

}
- (void)applicationWillResignActive:(UIApplication *)application {
    [MTPushTool mtApplicationWillResignActive:application];
}
# pragma mark----进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {

    UserDefaultSetObjectForKey(@"1", ISBACKGROUND)

    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgoundTask];
    }];
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(selectorToTimer) userInfo:nil repeats:YES];
    }

    [MTPushTool mtApplicationDidEnterBackground:application];
}


- (void)endBackgoundTask
{
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.timer invalidate];
        self.timer = nil;
        
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    });
}

- (void)selectorToTimer
{
    NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining == DBL_MAX) {
        DLog(@"background time remaining = undetermined");
    } else {
        DLog(@"background time remaining = %.2f", backgroundTimeRemaining);
    }
}


# pragma mark----进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (self.backgroundTask != UIBackgroundTaskInvalid) {
        [self endBackgoundTask];
    }
    [MTPushTool mtApplicationWillEnterForeground:application];
   
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]postNotificationName:BACKINLOCAL object:nil];
    [MTPushTool mtApplicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MTPushTool mtApplicationWillTerminate:application];
}

#pragma mark - 注册推送回调获取 DeviceToken
#pragma mark -- 成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [MTPushTool mtApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

#pragma mark -- 失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [MTPushTool mtApplication:application didFailToRegisterForRemoteNotificationsWithError:error];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [MTPushTool mtApplication:application didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    [MTPushTool mtApplication:application handleActionWithIdentifier:identifier forLocalNotification:notification completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    [MTPushTool mtApplication:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
}
#endif

// ---------
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [MTPushTool mtApplication:application didReceiveLocalNotification:notification];
}

#pragma mark - iOS7: 收到推送消息调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [MTPushTool mtApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}
#pragma systemInformation request
-(void)initLocalMessage{

    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetSystemInforURL] parameters:[NSMutableDictionary dictionary] type:NetworkRequestTypeGet resultBlock:^(id responseObject, NSError *error) {
            if (error)
            {
            //[MBProgressHUD showError:@"网络连接错误，请连接网络后重新启动App!"];
            }else
            {
            
            if ([responseObject[@"code"] intValue] ==0) {
                UserDefaultSetObjectForKey(@"0", FIRST_LODING_FAIL)
                NSDictionary *dic = responseObject[@"data"];
                UserDefaultSetObjectForKey(dic[@"version"], LOCALUSERVERSION)
                UserDefaultSetObjectForKey(dic[@"app_time"], APP_TIME)
                UserDefaultSetObjectForKey(dic[@"tel"], @"PHONETEL");
                self.mobilesiteStr = dic[@"mobile_site"];
                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:[SystemModel mj_objectWithKeyValues:dic]];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:SAVESystemMessage];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                SystemCatchModel *catchModel = [NSKeyedUnarchiver unarchiveObjectWithFile:SAVESystemCachePath];
                SystemCatchModel *catchNow =[SystemCatchModel mj_objectWithKeyValues:dic[@"cache"]];
                
                if ([catchNow.CACHE_BANNER intValue] >[catchModel.CACHE_BANNER intValue]) {
                    UserDefaultSetObjectForKey(@"1", BANNERUPDATE)
                }else
                {
                    UserDefaultSetObjectForKey(@"0", BANNERUPDATE)
                }
                
                if ([catchNow.CACHE_TASK_TYPE intValue] >[catchModel.CACHE_TASK_TYPE intValue]) {
                    UserDefaultSetObjectForKey(@"1", MISSIONTYPEUPDATE)
                }else
                {
                    UserDefaultSetObjectForKey(@"0", MISSIONTYPEUPDATE)
                }

                //行业
                if ([catchNow.CACHE_INDUSTRY intValue]>[catchModel.CACHE_INDUSTRY intValue]) {
                    UserDefaultSetObjectForKey(@"1", INDUSTRYLISTDATA)
                }else{
                    UserDefaultSetObjectForKey(@"0", INDUSTRYLISTDATA)
                }
                //地区
                if ([catchNow.CACHE_AREA intValue]>[catchModel.CACHE_AREA intValue]) {
                    UserDefaultSetObjectForKey(@"1", AREALISTDATA)
                }else{
                    UserDefaultSetObjectForKey(@"0", AREALISTDATA)
                }
                //积分
                if ([catchNow.CACHE_SCORE_LEVEL intValue]>[catchModel.CACHE_SCORE_LEVEL intValue]) {
                    UserDefaultSetObjectForKey(@"1", SCORELEVELDATA)
                }else{
                    UserDefaultSetObjectForKey(@"0", SCORELEVELDATA)
                }
                //存储缓存数据
                [NSKeyedArchiver archiveRootObject:[SystemCatchModel mj_objectWithKeyValues:dic[@"cache"]] toFile:SAVESystemCachePath];
            }else
            {
                UserDefaultSetObjectForKey(@"1", FIRST_LODING_FAIL)
            }
            }
            
        }];

}
//获取提现信息
-(void)systemGetCashInfor{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,SystemGetCashInfo] parameters:dic type:NetworkRequestTypeGet resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
            UserDefaultSetObjectForKey(responseObject[@"data"][@"cash_desc"], @"CASH_DESC");
            UserDefaultSetObjectForKey(responseObject[@"data"][@"money_list"], @"MONEY_LIST");
        }else{
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
    }];
}
#pragma mark ---任务类型选项
-(void)initDataWithChoice
{
    HomeViewModel *choicemodel = [[HomeViewModel alloc]init];
    typeof(self)weakSelf = self;
    [choicemodel handleDataWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetTaskTypeListURL] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"os", nil] type:NetworkRequestTypeGet WithSuccess:^(NetworkResponse *response) {
        DLog(@"respns=====%@",response);
        //存储任务类型数据
        [NSKeyedArchiver archiveRootObject:[HomeListType mj_objectArrayWithKeyValuesArray:response.data] toFile:LOCALMISSIONPATH];
        weakSelf.homeTypeArr = [HomeListType mj_objectArrayWithKeyValuesArray:response.data];
        weakSelf.selectedTypeModel =  self.homeTypeArr[0];
 
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败，请稍后再试!"];
    }];
    
}
-(void)gotoBackGround
{
    UIAlertView * alert;

    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"功能受限，请开启后台刷新, 设置 > 通用 > 后台应用刷新"
                                         delegate:nil
                                cancelButtonTitle:@"好的"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"功能受限，请开启后台刷新"
                                         delegate:nil
                                cancelButtonTitle:@"好的"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else{
        
        self.locationTracker = [[LocationTracker alloc]init];
        [self.locationTracker startLocationTracking];
        
        //Send the best location to server every 60 seconds
        //You may adjust the time interval depends on the need of your app.
        NSTimeInterval time = 60;
        self.locationUpdateTimer =
        [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(updateLocation)
                                       userInfo:nil
                                        repeats:YES];
    }
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)nowWindow {
    
    return UIInterfaceOrientationMaskPortrait;
    
}
-(void)updateLocation {
    
    DLog(@"updateLocation");
    
    [self.locationTracker updateLocationToServer];
}
@end
