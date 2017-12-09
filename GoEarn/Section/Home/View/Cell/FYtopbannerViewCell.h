//
//  FYFiveViewCell.h
//  GoEarn
//
//  Created by Beyondream on 2016/9/29.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYtopbannerViewCellDelegate <NSObject>

@optional
-(void)didSelectedTopbannerViewCellIndex:(NSInteger)index;

@end

@interface FYtopbannerViewCell : UITableViewCell

@property (nonatomic, assign) id<FYtopbannerViewCellDelegate> delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView array:(NSMutableArray *)array;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Array:(NSArray *)array;

-(void)addTimer;
-(void)closeTimer;

@end
