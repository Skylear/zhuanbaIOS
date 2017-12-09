//
//  DeviceManager.m
//  GoEarn
//
//  Created by Beyondream on 2016/12/16.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "DeviceManager.h"

@implementation DeviceManager

+ (instancetype) shareInstance
{
    static DeviceManager * deviceInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceInstance = [[DeviceManager alloc]init];
    });
    return deviceInstance;
}



- (void) setHorizontal
{
    
}

@end
