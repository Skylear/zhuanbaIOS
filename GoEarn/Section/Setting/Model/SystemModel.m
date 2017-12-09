//
//  SystemModel.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/24.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "SystemModel.h"

@implementation SystemModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cache forKey:@"cache"];
    [aCoder encodeObject:self.signin_score forKey:@"signin_score"];
    [aCoder encodeObject:self.cash_money_list forKey:@"cash_money_list"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.cache = [aDecoder decodeObjectForKey:@"cache"];
        self.signin_score = [aDecoder decodeObjectForKey:@"signin_score"];
        self.cash_money_list = [aDecoder decodeObjectForKey:@"cash_money_list"];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"signin_score" : @"ScoreModel",
             @"cache" : @"SystemCatchModel"
             };
}
@end
