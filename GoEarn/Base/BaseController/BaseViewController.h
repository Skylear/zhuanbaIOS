//
//  BaseViewController.h
//  GoEarn
//
//  Created by Beyondream on 2016/9/23.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIView *yourSuperView;

@property (nonatomic, strong) UIImageView *imaView;

-(void)initAdvView:(CGRect)frame;

-(void)removeAdvImage;
@end
