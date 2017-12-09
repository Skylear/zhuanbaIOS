//
//  FYHomeAppHeadView.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/11.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeAppModel.h"
@interface FYHomeAppHeadView : UITableViewHeaderFooterView

+(instancetype)headViewWithTableView:(UITableView*)tableView WithSection:(NSInteger)section model:(HomeAppModel *)model isBusiness:(BOOL)isBusiness;

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithSection:(NSInteger)section model:(HomeAppModel *)model isBusiness:(BOOL)isBusiness;

@end
