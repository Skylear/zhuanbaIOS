//
//  FYHomeListCell.h
//  GoEarn
//
//  Created by Beyondream on 2016/9/30.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeListCellModel.h"
#import "TimeLabel.h"
@interface FYHomeListCell : UITableViewCell

@property(nonatomic,strong)UIImageView  * headImg;

@property(nonatomic,strong)UILabel  * headLabel;

@property(nonatomic,strong)UILabel  * moneyLabel;

@property(nonatomic,strong)NSString  * moneyString;

@property(nonatomic,strong)UILabel  * leftLabel;


//@property(nonatomic,strong)AppTimeOutView  * timeOutView;

@property(nonatomic,strong)TimeLabel  * timeOutLabel;

+(instancetype)cellWithTableView:(UITableView *)tableView model:(HomeListCellModel *)model cellType:(NSInteger)cellType withIndexPath:(NSIndexPath*)indexPath;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(HomeListCellModel *)model cellType:(NSInteger)cellType;

@end



