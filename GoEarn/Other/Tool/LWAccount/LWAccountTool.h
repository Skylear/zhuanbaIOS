//
//  LWAccountTool.h
//  MIAOTUI2
//
//  Created by tangxiaowei on 16/5/24.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LWAccount;
@interface LWAccountTool : NSObject
/**
 *  判断是否登录
 */
+ (BOOL)isLogin;
/**
 *  保存用户信息对象
 *
 *  @param account 用户信息
 */
+ (void)saveAccount:(LWAccount *)account;

/**
 *  取出用户信息对象
 *
 *  @return 用户信息
 */
+ (LWAccount *)account;
@end
