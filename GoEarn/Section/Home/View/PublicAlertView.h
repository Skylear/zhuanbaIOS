//
//  PublicAlertView.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/18.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PublicAlertType) {
    PublicAlertAppDownload,
    PublicAlertNotification,
    PublicAlertCatchMessage,
    
};

@class PublicAlertView;

@protocol PublicAlertViewDelegate <NSObject>

@optional

- (void) PublicAlertView:(PublicAlertView*)alert buttonindex:(NSInteger)index;
//用户协议选择
- (void) PublicAlertView:(PublicAlertView*)alert userSelecte:(BOOL)isSelected;

- (void) PublicAlertView:(PublicAlertView*)alert
                  String:(NSString *)string
                   range:(NSRange)range
                   index:(NSInteger)index;

@end


@interface PublicAlertView : UIView

@property(nonatomic,strong)UIFont  * messageFont;

@property(nonatomic,strong)UIFont  * titleFont;
@property(nonatomic,strong)NSString  * cancleString;
@property(nonatomic,strong)NSString  * titleString;
@property(nonatomic,strong)NSString  * messageString;
@property(nonatomic,strong)NSString  * sureString;

@property(nonatomic,assign)BOOL isNotAgree;

- (instancetype) initWithTitle:(NSString*)title
                   message:(NSString*)message
                      delegate:(id<PublicAlertViewDelegate>)delegate
             cancelButtonTitle:(NSString*)canclestring otherButtonTitle:(NSString*)otherstring withMsFont:(UIFont*)msFont
                 withTitleFont:(UIFont*)tFont;

- (void) showUserChoiseBtn;

- (void) haveCashChoiseBtn;

- (void) show;

- (void) hiden;
@end
