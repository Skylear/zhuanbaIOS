//
//  PickerView.h
//  PickerDemo
//
//  Created by miaomiaokeji on 16/8/30.
//  Copyright © 2016年 demo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LocationString)(NSString *proName,NSString *cityName,NSString *proID,NSString *cityID);

@interface PickerView : UIView

@property (nonatomic,copy)   LocationString locationStr;
@property (nonatomic,strong)   NSMutableArray  * princeArr;

-(void)show;
@end
