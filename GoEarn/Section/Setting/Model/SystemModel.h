//
//  SystemModel.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/24.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemModel : NSObject

@property(nonatomic,strong)NSMutableArray  * cache;

@property(nonatomic,strong)NSMutableArray  * signin_score;

@property (nonatomic,strong) NSMutableArray  * cash_money_list;
@end


