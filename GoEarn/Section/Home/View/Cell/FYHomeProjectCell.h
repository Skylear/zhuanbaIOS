//
//  FYHomeProjectCell.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/21.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FYHomeProjectCell;
@protocol FYHomeProjectDelegate <NSObject>

@optional

-(void)missonCellAddRow:(FYHomeProjectCell*)cell withSource:(NSMutableArray*)sourceArr withRow:(int)row section:(NSInteger)section;
-(void)missonCellDeleteRow:(FYHomeProjectCell*)cell withSource:(NSMutableArray*)sourceArr withRow:(int)row section:(NSInteger)section ;

-(void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath imageArr:(NSMutableArray*)imgArr;

@end


@interface FYHomeProjectCell : UITableViewCell

//代理
@property(nonatomic,assign)id<FYHomeProjectDelegate> delegate;;
@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,weak)UITableView  * expandableTableView;

+(instancetype)cellWithTableView:(UITableView*)tableView WithIndenxpath:(NSIndexPath*)indexpath;

@end



#pragma mark -

@interface UITableView (ACEExpandableTextCell)

// return the cell with the specified ID. It takes care of the dequeue if necessary
- (FYHomeProjectCell *)expandableTextCell:(NSIndexPath *)indexpath;

@end

