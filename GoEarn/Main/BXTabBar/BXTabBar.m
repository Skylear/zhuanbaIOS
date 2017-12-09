//
//  BXTabBar.m
//  IrregularTabBar
//
//  Created by JYJ on 16/5/3.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "BXTabBar.h"
#import "BXTabBarButton.h"
#import "BXTabBarBigButton.h"
#import "UIImage+MJ.h"
#define TabbarItemNums 5.0    //tabbar的数量
@interface BXTabBar ()
/**
 *  选中的按钮
 */
@property (nonatomic, weak) UIButton *selButton;

/** bigButton */
@property (nonatomic, weak) BXTabBarBigButton *bigButton;
@end

@implementation BXTabBar

/** tabBarTag */
static NSInteger const BXTabBarTag = 12000;

- (void)setItems:(NSArray *)items
{
    _items = items;

    // UITabBarItem保存按钮上的图片
    for (int i = 0; i < items.count; i++) {
        UITabBarItem *item = items[i];
//        if (i == 2) {
//            BXTabBarBigButton *btn = [BXTabBarBigButton buttonWithType:UIButtonTypeCustom];
//            
//            btn.tag = self.subviews.count + BXTabBarTag;
//            // 设置图片
//            [btn setImage:item.image forState:UIControlStateNormal];
//            [btn setImage:item.selectedImage forState:UIControlStateSelected];
//            btn.adjustsImageWhenHighlighted = NO;
//            // 设置文字
//            [btn setTitle:item.title forState:UIControlStateNormal];
//            [btn setTitleColor:RGBCOLOR(113, 109, 104) forState:UIControlStateNormal];
//            [btn setTitleColor:UIColorFromRGB(0xff4c61) forState:UIControlStateSelected];
//            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
//            
//            [self addSubview:btn];
//            self.bigButton = btn;
//
//        } else {
            UIButton *btn = [BXTabBarButton buttonWithType:UIButtonTypeCustom];
            
            btn.tag = self.subviews.count + BXTabBarTag;
            
            // 设置图片
            [btn setImage:item.image forState:UIControlStateNormal];
            [btn setImage:item.selectedImage forState:UIControlStateSelected];
            btn.adjustsImageWhenHighlighted = NO;
            // 设置文字
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setTitleColor:RGBCOLOR(113, 109, 104) forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0xff4c61) forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:btn];
            if (self.subviews.count == 1) {
                // 默认选中第一个
                [self btnClick:btn];
            }
        }
    //}
   
}

- (void)btnClick:(UIButton *)button
{
    _selButton.selected = NO;
    
    button.selected = YES;
    
    _selButton = button;
    
    // 通知tabBarVc切换控制器
    if ([_delegate respondsToSelector:@selector(tabBar:didClickBtn:)]) {
        [_delegate tabBar:self didClickBtn:button.tag - BXTabBarTag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.borderColor = UIColorFromRGB(0xacacac).CGColor;
    self.layer.borderWidth = 0.5;
    
    NSUInteger count = self.subviews.count;
    
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = [UIScreen mainScreen].bounds.size.width / count;
    
    CGFloat h = self.height;
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        
        x = i * w;
        
        if (i == 2) {
            y = -12;
            h = self.height + 12;
        } else {
            y = 0;
            h = self.height;
        }
        btn.frame = CGRectMake(x, y, w, h);
    }
    
    UIButton *btn = (UIButton*)[self viewWithTag:BXTabBarTag +2];
    
    //新建小红点
    UIButton *badge = [UIButton buttonWithType:UIButtonTypeCustom];

    badge.alpha = 1.0;
    badge.layer.cornerRadius = 5;
    badge.layer.borderWidth = 1.5f;
    badge.layer.borderColor = [UIColor whiteColor].CGColor;
    [badge setBackgroundImage:[UIImage resizedImageWithName:@"message_dot"] forState:UIControlStateNormal];
    badge.hidden = YES;
    [btn addSubview:badge];
    
    self.badgeView = badge;
    
    [badge mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (iPhone5||iPhone4) {
            make.centerX.equalTo(btn.imageView).offset(20);
            make.top.equalTo(btn.imageView).offset(-4);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }else
        {
            make.centerX.equalTo(btn.imageView).offset(10);
            make.top.equalTo(btn.imageView).offset(-4);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }
    }];

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat pointW = 49;
    CGFloat pointH = 61;
    CGFloat pointX = (SCREEN_WIDTH - pointW) / 2;
    CGFloat pointY = -12;
    CGRect rect = CGRectMake(pointX, pointY, pointW, pointH);
    if (CGRectContainsPoint(rect, point)) {
        return self.bigButton;
    }
    return [super hitTest:point withEvent:event];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
