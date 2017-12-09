//
//  HomeViewModel.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/22.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkResponse.h"
@interface HomeViewModel : NSObject
//处理网络获取的数据
- (void)handleDataWithVC:(UIViewController*)VC   URLString:(NSString *)urlString parameters:(NSMutableDictionary *)parameters type:(NetworkRequestType)type WithSuccess:(void (^)(NetworkResponse *response))success failure:(void(^)(NSError *error))failure;
@end
