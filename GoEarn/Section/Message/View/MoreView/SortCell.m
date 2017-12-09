//
//  SortCell.m
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/18.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import "SortCell.h"

@implementation SortCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _button.titleLabel.font = [UIFont systemFontOfSize:detail_Font];
        [self addSubview:_button];
    }
    return self;
}
@end
