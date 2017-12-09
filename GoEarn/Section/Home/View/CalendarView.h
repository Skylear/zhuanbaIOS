//
//  CalendarView.h
//  GoEarn
//
//  Created by Beyondream on 2016/9/28.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarVBgView.h"

@interface Calendar : UIView

@property (nonatomic,strong)NSArray  * signRuleArr;
//set 选择日期
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UIImage *dateImg;
//年月label
@property (nonatomic, strong) UILabel *headlabel;
@property (nonatomic, strong) UIColor *headColor;

//我的数据
@property (nonatomic,strong)UIView  * myDataBg;
@property (nonatomic,strong)UILabel  * countLabel;
@property (nonatomic,strong)UILabel  * daylabel;
@property (nonatomic,strong)NSString  * countText;
@property (nonatomic,strong)NSString  * dayText;
//weekView
@property (nonatomic, strong) UIView *weekBg;
@property (nonatomic, strong) UIColor *weekDaysColor;

// 全天可用
@property (nonatomic, strong) CalendarVBgView *dayBg;
@property (nonatomic, strong) NSArray *allDaysArr;
@property (nonatomic, strong) UIColor *allDaysColor;
@property (nonatomic, assign) CGFloat *allDaysAlpha;
@property (nonatomic, strong) UIImage *allDaysImage;

// 部分时段可用
@property (nonatomic, strong) NSArray *partDaysArr;
@property (nonatomic, strong) UIColor *partDaysColor;
@property (nonatomic, assign) CGFloat *partDaysAlpha;
@property (nonatomic, strong) UIImage *partDaysImage;

// 是否只显示本月日期,默认->NO
@property (nonatomic, assign) BOOL isShowOnlyMonthDays;
//签到
-(void)logDate:(UIButton *)dayBtn;

//创建日历
- (void)createCalendarViewWith:(NSDate *)date;
/**
 *  nextMonth
 *
 *  @param date nil = 当前日期的下一个月
 */
//- (void)setNextMonth:(NSDate *)date;
- (NSDate *)nextMonth:(NSDate *)date;

/**
 *  lastMonth
 *
 *  @param date nil -> 当前日期的上一个月
 */
//- (void)setLastMonth:(NSDate *)date;
- (NSDate *)lastMonth:(NSDate *)date;

/**
 *  nextMonth and lastMonth
 */
@property (nonatomic, copy) void(^nextMonthBlock)();
@property (nonatomic, copy) void(^lastMonthBlock)();

//选择年月  -> 暂不考虑
@property (nonatomic, copy) void(^chooseMonthBlock)();

/**
 *  点击返回日期
 */
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);

- (NSInteger)day:(NSDate *)date;

@end


@protocol ByCalendarView <NSObject>
/**
 *  点击返回的日期
 */
- (void)setupToday:(NSInteger)day Month:(NSInteger)month Year:(NSInteger)year;

@end



@protocol CalendarViewDelegate <NSObject>

-(void)signToday:(BOOL)isSign;

@end


@interface CalendarView : UIView

//签到规则
@property(nonatomic,strong)NSArray  * signRuleArr;

@property (strong, nonatomic) Calendar *calendarView;
// 部分时段可用
@property (nonatomic, strong) NSArray *partDaysArr;

@property(nonatomic,assign)id<CalendarViewDelegate> delegate;

+(CalendarView*)shareInstance;
//UI
-(void)setUpCalendarView:(BOOL)isSign;

-(void)signToday;
//移除
-(void)removeCalendarView;

@end
