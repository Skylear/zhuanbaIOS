//
//  UrlHeader.h
//  GoEarn
//
//  Created by Beyondream on 2016/9/27.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#ifndef UrlHeader_h
#define UrlHeader_h
//占位图
#define placeholder_banner [UIImage imageNamed:@"placeholder_banner"]

#define placeholder_list [UIImage imageNamed:@"placeholder_list"]

#define avatar_default [UIImage imageNamed:@"avatar_default"]

#define newList_default [UIImage imageNamed:@"placeholder_newslist"]

//字体
//头部标题字体尺寸
#define head_Font iPhone6P ? 16 : 15

//内容标题尺寸
#define title_Font iPhone6P ? 18 : 15
//评论
#define comment_Font iPhone6P ? 13 : 12

//时间
#define minute_Font iPhone6P ? 13 : 12

//更多选项界面标题字体
#define detail_Head_Font iPhone6P ? 17 : 14

//更多选项字体大小
#define detail_Font iPhone6P ? 17 : 14

//广告里的字体大小
#define ad_Font iPhone6P ? 15 : 13

//广告标识符
#define  ADVERTISINGID  [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]

//测试基地址
//#define BASE_URL @"http://192.168.1.88:8888/v1/"
//基地址
#define BASE_URL @"http://zbinfo.91miaotui.com:88/v1/"

//获取文章分类
#define GETART_LIST @"promotion/getArticleCateList"
//获取文章数据

#define GETART_DATA @"promotion/getArticleList"

//获取文章详情

#define GETART_DETAIL @"promotion/getArticle"


//赚吧测试基地址
//#define KBASE_URL @"http://192.168.1.60:98"

//基地址
#define KBASE_URL @"http://api.zb.91miaotui.com"

//获取系统信息
#define GetSystemInforURL    @"/system/getInfo"

//获取轮播图列表
#define GetBannerListURL     @"/system/getBannerList"

//获取任务类型列表
#define GetTaskTypeListURL      @"/system/getTaskTypeList"

//获取任务列表
#define GetTaskListURL       @"/system/getTaskList"
//获取行业列表
#define GetIndustryListURL       @"/system/getIndustryList"
//获取区域列表
#define GetAreaListURL       @"/system/getAreaList"


//抢任务
#define GLOMTask  @"/users/glomTask"

//抢特工任务
#define FUCKAGENTMISSION @"/users/glomSpyTask"

//语音验证码
#define GetVoiceURL   @"/system/sendCode"

//获取用户
#define GetUserLoginURL        @"/users/login"
//注册用户
#define GetUserRegisterURL      @"/users/reg"
//用户签到
#define POSTUserSignInURL      @"/users/signin"
//获取本月签到数据
#define GetMonthSignInURL         @"/users/getMonthSignin"

//获取用户信息
//任务搜索上报
#define APPSEARCHREPORT   @"/users/appReport"

//提交任务
#define CommiteMission @"/users/submitAppTask"

#define CommiteAGENTMISSION @"/users/submitSpyTask"

#define GetUserInfoData   @"/users/get"
//修改用户信息
#define GetUserUpdateURL    @"/users/update"
//设置用户信息
#define GetUserSetURL   @"/users/set"
//绑定手机号
#define GetUserBindPhoneURL  @"/users/bindPhone"
//获取资产明细
#define GetUserMoneyListURL   @"/users/getMoneyLogList"

//提交商家任务
#define CommiteBussinessMission @"/users/submitMerchantTask"

//绑定微信
#define GetBindingWechatURL    @"/users/bindWechat"

//用户提现
#define GetCashURL   @"/users/getCash"
//分享好友
#define InviteFriendURL    @"/users/inviteFriends"
//获取积分等级
#define GetScoreLevelURL   @"/users/getScoreLevel"
//提交建议
#define UpdateFeedbackURL   @"/users/feedback"
//获取内容
#define GetContentUrl    @"/system/content"
//待审核
#define GetCheckTaskListUrl   @"/users/getCheckTaskList"
//取消非特工任务
#define CancelTaskURL     @"/users/cancelTask"
//取消特工任务
#define CancelSpyTaskURL     @"/users/cancelSpyTask"
//绑定推荐人
#define BingUserURL        @"/index/bindUser"
//获取提现接口信息
#define SystemGetCashInfo     @"/system/getCashInfo"

//收徒记录
#define ApprenticeListURL     @"/users/apprenticeList"

//任务上报

#define SEARCHMORE  @"searchMore"
#define OPENMORE    @"openMore"
#define UPDATEMORE  @"updateMore"


#define CANCELTAST @"cancelTask"

#define ISBACKGROUND @"isBackGround"


#define BACKINLOCAL @"backInLocal"

//绑定设备

#define CatchDevice @"/users/mobileconfig/udid.mobileconfig"

// 广告
#define GetADURL @"/system/getFirstAdver"




#endif /* UrlHeader_h */
