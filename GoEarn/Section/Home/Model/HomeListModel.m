//
//  HomeListModel.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/30.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "HomeListModel.h"
#import "HomeListCellModel.h"
@implementation HomeListModel
//-(instancetype)init
//{
//    if (self = [super init]) {
//        [HomeListCellModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//            return @{@"listingArr" : @"listing"};
//        }];
//    }
//    return self;
//}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"listing" : @"HomeListCellModel",
             };
}

@end
