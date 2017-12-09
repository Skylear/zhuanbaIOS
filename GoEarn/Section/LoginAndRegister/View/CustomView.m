//
//  CustomView.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/8.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)titleString{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleString = titleString;
        [self createUI];
    }
    
    return self;
    
}
-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.5f);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 225/255.f, 230/255.f, 230/255.f, 1.0);  //线的颜色
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 0, self.frame.size.height);  //起点坐标
    CGContextAddLineToPoint(context, self.frame.size.width, CGRectGetHeight(self.frame));   //终点坐标
    CGContextStrokePath(context);
}
-(void)createUI{
    UILabel *titlelab = [[UILabel alloc] init];
    titlelab.frame = CGRectMake(0, (self.frame.size.height-10)/2, 60, 10);
   titlelab.text = self.titleString;
    titlelab.font = Font(13);
    titlelab.textColor = UIColorFromRGB(0x333333);
    [self addSubview:titlelab];

}
@end
