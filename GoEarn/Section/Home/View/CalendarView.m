//
//  CalendarView.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/28.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "CalendarView.h"
#import "ScoreModel.h"
#import "SystemModel.h"
#import "HomeViewModel.h"
#import "CalendarModel.h"
#import "HomeVC.h"
static CalendarView *calendar = nil;

@interface CalendarView ()

@property(nonatomic,strong)UIButton  * closeBtn;
@end

@implementation CalendarView

+(CalendarView*)shareInstance
{
    if (!calendar) {
        calendar = [[CalendarView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return calendar;
}

//增加锁
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        if (!calendar) {
            calendar = [super allocWithZone:zone];
        }
    }
    return calendar;
}
//实现copy协议需要实现NSCopying协议
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void)setUpCalendarView:(BOOL)isSign
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    self.calendarView = [[Calendar alloc] initWithFrame:CGRectMake(15, 68, SCREEN_WIDTH - 30,SCREEN_HEIGHT - 68-88)];
    NSData *localData = [[NSUserDefaults standardUserDefaults]valueForKey:SAVESystemMessage];
    SystemModel *systemModel = [NSKeyedUnarchiver unarchiveObjectWithData:localData];
    self.calendarView.signRuleArr = systemModel.signin_score;
    //本地签到数据
    CalendarModel *calendar = [NSKeyedUnarchiver unarchiveObjectWithFile:CALENDARDATAPATH];
    self.calendarView.partDaysArr = [calendar.days componentsSeparatedByString:@","];
    self.calendarView.date = [NSDate date];
    [self addSubview:self.calendarView];
   // self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
    //    DLog(@"%li-%li-%li", (long)year,(long)month,(long)day);
//    if (isSign ==YES) {
//        
//    }

   // };
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"checkin_close"] forState:UIControlStateNormal];
    [self.closeBtn sizeToFit];
    self.closeBtn.center = CGPointMake(SCREEN_WIDTH/2, self.calendarView.maxY +23*SCREEN_POINT +self.closeBtn.boundsHeight/2 );
    [self.closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBtn];
    
    [KEYWINDOW addSubview:self];
}
-(void)signToday
{
    __weak typeof(self) weakSelf = self;
    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,POSTUserSignInURL] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no", nil] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        if (error) {
            [MBProgressHUD showError:@"请求失败，请稍后再试!"];
        }else
        {
            if ([responseObject[@"code"] intValue] ==0) {
                [MBProgressHUD showSuccess:responseObject[@"msg"]];
                // 重新获取签到数据
                [[[HomeVC alloc] init] initSignData];
                
                CalendarModel *calendar = [NSKeyedUnarchiver unarchiveObjectWithFile:CALENDARDATAPATH];
                weakSelf.calendarView.dayText = calendar.num;
                calendar.days = [NSString stringWithFormat:@"%@%@%ld",calendar.days,@",",[weakSelf.calendarView day:[NSDate date]]];
                //存储任务类型数据
                [NSKeyedArchiver archiveRootObject:calendar toFile:CALENDARDATAPATH];
                
                if ([weakSelf.delegate respondsToSelector:@selector(signToday:)]) {
                    [weakSelf.delegate signToday:YES];
                }
            }else
            {
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
        }
    }];
}
-(void)closeClick:(UIButton*)sender
{
    [self removeCalendarView];
}
-(void)removeCalendarView
{
    [self removeFromSuperview];
}

@end



@interface Calendar ()

@property (nonatomic, strong) NSMutableArray *daysArray;

@end

@implementation Calendar
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xFF4C61);
        self.layer.cornerRadius = 10.0*SCREEN_POINT;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setupNextAndLastMonthView {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"brn_left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    leftBtn.tag = 1;
    leftBtn.frame = CGRectMake(10, 10, 20, 20);
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"btn_right"] forState:UIControlStateNormal];
    rightBtn.tag = 2;
    [rightBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    rightBtn.frame = CGRectMake(self.frame.size.width - 30, 10, 20, 20);
}

