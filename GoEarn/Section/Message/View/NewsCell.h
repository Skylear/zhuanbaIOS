//
//  NewsCell.h
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/19.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticalModel;

@interface NewsCell : UITableViewCell

@property(nonatomic,strong)ArticalModel *model;

@property(nonatomic,strong)UILabel *timeLabel ;
/**
 *  点击图片回调
 */
@property(nonatomic,copy)void(^cycleImageClickBlock)(NSInteger index,ArticalModel *art);
/**
 *  滚动回调
 */
@property(nonatomic,copy)void(^cycleImageScrolBlock)(NSInteger index);
//标识符
+ (NSString *)cellReuseID:(ArticalModel *)newsModel;
//计算搞
+ (CGFloat)cellForHeight:(ArticalModel *)newsModel;
@end
