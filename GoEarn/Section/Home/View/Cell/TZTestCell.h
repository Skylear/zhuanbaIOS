//
//  TZTestCell.h
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TZTestCell;
@protocol TZTestCellDelegate <NSObject>
@required
-(void)deleteCellAtIndexpath:(NSIndexPath *)indexPath cellView:(TZTestCell *)cell;

@end

@interface TZTestCell : UICollectionViewCell


@property(nonatomic,assign)id<TZTestCellDelegate> delegate;
@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;

- (UIView *)snapshotView;

@end

