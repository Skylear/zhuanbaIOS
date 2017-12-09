//
//  LLShareSDKTool.m
//  LLShareSDKTool
//
//  Created by 李龙 on 16/4/7.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLShareSDKTool.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDKUI.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import "WeiboSDK.h"

@implementation LLShareSDKTool

//shareSDK KEy分享功能
static NSString *const ShareAppKey = @"18590c3939de0";
//AppID：wx0d5f6e685f117d63

//AppSecret：08a0c4b6cc9bac6f4c2936d0e0360863
//微信开放平台,申请地址:https://open.weixin.qq.com/
static NSString *const WXShareAppID = @"wx944279fc8cce7fdc";
static NSString *const WXShareAppSecret = @"c52b3364201bc5ee0896ef926a45b763";

//新浪分享:申请地址http://open.weibo.com/apps/192207424/info/basic
static NSString *const SinaShareAppKey = @"2088255147";
static NSString *const SinaShareAppSecret = @"770f4ceeeb901c53a84debf76c3a8214";
static NSString *const SinaOAuthWebAddress = @"http://m.mt.miaomiao.tm";

//腾讯开发者开发者平台,申请地址:http://open.qq.com/
static NSString *const QQShareAppID = @"1105781330";
static NSString *const QQShareAppSecret = @"ChqYmky5QCTMxFFa";

+ (void)initialize{
    
    [LLShareSDKTool registerShare];
}

#pragma mark - ShareSDK 注册
+(void)registerShare
{
    DLog(@"%s",__FUNCTION__);
    
    //registerApp 初始化SDK并且初始化第三方平台
    [ShareSDK registerApp:ShareAppKey
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                             
                         default:
                             break;
                     }
                     
                 } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeSinaWeibo:
                             //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                             [appInfo SSDKSetupSinaWeiboByAppKey:SinaShareAppKey
                                                       appSecret:SinaShareAppSecret
                                                     redirectUri:SinaOAuthWebAddress
                                                        authType:SSDKAuthTypeBoth];
                             break;
                             //微信
                         case SSDKPlatformTypeWechat:
                             [appInfo SSDKSetupWeChatByAppId:WXShareAppID
                                                   appSecret:WXShareAppSecret];
                             break;
                             //qq
                         case SSDKPlatformTypeQQ:
                             [appInfo SSDKSetupQQByAppId:QQShareAppID
                                                  appKey:QQShareAppSecret
                                                authType:SSDKAuthTypeBoth];
                             break;
                             
                         default:
                             break;
                     }
                 }
     ];
}


#pragma mark- 分享代码
+ (void)shareContentWithShareContentType:(LLShareContentType)shareContentType contentTitle:(NSString *)contentTitle contentDescription:(NSString *)contentDescription contentImage:(id)contentImage contentURL:(NSString *)contentURL showInView:(UIView *)showInView success:(void (^)())success failure:(void (^)(NSString *))failure OtherResponseStatus:(void (^)(SSDKResponseState))otherResponseStatus
{
    //0.区分分享类型
    SSDKContentType type;
    switch (shareContentType) {
        case LLShareContentTypeAuto: // 自动适配类型，视传入的参数来决定
            type = SSDKContentTypeAuto;
            break;
        case LLShareContentTypeText: //文本
            type = SSDKContentTypeText;
            break;
            
        case LLShareContentTypeImage://图片
            type = SSDKContentTypeImage;
            break;
            
        case LLShareContentTypeWebPage://网页
            type = SSDKContentTypeWebPage;
            break;
            
        case LLShareContentTypeApp: //应用
            type = SSDKContentTypeApp;
            break;
            
        case LLShareContentTypeAudio://音频
            type = SSDKContentTypeAudio;
            break;
            
        case LLShareContentTypeVideo://视频
            type = SSDKContentTypeVideo;
            break;
        case LLShareContentTypeFile://文件类型(暂时仅微信可用)
            type = SSDKContentTypeFile;
            break;
            
        default:
            break;
    }
    
    //1. 创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare]; //这个参数控制是"应用内分享(网页分享)" 还是客户端分享. 不加的话是'应用内分享(网页分享)'
    
    [shareParams SSDKSetupShareParamsByText:contentDescription
                                     images:contentImage
                                        url:[NSURL URLWithString:contentURL]
                                      title:contentTitle
                                       type:type];
    
    //2. 分享,显示分享view
    SSUIShareActionSheetController *sheet =[ShareSDK showShareActionSheet:showInView
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   DLog(@"SSDKResponseState state:%lu",(unsigned long)state);
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           //这里不填写
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           DLog(@"0");
                           success();
                           break;
                           
                       }
                       case SSDKResponseStateFail:
                       {
                           
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               
                               DLog(@"1");
                               
                               failure(@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短                                                     信。");
                               break;
                               
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                             
                               DLog(@"2");
                               failure(@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；");
                               break;
                               
                           }
                           else
                           {
                               
                               DLog(@"3");
                               failure([NSString stringWithFormat:@"%@",error]);
                               break;
                               
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           
                           DLog(@"4");
//                           otherResponseStatus(SSDKResponseStateCancel); //捕获不准确
                           break;
                           
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin)
                   {
                       DLog(@"5");
//                         failure([NSString stringWithFormat:@"%@",error]);
                       
                   }
                   
               }];
    
    
       [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)]; //这句话是取消掉 sahreSDK自带的 分享内容编辑界面
}


@end
