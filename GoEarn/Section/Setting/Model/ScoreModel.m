//
//  ScoreModel.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/24.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "ScoreModel.h"

@implementation ScoreModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.num forKey:@"num"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.num = [aDecoder decodeObjectForKey:@"num"];
    }
    return self;
}
@end
