//
//  CommiteModel.h
//  GoEarn
//
//  Created by Beyondream on 2016/11/30.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommiteModel : NSObject

@property(nonatomic,strong) NSString * type;

@property(nonatomic,strong) NSString  * name;

@property(nonatomic,strong) NSMutableArray  * imgArr;

@property(nonatomic,strong) NSString  * textString;

@property(nonatomic,assign) CGFloat rowHeigh;

@end