- (void)nextAndLastMonth:(UIButton *)button {
    if (button.tag == 1) {
        if (self.lastMonthBlock) {
            self.lastMonthBlock();
        }
    } else {
        if (self.nextMonthBlock) {
            self.nextMonthBlock();
        }
    }
}

#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    [self createCalendarViewWith:_date];
}

- (void)createCalendarViewWith:(NSDate *)date{
    
    CalendarModel *calendar = [NSKeyedUnarchiver unarchiveObjectWithFile:CALENDARDATAPATH];
    
    // 1.year month
    self.headlabel = [[UILabel alloc] init];
    self.headlabel.text     = [NSString stringWithFormat:@"%li年%li月",(long)[self year:date],(long)[self month:date]];
    self.headlabel.font     = [UIFont systemFontOfSize:17];
    self.headlabel.frame           = CGRectMake(0, 0, self.boundsWidth, 60*SCREEN_POINT);
    self.headlabel.textAlignment   = NSTextAlignmentCenter;
    self.headlabel.textColor = self.headColor;
    [self addSubview: self.headlabel];
    
    
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.backgroundColor = [UIColor clearColor];
    headBtn.frame = self.headlabel.frame;
    [headBtn addTarget:self action:@selector(chooseMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:headBtn];
    
    //我的数据
    self.myDataBg = [[UIView alloc]initWithFrame:CGRectMake(0, self.headlabel.maxY, self.boundsWidth, 45*SCREEN_POINT)];
    self.myDataBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.myDataBg];
    
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (self.boundsWidth - 20)/2, self.myDataBg.boundsHeight)];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    [self.myDataBg addSubview:self.countLabel];
    
    self.daylabel = [[UILabel alloc]initWithFrame:CGRectMake(self.countLabel.maxX +20, 0, (self.boundsWidth - 20)/2, self.myDataBg.boundsHeight)];
    self.daylabel.textAlignment = NSTextAlignmentLeft;
    [self.myDataBg addSubview:self.daylabel];
    
    self.countText = [NSString stringWithFormat:@"%ld",[LWAccountTool account].score];
    self.dayText = calendar.num;
    //两个大椭圆
    
    UIImageView *circleImgL = [[UIImageView alloc]init];
    circleImgL.image = [UIImage imageNamed:@"checkin_date_dot"];
    [circleImgL sizeToFit];
    circleImgL.center = CGPointMake(56*SCREEN_POINT -circleImgL.boundsWidth/2, self.headlabel.maxY);
    [self addSubview:circleImgL];
    
    UIImageView *circleImgR = [[UIImageView alloc]init];
    circleImgR.image = [UIImage imageNamed:@"checkin_date_dot"];
    [circleImgR sizeToFit];
    circleImgR.center = CGPointMake(SCREEN_WIDTH -78*SCREEN_POINT +circleImgL.boundsWidth/2, self.headlabel.maxY);
    [self addSubview:circleImgR];
    
    // 2.weekday
    NSArray *array = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    self.weekBg = [[UIView alloc] init];
    self.weekBg.backgroundColor = [UIColor whiteColor];
    self.weekBg.frame = CGRectMake(0, CGRectGetMaxY(self.myDataBg.frame), self.frame.size.width, 25*SCREEN_POINT);
    [self addSubview:self.weekBg];
    
    CGFloat weekBgWidth = (self.boundsWidth - 20)/7;
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(10+weekBgWidth * i, 0, weekBgWidth, 25*SCREEN_POINT);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = UIColorFromRGB(0xfafafa);
        week.textColor       = self.weekDaysColor;
        [self.weekBg addSubview:week];
    }
    //day
    
    self.dayBg = [[CalendarVBgView alloc]initWithFrame:CGRectMake(0, _weekBg.maxY, self.boundsWidth, self.boundsHeight - 107*SCREEN_POINT-_weekBg.maxY -5)];
    self.dayBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.dayBg];
    
    self.daysArray = [NSMutableArray arrayWithCapacity:42];

    CGFloat itemW     = (self.frame.size.width -20) / 7;
    CGFloat btnW  = (self.boundsHeight - self.weekBg.maxY - 108*SCREEN_POINT )/7;
    CGFloat space = itemW - btnW;
    
    
    //奖励规则
    UIView *ruleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.dayBg.maxY, self.boundsWidth, self.boundsHeight - self.dayBg.maxY)];
    ruleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:ruleView];
    
    UIImageView * xingImg = [[UIImageView alloc]initWithFrame:CGRectMake(space/2 +15, 12, 15, 15)];
    xingImg.image = [UIImage imageNamed:@"checkin_rule"];
    [ruleView addSubview:xingImg];
    
    UILabel *ruleTextLable =[[UILabel alloc]initWithFrame:CGRectMake(xingImg.maxX + 5, 10, 0, 0)];
    ruleTextLable.text = @"奖励规则";
    [ruleTextLable sizeToFit];
    ruleTextLable.textAlignment = NSTextAlignmentCenter;
    ruleTextLable.font = Font(14);
    ruleTextLable.textColor = UIColorFromRGB(0x666666);
    [ruleView addSubview:ruleTextLable ];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(ruleTextLable.maxX + 5, ruleTextLable.centerY, self.boundsWidth - ruleTextLable.maxX - 20, 0.5)];
    lineLabel.backgroundColor = UIColorFromRGB(0xe1e6e6);
    [ruleView addSubview:lineLabel];
    
    CGFloat avaH = (ruleView.boundsHeight -ruleTextLable.maxY -10)/self.signRuleArr.count;
    
    for (int i=0; i<self.signRuleArr.count; i++) {
        ScoreModel *score = self.signRuleArr[i];
        UILabel *ruleInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(xingImg.minX, ruleTextLable.maxY+avaH*i, ruleView.boundsWidth -100, avaH)];
        ruleInfoLabel.text = score.desc;
        ruleInfoLabel.font = Font(12);
        if ([score.num intValue]<=[calendar.num intValue]) {
          ruleInfoLabel.textColor = UIColorFromRGB(0xff4c61);
        }else
        {
        ruleInfoLabel.textColor = UIColorFromRGB(0x999999);
        }
        [ruleView addSubview:ruleInfoLabel];
 
    }
        
    for (int i = 0; i < 42; i++) {
        UIButton *button = [[UIButton alloc] init];
        [self.dayBg addSubview:button];
        [_daysArray addObject:button];
        [button addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW +space/2 +5;
        int y = (i / 7) * btnW +space/2;
        
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(10 + x, y, btnW, btnW);
        dayButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
            [self setStyle_AfterToday:dayButton];
            if (i % 7 ==0||i%7 == 6)
            {
                [dayButton setTitleColor:UIColorFromRGB(0xa6a6a6) forState:UIControlStateNormal];
            }
        }

        [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
        [dayButton setTitleEdgeInsets:UIEdgeInsetsMake(10*SCREEN_POINT, 0, 0, 5*SCREEN_POINT)];
        
        // this month
        if ([self month:date] == [self month:self.date]) {
            
            NSInteger todayIndex = [self day:date] + firstWeekday - 1;
            
            if (i < todayIndex && i >= firstWeekday) {
                //                [self setStyle_BeforeToday:dayButton];
            }else if(i ==  todayIndex){
                [self logDate:dayButton];
                //[self setStyle_Today:dayButton];
                 [dayButton setTitleColor:UIColorFromRGB(0xff4c61) forState:UIControlStateNormal];
            }    
        }
        
    }
}
//我的积分
-(void)setCountText:(NSString *)countText
{
    NSString *text =[NSString stringWithFormat:@"%@%@",@"我的积分：",countText];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    [AttributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,UIColorFromRGB(0x8c8c8c),NSForegroundColorAttributeName, nil] range:NSMakeRange(0, 5)];
    
    [AttributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,UIColorFromRGB(0x666666),NSForegroundColorAttributeName, nil] range:NSMakeRange(5, text.length -5)];
    
    _countLabel.attributedText = AttributedStr;
}
//签到天数
-(void)setDayText:(NSString *)dayText
{
    NSString *text =[NSString stringWithFormat:@"%@%@%@",@"已连续签到：",dayText,@" 天"];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    [AttributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,UIColorFromRGB(0x8c8c8c),NSForegroundColorAttributeName, nil] range:NSMakeRange(0, 6)];
    
    [AttributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,UIColorFromRGB(0x666666),NSForegroundColorAttributeName, nil] range:NSMakeRange(7, text.length -8)];
    
    [AttributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,UIColorFromRGB(0x8c8c8c),NSForegroundColorAttributeName, nil] range:NSMakeRange(text.length -1, 1)];
    
    _daylabel.attributedText = AttributedStr;
}
#pragma mark - chooseMonth
- (void)chooseMonth:(UIButton *)button {
    //下期版本
}


