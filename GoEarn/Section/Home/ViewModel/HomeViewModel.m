//
//  HomeViewModel.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/22.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel
//处理网络获取的数据
- (void)handleDataWithVC:(UIViewController*)VC   URLString:(NSString *)urlString parameters:(NSMutableDictionary *)parameters type:(NetworkRequestType)type WithSuccess:(void (^)(NetworkResponse *response))success failure:(void(^)(NSError *error))failure
{
    [[[AFNetworkRequest alloc]init] requestWithVC:VC URLString:urlString parameters:parameters type:type resultBlock:^(id responseObject, NSError *error) {
        if (error) {
            failure(error);
        }else
        {
            NetworkResponse *responseObj=[[NetworkResponse alloc]initWithDictionary:responseObject];            
            success(responseObj);
        }
    }];
}

@end
