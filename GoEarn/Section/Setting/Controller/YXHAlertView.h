//
//  YXHAlertView.h
//  GoEarn
//
//  Created by miaomiaokeji on 2016/12/26.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXHAlertView;
@protocol YXHAlertViewDelegate <NSObject>

@optional

- (void) PublicAlertView:(YXHAlertView*)alert buttonindex:(NSInteger)index;

@end


@interface YXHAlertView : UIView

@property(nonatomic,strong)UIFont  * messageFont;

@property(nonatomic,strong)UIFont  * titleFont;
@property(nonatomic,strong)NSString  * cancleString;
@property(nonatomic,strong)NSString  * titleString;
@property(nonatomic,strong)NSString  * sureString;

@property(nonatomic,assign)BOOL isNotAgree;

- (instancetype) initWithTitle:(NSString*)title
                       message:(NSString*)message
                      delegate:(id<YXHAlertViewDelegate>)delegate
             cancelButtonTitle:(NSString*)canclestring otherButtonTitle:(NSString*)otherstring withMsFont:(UIFont*)msFont
                 withTitleFont:(UIFont*)tFont;

- (void) show;

- (void) hiden;
@end