#pragma mark - output date
-(void)logDate:(UIButton *)dayBtn
{
    NSInteger today = [self day:[NSDate date]];
    
    if ([dayBtn.titleLabel.text integerValue] != today) {
        return;
    }
    dayBtn.selected = YES;

    [dayBtn setTitleColor:UIColorFromRGB(0xf23d52) forState:UIControlStateSelected];
    
    [dayBtn setBackgroundImage:self.dateImg forState:UIControlStateNormal];

    
    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    if (self.calendarBlock) {
        self.calendarBlock(day, [comp month], [comp year]);
    }
    
}

#pragma mark - date button style

- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    if (self.isShowOnlyMonthDays) {
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
}
#pragma mark---设置当天的
- (void)setStyle_Today:(UIButton *)btn
{
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
}

- (void)setStyle_AfterToday:(UIButton *)btn
{
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    for (NSString *str in self.allDaysArr) {
        if ([str isEqualToString:btn.titleLabel.text]) {
            
//            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
//            stateView.layer.cornerRadius = btn.frame.size.height / 2;
//            stateView.layer.masksToBounds = YES;
//            stateView.backgroundColor = self.allDaysColor;
//            stateView.image = self.allDaysImage;
//            stateView.alpha = 0.5;
//            [btn addSubview:stateView];
        }
    }
    for (NSString *str in self.partDaysArr) {
        if ([str isEqual:btn.titleLabel.text]) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:self.dateImg forState:UIControlStateNormal];
//            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
//            stateView.layer.cornerRadius = btn.frame.size.height / 2;
//            stateView.layer.masksToBounds = YES;
//            stateView.backgroundColor = self.partDaysColor;
//            stateView.image = self.partDaysImage;
//            stateView.alpha = 0.5;
//            [btn addSubview:stateView];
        }
    }
}

