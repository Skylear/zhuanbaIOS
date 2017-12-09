//
//  NoticeDataBase.h
//  GoEarn
//
//  Created by miaomiaokeji on 2016/11/4.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeModel.h"

typedef enum : NSUInteger {
    NoticeTypeSystem,
    NoticeTypeSend
} NoticeDatabaseType;

@interface NoticeDataBase : NSObject

+(NoticeDataBase *)sharedNoticeDatabase;


// 插入对象
-(void)insertHistoryItem:(NSDictionary*)dic WithSql:(NoticeDatabaseType)sqlType;

-(void)removeAllHistory:(NoticeDatabaseType)sqlType;

-(NSMutableArray *)allHistory:(NoticeDatabaseType)sqlType;
@end
