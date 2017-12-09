//
//  LocalNotificationTool.h
//  GoEarn
//
//  Created by Beyondream on 2016/11/8.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationTool : NSObject
+ (void)registerLocalNotification:(NSInteger)alertTime message:(NSString*)message;
+ (void)cancelLocalNotificationWithKey:(NSString *)key;
@end
