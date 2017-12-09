//
//  LWAccountTool.m
//  MIAOTUI2
//
//  Created by tangxiaowei on 16/5/24.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import "LWAccountTool.h"

#define kPath       [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation LWAccountTool
+ (void)saveAccount:(LWAccount *)account
{
    if (!account) {
        
//        GRError(@"用户模型为空");
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@1 forKey:@"isLogin"];
     [defaults synchronize];
    [NSKeyedArchiver archiveRootObject:account toFile:kPath];
}
//用户信息
+ (LWAccount *)account
{
    LWAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:kPath];
    
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
