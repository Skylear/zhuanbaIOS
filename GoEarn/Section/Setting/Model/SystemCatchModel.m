//
//  SystemCatchModel.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/24.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "SystemCatchModel.h"

@implementation SystemCatchModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.CACHE_BANNER forKey:@"CACHE_BANNER"];
    [aCoder encodeObject:self.CACHE_TASK_TYPE forKey:@"CACHE_TASK_TYPE"];
    [aCoder encodeObject:self.CACHE_INDUSTRY forKey:@"CACHE_INDUSTRY"];
    [aCoder encodeObject:self.CACHE_AREA forKey:@"CACHE_AREA"];
    [aCoder encodeObject:self.CACHE_SCORE_LEVEL forKey:@"CACHE_SCORE_LEVEL"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.CACHE_BANNER = [aDecoder decodeObjectForKey:@"CACHE_BANNER"];
        self.CACHE_TASK_TYPE = [aDecoder decodeObjectForKey:@"CACHE_TASK_TYPE"];
        self.CACHE_INDUSTRY = [aDecoder decodeObjectForKey:@"CACHE_INDUSTRY"];
        self.CACHE_AREA = [aDecoder decodeObjectForKey:@"CACHE_AREA"];
        self.CACHE_SCORE_LEVEL = [aDecoder decodeObjectForKey:@"CACHE_SCORE_LEVEL"];
    }
    return self;
}
@end
