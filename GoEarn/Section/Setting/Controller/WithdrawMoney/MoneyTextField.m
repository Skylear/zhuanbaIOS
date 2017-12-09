//
//  MoneyTextField.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/13.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "MoneyTextField.h"

@implementation MoneyTextField
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
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
//-(CGRect) leftViewRectForBounds:(CGRect)bounds {
//    CGRect iconRect = [super leftViewRectForBounds:bounds];
//    iconRect.origin.x += 5;// 右偏5
//    return iconRect;
//}
//改变文字位置
-(CGRect) textRectForBounds:(CGRect)bounds{
    CGRect iconRect=[super textRectForBounds:bounds];
    iconRect.origin.x+=20;
    return iconRect;
}
//改变编辑时文字位置
-(CGRect) editingRectForBounds:(CGRect)bounds{
    CGRect iconRect=[super editingRectForBounds:bounds];
    iconRect.origin.x+=10;
    return iconRect;
}
//-(CGRect)editingRectForBounds:(CGRect)bounds
//{
//    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width-25, bounds.size.height);//更好理解些
//    return inset;
//}
//控制placeholder位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    
    CGRect inset = CGRectMake(bounds.origin.x+50, bounds.origin.y+18, bounds.size.width , bounds.size.height);//更好理解些
    return inset;
}
//控制placeholder的颜色，大小
- (void)drawPlaceholderInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, UIColorFromRGB(0xff4c61).CGColor);
    [[UIColor orangeColor] setFill];
    
    [self.placeholder drawInRect:rect withFont:Font(17)];
}


-(void)createUI{
    //设置UITextField的文字颜色
    self.textColor=UIColorFromRGB(0xff4c61);
    //设置UITextField的文本框背景颜色
    self.backgroundColor=[UIColor clearColor];
    
    self.textAlignment = NSTextAlignmentCenter;
    //设置UITextField的边框的风格
    self.borderStyle=UITextBorderStyleNone;
    
    self.font = Font(17);
    
    //设置UITextField是否拥有一键清除的功能
    self.clearsOnBeginEditing=NO;
    self.tintColor = UIColorFromRGB(0xff4c61);
    self.keyboardType = UIKeyboardTypeDecimalPad;
    //设置UITextField的字的摆设方式
    self.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    
}

//-(void)setPlaceholder:(NSString *)Placeholder{
//    _Placeholder = Placeholder;
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Placeholder attributes:@{
//                                                                                                     NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                                                                     NSFontAttributeName :
//                                                                                                         [UIFont systemFontOfSize:14]}];
//}



@end
