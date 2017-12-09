//
//  AppTimeOutView.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/9.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "AppTimeOutView.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
@implementation AppTimeOutView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
          
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGSize cornerSize = CGSizeMake(self.corner,self.corner);
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)
                                           cornerRadii:cornerSize];
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    self.layer.mask = maskLayer;
    [self.layer setMasksToBounds:YES];
    
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*写文字*/
    UIFont  *font = [UIFont boldSystemFontOfSize:self.fontSize];//定义默认字体
    if (IOS_VERSION>=7) {
        NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.lineSpacing = 3.0f;
        paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中：发现只能水平居中，而无法垂直居中
        NSDictionary* attribute = @{
                                    NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:1 blue:1 alpha:1],//设置文字颜色
                                    NSFontAttributeName:font,//设置文字的字体
                                    NSKernAttributeName:@1,//文字之间的字距
                                    NSParagraphStyleAttributeName:paragraphStyle,//设置文字的样式
                                    };
        
        //计算文字的宽度和高度：支持多行显示
        CGSize sizeText = [self.textString boundingRectWithSize:self.bounds.size
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{
                                                                  NSFontAttributeName:font,//设置文字的字体
                                                                  NSKernAttributeName:@5,//文字之间的字距
                                                                  }
                                                        context:nil].size;
        
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        
        //为了能够垂直居中，需要计算显示起点坐标x,y
        CGRect rect = CGRectMake(0.5+(width-sizeText.width)/2, (height-sizeText.height)/2+3, sizeText.width, sizeText.height+10);
        [self.textString drawInRect:rect withAttributes:attribute];
        
        CGContextSetLineWidth(context,1);//线条的粗细
        
        CGContextStrokePath(context);
    }else{
        CGContextSetRGBFillColor (context,  1, 1, 1, 1.0);//设置填充颜色:红色
        [self.textString drawInRect:self.bounds withFont:font];
    }
}
-(void)setCorner:(CGFloat)corner
{
    _corner = corner;
    [self setNeedsDisplay];
}

@end
