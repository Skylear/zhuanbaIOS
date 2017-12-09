//
//  LXGradientProcessView.m
//  LXGradientProcessView
//
//  Created by Leexin on 15/12/20.
//  Copyright © 2015年 Garden.Lee. All rights reserved.
//

#import "LXGradientProcessView.h"
#import "UIView+Extensions.h"
#import "UIColor+Extensions.h"

static const CGFloat kProcessHeight = 10.f;
static const CGFloat kTopSpaces = 0.f;
static const CGFloat kNumberMarkWidth = 60.f;
static const CGFloat kNumberMarkHeight = 20.f;
static const CGFloat kAnimationTime = 3.f;

@interface LXGradientProcessView ()

@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
//@property (nonatomic, strong) UIButton *numberMark; // 数字标示
@property (nonatomic, strong) NSTimer *numberChangeTimer;
@property (nonatomic, assign) CGFloat numberPercent;

@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSArray *colorLocationArray;

@end

@implementation LXGradientProcessView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.colorArray = @[(id)[[UIColor colorWithHex:0xFF6347] CGColor],
                            (id)[[UIColor colorWithHex:0xFFEC8B] CGColor],
                            (id)[[UIColor colorWithHex:0x98FB98] CGColor],
                            (id)[[UIColor colorWithHex:0x00B2EE] CGColor],
                            (id)[[UIColor colorWithHex:0x9400D3] CGColor]];
        self.colorLocationArray = @[@0.1, @0.3, @0.5, @0.7, @1];

        [self getGradientLayer];
        self.numberPercent = 0;
    }
    return self;
}

- (void)getGradientLayer { // 进度条设置渐变色
    
    // 灰色进度条背景
    CALayer *bgLayer = [CALayer layer];
    bgLayer.frame = CGRectMake(0, self.height - kProcessHeight - kTopSpaces, self.width , kProcessHeight);
    bgLayer.backgroundColor = [UIColor colorWithHex:0xF5F5F5].CGColor;
    bgLayer.masksToBounds = YES;
    bgLayer.cornerRadius = kProcessHeight / 2;
    [self.layer addSublayer:bgLayer];
    
    self.maskLayer = [CALayer layer];
    self.maskLayer.frame = CGRectMake(0, 0, (self.width - kNumberMarkWidth / 2) * self.percent / 100.f, kProcessHeight);
    self.maskLayer.borderWidth = self.height / 2;
    
    self.gradientLayer =  [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0, self.height - kProcessHeight - kTopSpaces, self.width , kProcessHeight);
    self.gradientLayer.masksToBounds = YES;
    self.gradientLayer.cornerRadius = kProcessHeight / 2;
    [self.gradientLayer setColors:self.colorArray];
    [self.gradientLayer setLocations:self.colorLocationArray];
    [self.gradientLayer setStartPoint:CGPointMake(0, 0)];
    [self.gradientLayer setEndPoint:CGPointMake(1, 0)];
    [self.gradientLayer setMask:self.maskLayer];
    [self.layer addSublayer:self.gradientLayer];
}

- (void)setPercent:(CGFloat)percent {
    [self setPercent:percent animated:YES];
}

- (void)setPercent:(CGFloat)percent animated:(BOOL)animated {
    
    _percent = percent;
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(circleAnimation) userInfo:nil repeats:NO];
    // 文字动画
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:kAnimationTime animations:^{

    }];
    
    self.numberChangeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeNumber) userInfo:nil repeats:YES];
}

- (void)changeNumber { // 每0.1秒改变百分比文字
    
    if (!self.percent) {
        [self.numberChangeTimer invalidate];
        self.numberChangeTimer = nil;
    }
    self.numberPercent += (self.percent / (kAnimationTime * 10.f));
    if (self.numberPercent > self.percent) {
        [self.numberChangeTimer invalidate];
        self.numberChangeTimer = nil;
        self.numberPercent = self.percent;
    }

}

- (void)circleAnimation { // 进度条动画
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [CATransaction setAnimationDuration:kAnimationTime];
    self.maskLayer.frame = CGRectMake(0, 0, (self.width - kNumberMarkWidth / 2) * _percent / 100.f, kProcessHeight);
    [CATransaction commit];
}



@end
