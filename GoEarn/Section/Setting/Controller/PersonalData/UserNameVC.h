//
//  UserNameVC.h
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/9.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ChangeName)(NSString *nameStr);

@interface UserNameVC : BaseViewController

@property (nonatomic,copy)   ChangeName changename;
@property (nonatomic,strong) NSString  * nameStr;
@end
