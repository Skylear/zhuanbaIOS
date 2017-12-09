//
//  NetworkResponse.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/22.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "NetworkResponse.h"

@implementation NetworkResponse
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    int flag;
    NSArray *data=nil;
    NSString *message=@"";
    NSString *cache_name = @"";
    if ([dic valueForKey:@"code"]) {
        flag=[[dic valueForKey:@"code"]intValue];
    }
    message=[dic valueForKey:@"msg"];
    
    NSDictionary *dataDic = [dic objectForKey:@"data"];;
    cache_name = [dataDic valueForKey:@"cache_name"];
    data =[dataDic valueForKey:@"List"];
    if (!data) {
        data =[dataDic valueForKey:@"list"];
    }if (!data) {           
        data = [data valueForKey:@"listing"];
    }

    return [self initWithState:flag result:data message:message withCatchName:cache_name];

}
- (NetworkResponse *)initWithState:(int)state result:(NSArray *)data message:(NSString *)message withCatchName:(NSString*)catchName
{
    self=[super init];
    if (self) {
        _status=state;
        _data=data;
        _msg=message;
        _CACHE_TYPE = catchName;
    }
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"status=%@, data=%@, message=%@",@(_status), _data,_msg];
}
@end
