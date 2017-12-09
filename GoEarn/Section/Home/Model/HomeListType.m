//
//  HomeListType.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/25.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "HomeListType.h"

@implementation HomeListType
- (instancetype)init{
    if (self=[super init]) {
        [HomeListType mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            
            return @{@"ID" : @"id"};
            
        }];
    }
    
    return self;
    
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.img forKey:@"img"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.alias forKey:@"alias"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.img = [aDecoder decodeObjectForKey:@"img"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.alias = [aDecoder decodeObjectForKey:@"alias"];
    }
    return self;
}

@end
