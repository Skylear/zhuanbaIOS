//
//  NoticeDataBase.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/11/4.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "NoticeDataBase.h"
#import "FMDatabase.h"
#import "ArticalList.h"
#import <FMDB.h>
@implementation NoticeDataBase
{
    FMDatabase *_database;
}

static NoticeDataBase *_s=nil;

+(NoticeDataBase *)sharedNoticeDatabase{
    if (!_s ) {
        _s =[[NoticeDataBase alloc] init];
    }
    return _s;
}
-(id) init{
    if (self =[super init]) {
        
        NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/SYSNotice.db",NSHomeDirectory()];
        DLog(@"databasePath:%@",path);
        _database = [[FMDatabase alloc] initWithPath:path];
        if([_database open])
        {
            // 存储历史记录title,@"TITLE",message,@"MESSAGE",cover,@"COVER",link,@"LINK",time,@"TIME",group,@"GROUP", nil];
            BOOL result =[_database executeUpdate:@"create table IF NOT EXISTS SystemData(id integer PRIMARY KEY AUTOINCREMENT,TITLE text NOT NULL,MESSAGE text NOT NULL, COVER text NOT NULL, LINK text NOT NULL,TIME text NOT NULL,NOTICE text NOT NULL)"];
            BOOL result2 =[_database executeUpdate:@"create table IF NOT EXISTS NoticeData(id integer PRIMARY KEY AUTOINCREMENT,TITLE text NOT NULL,MESSAGE text NOT NULL, COVER text NOT NULL, LINK text NOT NULL,TIME text NOT NULL,NOTICE text NOT NULL)"];
            if (result) {
                DLog(@"创建成功");
            }else
            {
                DLog(@"创建失败");
            }
            
            if (result2) {
                DLog(@"创建成功");
            }else
            {
                DLog(@"创建失败");
            }
        }
        else
        {
            DLog(@"数据库打开失败");
            
        }
        
        [_database close];
        
    }
    return self;
    
}

/********************** 存储历史i****************************/
-(void)insertHistoryItem:(NSDictionary*)dic WithSql:(NoticeDatabaseType)sqlType{
    [_database open];
    // 存储历史记录title,@"TITLE",message,@"MESSAGE",cover,@"COVER",link,@"LINK",time,@"TIME",group,@"GROUP", nil];
    if (sqlType == NoticeTypeSystem ) {
       
            [_database executeUpdate:@"INSERT INTO SystemData(TITLE,MESSAGE,COVER,LINK,TIME,NOTICE) VALUES (?,?,?,?,?,?);",[NSString stringWithFormat:@"%@",dic[@"TITLE"]],[NSString stringWithFormat:@"%@",dic[@"MESSAGE"]],[NSString stringWithFormat:@"%@",dic[@"COVER"]],[NSString stringWithFormat:@"%@",dic[@"LINK"]],[NSString stringWithFormat:@"%@",dic[@"TIME"]],[NSString stringWithFormat:@"%@",dic[@"GROUP"]]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YXHSYSTEM" object:nil];
    }else
    {
            [_database executeUpdate:@"INSERT INTO NoticeData(TITLE,MESSAGE,COVER,LINK,TIME,NOTICE) VALUES (?,?,?,?,?,?);",[NSString stringWithFormat:@"%@",dic[@"TITLE"]],[NSString stringWithFormat:@"%@",dic[@"MESSAGE"]],[NSString stringWithFormat:@"%@",dic[@"COVER"]],[NSString stringWithFormat:@"%@",dic[@"LINK"]],[NSString stringWithFormat:@"%@",dic[@"TIME"]],[NSString stringWithFormat:@"%@",dic[@"GROUP"]]];
    }
    [_database close];
    
}
-(void)removeAllHistory:(NoticeDatabaseType)sqlType{
    [_database open];
    if (sqlType ==NoticeTypeSystem) {
        [_database executeUpdate:@"delete from SystemData"];
    }else{
        
        [_database executeUpdate:@"delete  from NoticeData"];
    }
    
    [_database close];
}
-(NSMutableArray *)allHistory:(NoticeDatabaseType)sqlType{
    NSMutableArray *arr =[[NSMutableArray alloc] init];
    [_database open];
    // 存储历史记录title,@"TITLE",message,@"MESSAGE",cover,@"COVER",link,@"LINK",time,@"TIME",group,@"GROUP", nil];
    if (sqlType ==NoticeTypeSystem) {
        FMResultSet *set=[_database executeQuery:@"select * from SystemData"];
        while ([set next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:[set stringForColumn:@"TITLE"] forKey:@"TITLE"];
            [dic setValue:[set stringForColumn:@"MESSAGE"] forKey:@"MESSAGE"];
            [dic setValue:[set stringForColumn:@"COVER"] forKey:@"COVER"];
            [dic setValue:[set stringForColumn:@"LINK"] forKey:@"LINK"];
            [dic setValue:[set stringForColumn:@"TIME"] forKey:@"TIME"];
            [dic setValue:[set stringForColumn:@"NOTICE"] forKey:@"NOTICE"];
            [arr addObject:dic];
            
        }
    }else
    {
        FMResultSet *set=[_database executeQuery:@"select * from NoticeData"];
        while ([set next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:[set stringForColumn:@"TITLE"] forKey:@"TITLE"];
            [dic setValue:[set stringForColumn:@"MESSAGE"] forKey:@"MESSAGE"];
            [dic setValue:[set stringForColumn:@"COVER"] forKey:@"COVER"];
            [dic setValue:[set stringForColumn:@"LINK"] forKey:@"LINK"];
            [dic setValue:[set stringForColumn:@"TIME"] forKey:@"TIME"];
            [dic setValue:[set stringForColumn:@"NOTICE"] forKey:@"NOTICE"];
            [arr addObject:dic];
        }
        
    }
    
    [_database close];
    return arr;
}
@end
