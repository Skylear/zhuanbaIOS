//
//  CheckListModel.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/11/9.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "CheckListModel.h"

@implementation CheckListModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.img forKey:@"img"];
    [aCoder encodeObject:self.money forKey:@"money"];
    [aCoder encodeObject:self.count forKey:@"count"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.img = [aDecoder decodeObjectForKey:@"img"];
        self.money = [aDecoder decodeObjectForKey:@"money"];
        self.count = [aDecoder decodeObjectForKey:@"count"];
    }
    return self;
}

@end
