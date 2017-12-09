//
//  ChanneLabel.h
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/18.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanneLabel : UILabel

@property(nonatomic,assign)CGFloat scale;

@property(nonatomic,assign)CGFloat textWidth;

+ (instancetype)channelLabelWithTitle:(NSString *)title;

@end
