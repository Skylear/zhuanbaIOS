//
//  MissonCell.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/20.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "MissonCell.h"

@implementation MissonCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoBtn.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.photoBtn];
        
        self.ddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.ddBtn.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        [self addSubview:self.ddBtn];
        
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-25, 3, 20, 20);
        [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"com-delete"] forState:UIControlStateNormal];
        [self.closeBtn setHidden:YES];
        [self addSubview:self.closeBtn];
        
    }
    return self;
}
@end
