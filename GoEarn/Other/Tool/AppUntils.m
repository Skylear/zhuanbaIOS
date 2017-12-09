//
//  AppUntils.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/22.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "AppUntils.h"
#import  <Security/Security.h>
#import "KeychainItemWrapper.h"
@implementation AppUntils

#pragma mark - 保存和读取UUID
+(NSString *)getUUID

{
    
    NSString * strUUID = (NSString *)[KeychainItemWrapper load:@"com.company.app.usernamepassword"];

    //首次执行该方法时，uuid为空
    
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);

        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef));

        //将该uuid保存到keychain
        [KeychainItemWrapper save:KEY_USERNAME_PASSWORD data:strUUID];
        
        
        
    }
    
    return strUUID;
    
}
@end
