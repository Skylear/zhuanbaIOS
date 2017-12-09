//
//  ArticalList.m
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/19.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import "ArticalList.h"

@implementation ArticalList

- (instancetype)init{
    if (self=[super init]) {
        [ArticalList mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            
            return @{@"artID" : @"id"};
            
        }];
    }
    
    return self;
    
}

@end
