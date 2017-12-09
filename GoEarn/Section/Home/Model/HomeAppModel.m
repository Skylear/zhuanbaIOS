//
//  HomeAppModel.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/10.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "HomeAppModel.h"

@implementation HomeAppModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.link forKey:@"link"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.link = [aDecoder decodeObjectForKey:@"link"];
    }
    return self;
}
@end
