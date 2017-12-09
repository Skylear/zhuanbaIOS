
//
//  GRBadgeButton.m
//  GRWeibo
//
//  Created by apple on 14/10/21.
//  Copyright (c) 2014年 happy village. All rights reserved.
//

#import "GRBadgeButton.h"
#import "UIImage+MJ.h"

@implementation GRBadgeButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        self.hidden = NO;
        self.userInteractionEnabled = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage resizedImageWithName:@"message_dot"] forState:UIControlStateNormal];
       
        [self setContentMode:UIViewContentModeScaleAspectFill];
    }
    
    return self;
}

-(void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    
    if ([self.badgeValue intValue] == 0) {
        // 没有值
        self.hidden = YES;
    } else {
        self.hidden = NO;
        
        [self setTitle:badgeValue forState:UIControlStateNormal];
        [self sizeToFit];
        self.frame = CGRectMake(0, 0, self.width, self.height);
    }
}

@end
