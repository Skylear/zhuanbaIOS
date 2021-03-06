//
//  CustomTextField.m
//  writeApp
//
//  Created by miaomiaokeji on 16/8/25.
//  Copyright © 2016年 ios03. All rights reserved.


#import "CustomTextField.h"

@implementation CustomTextField

-(instancetype)initWithFrame:(CGRect)frame font:(CGFloat)titleFont{
    self = [super initWithFrame:frame];
    if (self) {
        self.titlefont = titleFont;
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
    
    CGContextMoveToPoint(context, 0, 60);  //起点坐标
    CGContextAddLineToPoint(context, self.frame.size.width, CGRectGetHeight(self.frame));   //终点坐标
    
    CGContextStrokePath(context);


}
//偏移左侧图标4个单位
-(id)initWithFrame:(CGRect)frame Icon:(UIImageView*)icon{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = icon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}
-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 0;// 右偏5
    return iconRect;
}
//改变文字位置
-(CGRect) textRectForBounds:(CGRect)bounds{
    CGRect iconRect=[super textRectForBounds:bounds];
    iconRect.origin.x+=0;
    return iconRect;
}
//改变编辑时文字位置
-(CGRect) editingRectForBounds:(CGRect)bounds{
    CGRect iconRect=[super editingRectForBounds:bounds];
    iconRect.origin.x+=0;
    return iconRect;
}

-(void)createUI{
        //设置UITextField的文字颜色
        self.textColor=UIColorFromRGB(0x333333);
        //设置UITextField的文本框背景颜色
        self.backgroundColor=[UIColor clearColor];
    
        //设置UITextField的边框的风格
        self.borderStyle=UITextBorderStyleNone;
    
        self.font = [UIFont systemFontOfSize:self.titlefont];
    
        //设置UITextField是否拥有一键清除的功能
        self.clearsOnBeginEditing=NO;
        self.tintColor =UIColorFromRGB(0x999999);
    
        //设置一键清除按钮是否出现
        self.clearButtonMode=UITextFieldViewModeWhileEditing;
    
        //设置UITextField的初始隐藏文字
//        self.placeholder=@"手机号";
    
        //设置UITextField的左边view出现模式
        self.leftViewMode=UITextFieldViewModeAlways;
    
        //设置UITextField的字的摆设方式
        self.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;

}

-(void)setPlaceholder:(NSString *)Placeholder{
    _Placeholder = Placeholder;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Placeholder attributes:@{
                                                                                                          NSForegroundColorAttributeName: UIColorFromRGB(0x999999),
                                                                                                          NSFontAttributeName :
                                                                                                              [UIFont systemFontOfSize:self.titlefont]}];
}



@end
