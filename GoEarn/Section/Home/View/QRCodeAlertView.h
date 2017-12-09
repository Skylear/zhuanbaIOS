//
//  QRCodeAlertView.h
//  writeApp
//
//  Created by Beyondream on 16/9/12.
//  Copyright © 2016年 ios03. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QRCodeAlertView;
@protocol QRCodeAlertViewDelegate <NSObject>

-(void)alertView:(QRCodeAlertView*)alertView message:(NSString*)message;

@end

@interface QRCodeAlertView : UIView

@property(nonatomic,assign)id<QRCodeAlertViewDelegate> delegate;

@property(nonatomic,strong)UIImageView  * headimg;

@end
