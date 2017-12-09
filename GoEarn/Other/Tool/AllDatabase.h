//
//  Mdatabase.h
//  CarSales_HYL
//
//  Created by chunxi on 14-7-27.
//  Copyright (c) 2014年 HYL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AllDatabaseTypeHot,
    AllDatabaseTypesystemData,
} AllDatabaseType;

@interface AllDatabase : NSObject

+(AllDatabase *)sharedAllDatabase;
 

// 插入对象
-(void)insertHistoryItem:(NSMutableArray*)artArr WithSql:(AllDatabaseType)sqlType;

-(void)removeAllHistory:(AllDatabaseType)sqlType;

-(NSMutableArray *)allHistory:(AllDatabaseType)sqlType;

@end


