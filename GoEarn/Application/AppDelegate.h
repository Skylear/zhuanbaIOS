//
//  AppDelegate.h
//  GoEarn
//
//  Created by Beyondream on 2016/9/23.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeListCellModel.h"
#import "HomeListType.h"
#import "LocationTracker.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

//后台定位
@property (nonatomic,strong) NSTimer* openAppTimer;

//监测app下载完成的倒计时
@property (nonatomic,strong) NSTimer* appOverTimer;
//app
@property(nonatomic,strong)NSString  * urlScheme;

@property (nonatomic,strong)LocationTracker * locationTracker;
//后台定位
@property (nonatomic,strong) NSTimer* locationUpdateTimer;

@property (strong, nonatomic) UIWindow *window;

//home首页选项数组
@property(nonatomic,strong)NSMutableArray  * homeTypeArr;
//当前选中的列表类型
@property(nonatomic,strong)HomeListType  * selectedTypeModel;

//缓冲区选中列表类型
@property(nonatomic,strong)HomeListType  * nowSelectedTypeModel;

//当前选中的cell对应的model
@property(nonatomic,strong)HomeListCellModel  * selectedListModel;
//当前选中的cell 对应的url
@property(nonatomic,strong)NSString  * selectedUrl;
//倒计时时间
@property(nonatomic,strong)NSString  * timeOutString;
//是否需要上传图片
@property(nonatomic,assign)int   is_upload;

@property(nonatomic,strong)NSArray  * submitArr;

//上报接口
@property(nonatomic,strong) NSDictionary  * reportDic;

@property(nonatomic,assign)BOOL dropAgain;


//任务编号
@property(nonatomic,strong)NSString  * missionID;

//当前money排序状态
@property(nonatomic,strong)NSString *moneyup;//升序
//当前时间
@property(nonatomic,strong)NSString* timeup;//降序

@property(nonatomic,assign)NSInteger second;//下载app剩余时间
//获取系统信息
-(void)initLocalMessage;

//登录
-(void)GetUserinformationRequest;
//任务类型
-(void)initDataWithChoice;
//绑定联系人
-(void)bindingUser:(NSMutableDictionary *)Tdic;
@end

