//
//  TSHomeMenuCell.h
//  GoEarn
//
//  Created by Beyondream on 2016/9/29.
//  Copyright © 2016年 Beyondream. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol FYHomeMenuCellDelegate <NSObject>

@optional
-(void)didSelectedHomeMenuCellAtIndex:(NSInteger)index;

@end

@interface FYHomeMenuCell : UITableViewCell

@property (nonatomic, assign) id<FYHomeMenuCellDelegate> delegate;
+(instancetype)cellWithTableView:(UITableView *)tableView menuArray:(NSMutableArray *)menuArray;

@end
