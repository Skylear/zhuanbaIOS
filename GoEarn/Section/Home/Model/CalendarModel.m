//
//  CalendarModel.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/25.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "CalendarModel.h"

@implementation CalendarModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.days forKey:@"days"];
    [aCoder encodeObject:self.num forKey:@"num"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.days = [aDecoder decodeObjectForKey:@"days"];
        self.num = [aDecoder decodeObjectForKey:@"num"];
    }
    return self;
}
@end
