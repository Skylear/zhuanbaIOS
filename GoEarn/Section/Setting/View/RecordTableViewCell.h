//
//  RecordTableViewCell.h
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/26.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *avaterIMG;

@property (strong, nonatomic) UILabel *NameLab;

@property (strong, nonatomic) UILabel *IDLab;

@property (strong, nonatomic) UILabel *moneyLab;

@property (nonatomic,strong) UIView  * lineView;
@end
