//
//  SecretTableViewCell.h
//  GoEarn
//
//  Created by miaomiaokeji on 2016/9/24.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRBadgeButton.h"

@interface SecretTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView  * avaterIMG;
@property (nonatomic,strong) UILabel  * titleLab;
@property (nonatomic,strong) UILabel  * detailLab;
@property (nonatomic,strong) UIImageView  * mark;
@property (nonatomic,strong) GRBadgeButton *bage;

@end
