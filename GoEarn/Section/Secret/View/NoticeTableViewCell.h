//
//  NoticeTableViewCell.h
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/9.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoticeTableViewCell;

@protocol NoticeTableViewCellDelegate <NSObject>

@required

-(void)NoticeTableViewCell:(NoticeTableViewCell*)cell tapGestureRecogenize:(UIGestureRecognizer *)gesture;
@end


@interface NoticeTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel  * titleLab;
@property (nonatomic,strong) UILabel  * detailLab;
@property (nonatomic,strong) UIImageView  * mark;
@property (nonatomic,strong) UILabel  * timeLab;
@property (nonatomic,strong) UIView  * baseView;
@property (nonatomic,strong) UIView  * lineView;
@property (nonatomic,strong) UIImageView  * PictureIMG;
@property (nonatomic,assign) CGFloat  textH;
@property (nonatomic,assign) id<NoticeTableViewCellDelegate>delegate;
@end
