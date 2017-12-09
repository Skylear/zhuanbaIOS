//
//  UserMessageTool.m
//  MiaoChat
//
//  Created by Beyondream on 16/7/19.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "UserMessageTool.h"
#define kPath       [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation UserMessageTool
+ (void)saveAccount:(LoginModel *)account
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@1 forKey:@"isLogin"];
    [defaults synchronize];
    [NSKeyedArchiver archiveRootObject:account toFile:kPath];
}
//用户信息
+ (LoginModel *)account
{
    LoginModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:kPath];
    
    if (!account) {
        
        return nil;
    }
    
    return account;
}
//判断用户是否登录
+ (BOOL)isLogin
{
    if (![self account]) {
        
        return NO;
    }
    
    return YES;
}
@end
