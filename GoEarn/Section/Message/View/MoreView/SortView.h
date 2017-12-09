//
//  SortView.h
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/18.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortView : UIView

- (instancetype)initWithFrame:(CGRect)frame channelList:(NSMutableArray *)channelList withSelect:(NSInteger)selectIndex;
/** 排序完成回调 */
@property (nonatomic, copy) void(^sortCompletedBlock)(NSMutableArray *channelList,NSInteger selectInteger);
/** cell按钮点击回调 */
@property (nonatomic, copy) void(^cellButtonClick)(UIButton *button);
@end
