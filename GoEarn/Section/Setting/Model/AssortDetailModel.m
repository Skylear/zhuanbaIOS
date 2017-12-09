//
//  AssortDetailModel.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/31.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "AssortDetailModel.h"

@implementation AssortDetailModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.money forKey:@"money"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.add_time forKey:@"add_time"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.money = [aDecoder decodeObjectForKey:@"money"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.add_time = [aDecoder decodeObjectForKey:@"add_time"];
    }
    return self;
}
@end
