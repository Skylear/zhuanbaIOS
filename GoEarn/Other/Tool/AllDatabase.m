//
//  Mdatabase.m
//  CarSales_HYL
//
//  Created by chunxi on 14-7-27.
//  Copyright (c) 2014年 HYL. All rights reserved.
//

#import "AllDatabase.h"
#import "FMDatabase.h"
#import "ArticalList.h"
#import <FMDB.h>
@implementation AllDatabase
{
    FMDatabase *_database;
}
static AllDatabase *_s=nil;

+(AllDatabase *)sharedAllDatabase{
    if (!_s ) {
        _s =[[AllDatabase alloc] init];
    }
    return _s;
}
-(id) init{
    if (self =[super init]) {
        
        NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/Last.db",NSHomeDirectory()];
        DLog(@"databasePath:%@",path);
        _database = [[FMDatabase alloc] initWithPath:path];
        if([_database open])
        {
            // 存储历史记录
            BOOL result =[_database executeUpdate:@"create table IF NOT EXISTS UserHot(id integer PRIMARY KEY AUTOINCREMENT, artID text NOT NULL, title text NOT NULL, urlStr text NOT NULL)"];
            BOOL result2 =[_database executeUpdate:@"create table IF NOT EXISTS systemData(id integer PRIMARY KEY AUTOINCREMENT, artID text NOT NULL, title text NOT NULL, urlStr text NOT NULL)"];
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
            DLog(@"allData数据库打开失败");
            
        }
        
        [_database close];
    }
    return self;
    
}


/********************** 存储历史i****************************/
-(void)insertHistoryItem:(NSMutableArray*)artArr WithSql:(AllDatabaseType)sqlType{
    [_database open];
    
        if (sqlType == AllDatabaseTypeHot ) {
            for (int i =0; i<artArr.count; i++)
            {
                ArticalList *art = artArr[i];
                //DLog(@"===========%@%@%@",art.artID,art.title,art.urlStr);
                  [_database executeUpdate:@"INSERT INTO UserHot(artID, title,urlStr) VALUES (?,?,?);",art.artID,art.title,art.urlStr];
            }
        }else
        {
            for (int i =0; i<artArr.count; i++)
            {
                ArticalList *art = artArr[i];
                //DLog(@"===========%@%@%@",art.artID,art.title,art.urlStr);
            [_database executeUpdate:@"INSERT INTO systemData(artID, title,urlStr) VALUES (?,?,?);",art.artID,art.title,art.urlStr];
            }
        }
    [_database close];
}
-(void)removeAllHistory:(AllDatabaseType)sqlType{
    [_database open];
    if (sqlType ==AllDatabaseTypeHot) {
         [_database executeUpdate:@"delete from UserHot"];
    }else{
    
         [_database executeUpdate:@"delete  from systemData"];
    }
   
    [_database close];
}

-(NSMutableArray *)allHistory:(AllDatabaseType)sqlType{
    NSMutableArray *arr =[[NSMutableArray alloc] init];
    [_database open];
    if (sqlType ==AllDatabaseTypeHot) {
          FMResultSet *set=[_database executeQuery:@"select * from UserHot"];
        while ([set next]) {
            ArticalList *art = [[ArticalList alloc]init];
            art.artID =[set stringForColumn:@"artID"];
            art.title = [set stringForColumn:@"title"];
            art.urlStr = [set stringForColumn:@"urlStr"];
            [arr addObject:art];
            
        }

    }else
    {
        FMResultSet *set=[_database executeQuery:@"select * from systemData"];
        while ([set next]) {
            ArticalList *art = [[ArticalList alloc]init];
            art.artID =[set stringForColumn:@"artID"];
            art.title = [set stringForColumn:@"title"];
            art.urlStr = [set stringForColumn:@"urlStr"];
            [arr addObject:art];
            
        }

    }

        [_database close];
    return arr;
}
@end
