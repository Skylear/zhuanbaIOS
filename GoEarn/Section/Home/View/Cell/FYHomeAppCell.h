//
//  FYHomeAppCell.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/10.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeAppModel.h"
@interface FYHomeAppCell : UITableViewCell

@property(nonatomic,strong)UIImageView  * imgView;

+(instancetype)cellWithTableView:(UITableView *)tableView model:(HomeAppModel *)model WithIndexPath:(NSIndexPath *)indexPath isBusiness:(BOOL)isBusiness;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(HomeAppModel *)model WithIndexPath:(NSIndexPath *)indexPath isBusiness:(BOOL)isBusiness;

+(CGFloat)cellWithTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath model:(HomeAppModel *)model isBusiness:(BOOL)isBusiness;

@end
