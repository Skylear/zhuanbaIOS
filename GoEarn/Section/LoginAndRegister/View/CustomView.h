//
//  CustomView.h
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/8.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView
@property (nonatomic,strong) NSString  * titleString;

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)titleString;
@end
