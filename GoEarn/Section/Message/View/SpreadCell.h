//
//  SpreadCell.h
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/18.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticalList.h"
@class MessageListVC;

@interface SpreadCell : UICollectionViewCell

@property (nonatomic, strong) MessageListVC *newsVC;

@property(nonatomic,strong)ArticalList  * art;

@end
