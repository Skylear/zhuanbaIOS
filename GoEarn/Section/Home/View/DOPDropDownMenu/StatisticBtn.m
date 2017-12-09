//
//  StatisticBtn.m
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/23.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import "StatisticBtn.h"


@interface StatisticBtn ()

@property(nonatomic,strong)UIImageView *rightTopImg;

@property(nonatomic,strong)UIImageView *rightBottomImg;

@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation StatisticBtn

-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString*)title
{
    self =  [super initWithFrame:frame];
    if (self)
    {
        [self creatUIWithFrame:frame WithTitle:title];
        
    }
    return self;
}
/**
 *  创建试图
 */
-(void)creatUIWithFrame:(CGRect)frame WithTitle:(NSString*)title
{
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-14, frame.size.height)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = Font(14);
    self.titleLabel.text = title;
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    [self addSubview:self.titleLabel];
    
    self.rightTopImg = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-6, frame.size.height/2 -3-1, 6, 3)];
    self.rightTopImg.image = [UIImage imageNamed:@"rankgray 2"];
    [self addSubview:self.rightTopImg];
    
    self.rightBottomImg = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-6, frame.size.height/2 + 1, 6, 3)];
    self.rightBottomImg.image = [UIImage imageNamed:@"rankgray"];
    [self addSubview:self.rightBottomImg];
    
}

/**
 *  设置状态
 */
-(void)setTopButtonItem:(TopButtonItem)topButtonItem
{
    switch (topButtonItem) {
        case TopButtonItemNormal:
        {
            self.titleLabel.textColor = UIColorFromRGB(0x333333);
            self.rightTopImg.image = [UIImage imageNamed:@"rankgray 2"];
            self.rightBottomImg.image = [UIImage imageNamed:@"rankgray"];
        }
            break;
        case TopButtonItemRightTop:
        {
            self.titleLabel.textColor = UIColorFromRGB(0xf23d3d);
            self.rightTopImg.image = [UIImage imageNamed:@"rankred 2"];
            self.rightBottomImg.image = [UIImage imageNamed:@"rankgray"];
        }
            break;
        case TopButtonItemRightBottom:
        {
            self.titleLabel.textColor = UIColorFromRGB(0xf23d3d);
            self.rightTopImg.image = [UIImage imageNamed:@"rankgray 2"];
            self.rightBottomImg.image = [UIImage imageNamed:@"rankred"];
        }
            break;
            
        default:
            break;
    }
}

@end
