//
//  HomeWebVC.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/10.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

- (void)copyToApp:(NSArray*)key;

-(void)setAppData:(NSArray*)arr;

//商家
-(void)setMerchantData:(NSArray*)arr;

@end

@interface HomeWebVC : BaseViewController<UIWebViewDelegate,JSObjcDelegate>
@property (nonatomic, strong) JSContext *jsContext;


@end
