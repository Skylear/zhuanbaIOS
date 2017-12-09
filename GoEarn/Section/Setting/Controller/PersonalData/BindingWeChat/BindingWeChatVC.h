//
//  BindingWeChatVC.h
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/13.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

- (void)copyToApp:(NSArray*)key;

@end

@interface BindingWeChatVC : BaseViewController<JSObjcDelegate>
@property (nonatomic, strong) JSContext *jsContext;
@end
