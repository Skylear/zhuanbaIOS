//
//  LWAccount.h
//  MIAOTUI2
//
//  Created by tangxiaowei on 16/5/24.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWAccount : NSObject<NSCoding>

@property (nonatomic, strong)NSString * no;// //用户编号＊//
@property (nonatomic, copy)NSString *avatar;//头像//
@property (nonatomic, strong)NSString *nickname;//昵称
@property (nonatomic, strong)NSString *sex;//性别
@property (nonatomic, strong)NSString *birthday;//生日
@property (nonatomic, strong)NSString *industry;//行业
@property (nonatomic, strong)NSString *city;//城市
@property (nonatomic, assign)NSInteger total_score;//成长值
@property (nonatomic, assign)NSInteger score;//积分
@property (nonatomic, strong)NSString *total_money;//总金额
@property (nonatomic, strong) NSString *today_money;//今日收益
@property (nonatomic, strong)NSString *check_money;//审核金额
@property (nonatomic, strong)NSString *money;//金额
@property (nonatomic, strong)NSString *phone;//手机号
@property (nonatomic, strong)NSString *openid;//微信unionid
@property (nonatomic, strong)NSString *device_udid;//设备uuid
@property (nonatomic,strong) NSString * device_imei;//设备imei
@property (nonatomic, strong)NSString *getCashMoney;//是否跳转
@property (nonatomic,strong) NSString  * agreement;//是否同意用户协议
@end
