//
//  CalendarVBgView.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/29.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "CalendarVBgView.h"

@interface CalendarVBgView ()


@end

@implementation CalendarVBgView

- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/25
    CGFloat radius = 15*SCREEN_POINT;
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextAddArc(context, width - radius , height - radius -2, radius +2, 0.0, 0.5 * M_PI, 0);
    
    CGContextAddArc(context, radius, height - radius -2, radius +2, 0.5 * M_PI, M_PI, 0);
    
    CGContextSetStrokeColorWithColor(context,  UIColorFromRGB(0xeeeeee).CGColor);
    
    CGContextStrokePath(context);
     //第二个线
    CGContextAddArc(context, width - radius , height - radius -4, radius +2, 0.0, 0.5 * M_PI, 0);
    
    CGContextAddArc(context, radius, height - radius -4, radius +2, 0.5 * M_PI, M_PI, 0);
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xeeeeee).CGColor);
    
    CGContextStrokePath(context);

    
    //第三个线
    CGContextAddArc(context, width - radius , height - radius -6, radius +2, 0.0, 0.5 * M_PI, 0);
    
    CGContextAddArc(context, radius, height - radius -6, radius +2, 0.5 * M_PI, M_PI, 0);
    
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xeeeeee).CGColor);
    
    CGContextStrokePath(context);
    
}

@end
