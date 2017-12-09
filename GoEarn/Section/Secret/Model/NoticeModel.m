//
//  NoticeModel.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/11/4.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModel
-(instancetype)init
{
    if (self = [super init]) {
        [HomeListCellModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"group" : @"GROUP",@"titleName":@"MESSAGE",@"timeName":@"TIME"};
        }];
    }
    return self;
}

@end
