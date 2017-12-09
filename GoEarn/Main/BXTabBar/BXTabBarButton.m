//
//  BXTabBarButton.m
//  IrregularTabBar
//
//  Created by JYJ on 16/5/3.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "BXTabBarButton.h"

@implementation BXTabBarButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 1.设置字体
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 2.图片的内容模式
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.frame = CGRectMake(0, self.height - self.titleLabel.height -5, self.width, 15);
    
    self.imageView.frame = CGRectMake((self.width - self.imageView.width) / 2, self.titleLabel.y - self.imageView.height , self.currentImage.size.width, self.currentImage.size.height);
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

@end
