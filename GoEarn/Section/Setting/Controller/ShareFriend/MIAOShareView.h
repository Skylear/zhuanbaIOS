//
//  MIAOShareView.h
//  MIAOTUI2
//
//  Created by 余晓辉 on 16/5/21.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIAOShareView : UIView

@property(nonatomic,strong) void(^getTouch)(NSInteger BTNTag);
@property (weak, nonatomic) IBOutlet UIView *ShareVIew;
- (IBAction)closeBtn:(UIButton *)sender;

- (IBAction)TouchView:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *LalTextColor;

@property (weak, nonatomic) IBOutlet UILabel *label1;


@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *label3;


@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;



+(instancetype)creatXib;
-(void)show;
-(void)close;



@end
