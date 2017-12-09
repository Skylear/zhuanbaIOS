//
//  ScoreLevelModel.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/11/3.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "ScoreLevelModel.h"

@implementation ScoreLevelModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"SCORENAME"];
    [aCoder encodeObject:self.score forKey:@"SCORETOTAL"];
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"SCORENAME"];
        self.score = [aDecoder decodeObjectForKey:@"SCORETOTAL"];
        
    }
    return self;
}

@end
