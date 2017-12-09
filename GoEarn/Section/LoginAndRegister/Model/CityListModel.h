//
//  CityListModel.h
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/29.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityListModel : NSObject

@property(nonatomic,strong)NSString  * ID;
@property(nonatomic,strong)NSString  * name;
@property (nonatomic,strong) NSMutableArray  * child;
@end
