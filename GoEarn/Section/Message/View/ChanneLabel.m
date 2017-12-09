//
//  ChanneLabel.m
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/18.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import "ChanneLabel.h"

@implementation ChanneLabel

+ (instancetype)channelLabelWithTitle:(NSString *)title
{
    ChanneLabel *label = [self new];
    label.text = title ;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.userInteractionEnabled = YES;
    return label;
    
}
-(CGFloat)textWidth
{
    return [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].width + 8; // +8，要不太窄
}
-(void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.textColor = UIColorFromRGB(0x666666);
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> %@", self.class, self, self.text];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
