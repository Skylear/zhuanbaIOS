//
//  IndustryListModel.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/28.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "IndustryListModel.h"

@implementation IndustryListModel
- (instancetype)init{
    if (self=[super init]) {
        [IndustryListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            
            return @{@"ID" : @"id"};
            
        }];
    }
    
    return self;
    
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.name forKey:@"name"];
   
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}
@end
