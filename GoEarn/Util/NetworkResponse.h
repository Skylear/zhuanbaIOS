//
//  NetworkResponse.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/22.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkResponse : NSObject

@property(nonatomic,strong)NSString  * CACHE_TYPE;

@property(nonatomic,strong)NSString  * CACHE_NUM;

@property (nonatomic,assign) int status;//请求结果返回
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,copy) NSString *msg;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
- (NetworkResponse *)initWithState:(int)state result:(NSArray *)data message:(NSString *)message withCatchName:(NSString*)catchName;

- (NSString *)description;

@end
