//
//  changeColor.m
//  MIAOTUI2
//
//  Created by iOS03 on 16/7/4.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import "changeColor.h"

@implementation changeColor
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView*colorBackgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        //    colorBackgroundView.backgroundColor=[UIColor blackColor];
        //    colorBackgroundView.alpha=1;
        UIColor *colorOne = [UIColor colorWithRed:0  green:0  blue:0  alpha:0.45];
        UIColor *colorTwo = [UIColor colorWithRed:0  green:0  blue:0  alpha:0];
        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor,  nil];
//        NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
//        NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
//        NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo,  nil];
        
        //crate gradient layer
        CAGradientLayer *headerLayer = [CAGradientLayer layer];
        
        headerLayer.colors = colors;
//        headerLayer.locations = locations;
        headerLayer.startPoint = CGPointMake(0, 1);
        
        headerLayer.endPoint = CGPointMake(1, 1);
        headerLayer.frame = colorBackgroundView.bounds;
        
        [colorBackgroundView.layer insertSublayer:headerLayer atIndex:0];
        [self addSubview:colorBackgroundView];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
