//
//  FYHomeMissonCell.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/20.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYHomeMissonCell;
@protocol FYHomeMissonDelegate <NSObject>

@optional

-(void)registCellAddRow:(FYHomeMissonCell*)cell withSource:(NSMutableArray*)sourceArr withRow:(int)row;
-(void)registCellDeleteRow:(FYHomeMissonCell*)cell withSource:(NSMutableArray*)sourceArr withRow:(int)row;

@end


@interface FYHomeMissonCell : UITableViewCell

//代理
@property(nonatomic,assign)id<FYHomeMissonDelegate> delegate;;
@property(nonatomic,strong)UICollectionView *collectionView;

+(instancetype)cellWithTableView:(UITableView*)tableView WithIndenxpath:(NSIndexPath*)indexpath;
@end


@interface FYHomeMissonTFCell : UITableViewCell

@property(nonatomic,strong)UITextField  * TF;

+(instancetype)cellWithTableView:(UITableView*)tableView WithIndenxpath:(NSIndexPath*)indexpath;
@end
