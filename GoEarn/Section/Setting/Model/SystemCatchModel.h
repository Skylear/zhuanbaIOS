//
//  SystemCatchModel.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/24.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemCatchModel : NSObject
//轮播图缓存
@property(nonatomic,strong)NSString  * CACHE_BANNER;
//任务类型缓存
@property(nonatomic,strong)NSString  * CACHE_TASK_TYPE;


//行业列表
@property (nonatomic,strong) NSString  * CACHE_INDUSTRY;
//地区列表
@property (nonatomic,strong) NSString  * CACHE_AREA;
//积分等级
@property (nonatomic,strong) NSString  * CACHE_SCORE_LEVEL;

@end
