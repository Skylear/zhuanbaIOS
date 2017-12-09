//
//  StatisticBtn.h
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/23.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *   三种状态
 */
typedef NS_ENUM(NSInteger ,TopButtonItem) {
    /**
     *  正常状态
     */
    TopButtonItemNormal =0,
    /**
     *  右上红色
     */
    TopButtonItemRightTop = 1,
    /**
     *  左上红色
     */
    TopButtonItemRightBottom = 2,
};

@interface StatisticBtn : UIView

@property(nonatomic,assign)TopButtonItem topButtonItem;

-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString*)title;

-(void)setTopButtonItem:(TopButtonItem)topButtonItem;
@end
