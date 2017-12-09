//
//  ZZPhotoBrowerViewController.h
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/27.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZResourceConfig.h"



@interface ZZPhotoBrowerViewController : UIViewController
@property(nonatomic,strong)NSMutableArray  * selectArray;
@property (nonatomic, strong) NSArray *photoData;

@property (nonatomic, assign) NSInteger scrollIndex;

-(void) showIn:(UIViewController *)controller;

@end
