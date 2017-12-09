//
//  CityListModel.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/29.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "CityListModel.h"

@implementation CityListModel
- (instancetype)init{
    if (self=[super init]) {
        [CityListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            
            return @{@"ID" : @"id"};
            
        }];
    }
    
    return self;
    
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.child forKey:@"child"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.child = [aDecoder decodeObjectForKey:@"child"];
    }
    return self;
}
@end