#pragma mark - Lazy loading
- (NSArray *)allDaysArr {
    if (!_allDaysArr) {
        _allDaysArr = [NSArray array];
    }
    return _allDaysArr;
}

- (NSArray *)partDaysArr {
    if (!_partDaysArr) {
        _partDaysArr = [NSArray array];
    }
    return _partDaysArr;
}

- (UIColor *)headColor {
    if (!_headColor) {
        _headColor = [UIColor whiteColor];
    }
    return _headColor;
}

- (UIImage *)dateImg {
    if (!_dateImg) {
        _dateImg = [UIImage imageNamed:@"checkin_date"];
    }
    return _dateImg;
}

- (UIColor *)allDaysColor {
    if (!_allDaysColor) {
        _allDaysColor = [UIColor blueColor];
    }
    return _allDaysColor;
}

- (UIColor *)partDaysColor {
    if (!_partDaysColor) {
        _partDaysColor = [UIColor cyanColor];
    }
    return _partDaysColor;
}

- (UIColor *)weekDaysColor {
    if (!_weekDaysColor) {
        _weekDaysColor = [UIColor blackColor];
    }
    return _weekDaysColor;
}

//一个月第一个周末
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *component = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [component setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:component];
    NSUInteger firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekDay - 1;
}

//总天数
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

#pragma mark - month +/-

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


#pragma mark - date get: day-month-year

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month] ;
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

@end
