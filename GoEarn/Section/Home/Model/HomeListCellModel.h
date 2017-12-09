//
//  HomeListCellModel.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/25.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeListCellModel : NSObject
@property(nonatomic,strong)NSArray  * listing;
@property(nonatomic,strong)NSString  * no;
@property(nonatomic,strong)NSString  * count;
@property(nonatomic,strong)NSString  * end_time;
@property(nonatomic,strong)NSString  * countdown;

@property(nonatomic,strong)NSString  * img;
@property(nonatomic,strong)NSString  * money;
@property(nonatomic,strong)NSString  * status;
@property(nonatomic,strong)NSString  * title;
@end
