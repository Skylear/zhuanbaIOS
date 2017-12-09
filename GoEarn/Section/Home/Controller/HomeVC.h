//
//  HomeVC.h
//  GoEarn
//
//  Created by Beyondream on 2016/9/23.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeTableView : UITableView

@property(nonatomic,assign)BOOL isScroing;

@end

@interface HomeVC : UIViewController
// 获取签到天数
-(void)initSignData;
@end
