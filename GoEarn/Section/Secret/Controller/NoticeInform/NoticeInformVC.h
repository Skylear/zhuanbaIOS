//
//  NoticeInformVC.h
//  GoEarn
//
//  Created by miaomiaokeji on 2016/11/4.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NoticeType){

    NoticeSystemType,
    NoticeLocalType,
    
};


typedef void(^UReading)(NSString* isSystemOpen , NSString* isNoticeOpen);
@interface NoticeInformVC : UIViewController

@property(nonatomic,assign)NoticeType noticeType;

@property (nonatomic,strong)  UReading  ureading;
@property (nonatomic,assign) BOOL  isNotice;
@end
