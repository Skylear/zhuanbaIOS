//
//  CustomCell.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/8.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        titleLab.font = Font(12);
        titleLab.textColor = UIColorFromRGB(0xffa5b0);
        titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab = titleLab;
        [self.contentView addSubview:titleLab];
        
    }
    return self;
}

@end
