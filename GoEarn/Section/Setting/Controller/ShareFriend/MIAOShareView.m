//
//  MIAOShareView.m
//  MIAOTUI2
//
//  Created by 余晓辉 on 16/5/21.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import "MIAOShareView.h"

@implementation MIAOShareView

-(void)awakeFromNib
{
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    self.ShareVIew.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 262);
    self.LalTextColor.textColor = UIColorFromRGB(0x8c8c8c);
    self.label1.textColor = UIColorFromRGB(0x8c8c8c);
    self.label2.textColor = UIColorFromRGB(0x8c8c8c);
    self.label3.textColor = UIColorFromRGB(0x8c8c8c);
    self.label4.textColor = UIColorFromRGB(0x8c8c8c);
    self.label5.textColor = UIColorFromRGB(0x8c8c8c);
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGester)];
    [self addGestureRecognizer:tap];
    
}

-(void)tapGester{

    [self close];

}

- (IBAction)closeBtn:(UIButton *)sender {
    
   
    [self close];
    
}

- (IBAction)TouchView:(UIButton *)sender {
    
     self.getTouch(sender.tag);
    [self close];
}

+(instancetype)creatXib
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MIAOShareView" owner:nil options:nil]lastObject];
}

-(void)show
{
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    // 在delegate中初始化新的controller
//    [delegate initTabbarController];
//    // 修改rootViewController
//    [delegate.window addSubview:delegate.tabbarController.view];
//    [self.view removeFromSuperview];
//    delegate.window.rootViewController = delegate.tabbarController;
    [KEYWINDOW addSubview:self];
//   [[UIApplication sharedApplication].delegate.window
//    addSubview:self];
    
    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.ShareVIew.frame = CGRectMake(0, self.frame.size.height - 262, self.frame.size.width, 262);
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)close
{
    [UIView animateWithDuration:0.3f animations:^{
        
        self.ShareVIew.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 262);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
