//
//  MessageDetailVC.h
//  GoEarn
//
//  Created by Beyondream on 2016/9/27.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "BaseViewController.h"
#import "ArticalModel.h"
@interface MessageDetailVC : BaseViewController

@property(nonatomic,strong)NSString  * aid;
//从推广界面进入传入 url
@property(nonatomic,strong)NSString *adUrl;

@property(nonatomic,strong)ArticalModel  * model;
@end
