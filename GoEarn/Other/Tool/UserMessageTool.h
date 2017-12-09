//
//  UserMessageTool.h
//  MiaoChat
//
//  Created by Beyondream on 16/7/19.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginModel;

@interface UserMessageTool : NSObject
/**
 *  判断是否登录
 */
+ (BOOL)isLogin;
/**
 *  保存用户信息对象
 *
 *  @param account 用户信息
 */
+ (void)saveAccount:(LoginModel *)account;

/**
 *  取出用户信息对象
 *
 *  @return 用户信息
 */
+ (LoginModel *)account;
@end
