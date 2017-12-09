//
//  ArticalModel.m
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/20.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import "ArticalModel.h"

@implementation ArticalModel
- (instancetype)init{
    if (self=[super init]) {
        [ArticalModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            
            return @{@"artID" : @"id"};
            
        }];
    }
    
    return self;
    
}
@end
