//
//  MusicLrcCell.h
//  Music
//
//  Created by hanlei on 16/7/21.
//  Copyright © 2016年 hanlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicLrcLabel;

@interface MusicLrcCell : UITableViewCell

@property (nonatomic, weak, readonly) MusicLrcLabel *lrcLabel;

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
