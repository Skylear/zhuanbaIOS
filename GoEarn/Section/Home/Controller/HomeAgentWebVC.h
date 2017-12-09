//
//  HomeAgentWebVC.h
//  GoEarn
//
//  Created by Beyondream on 2016/11/7.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "BaseViewController.h"


@interface HomeAgentWebVC : BaseViewController<UIWebViewDelegate>

@property(nonatomic,strong)NSString  * utno;

@property(nonatomic,strong)NSString  * countdown;

@property(nonatomic,strong)NSString  * url;

@property(nonatomic,strong)NSArray  * submitArr;

@end
