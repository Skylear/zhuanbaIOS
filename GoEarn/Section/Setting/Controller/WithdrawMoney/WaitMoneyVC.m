//
//  WaitMoneyVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/29.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "WaitMoneyVC.h"

@interface WaitMoneyVC ()

@end

@implementation WaitMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *V = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    V.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:V];
    
    UIImageView *IMg = [[UIImageView alloc] initWithFrame:CGRectMake(0, V.bottom, SCREEN_WIDTH, 5)];
    IMg.image = [UIImage imageNamed:@"wave_check_cash"];
    [self.view addSubview:IMg];
    
    UIImageView *avaterIMG = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-98)/2, 25, 98, 98)];
    avaterIMG.image = [UIImage imageNamed:@"check_cash"];
    [self.view addSubview:avaterIMG];
    
    UILabel *sLab = [[UILabel alloc] initWithFrame:CGRectMake(0, avaterIMG.bottom+28, SCREEN_WIDTH, 15)];
    
    sLab.text = [NSString stringWithFormat:@"提现￥%@已经提交申请",self.moneyString];
    sLab.textAlignment = NSTextAlignmentCenter;
    sLab.textColor = UIColorFromRGB(0xff8c19);
    sLab.font = Font(17);
    [self.view addSubview:sLab];
    
    UILabel *KLab = [[UILabel alloc] initWithFrame:CGRectMake(0, sLab.bottom+20, SCREEN_WIDTH, 15)];
    
    KLab.text = @"工作日15:30前提现,当日19:00前到账";
    KLab.textAlignment = NSTextAlignmentCenter;
    KLab.textColor = UIColorFromRGB(0x808080);
    KLab.font = Font(14);
    [self.view addSubview:KLab];
    
    UILabel *PLab = [[UILabel alloc] initWithFrame:CGRectMake(0, KLab.bottom+10, SCREEN_WIDTH, 15)];
    PLab.textAlignment = NSTextAlignmentCenter;
    PLab.text = @"工作日15:30后提现,当日19:00后到账";
    PLab.textColor = UIColorFromRGB(0x808080);
    PLab.font = Font(14);
    [self.view addSubview:PLab];
    
    
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(35, V.bottom+50,SCREEN_WIDTH-70, 45);
    [Btn setTitle:@"返回" forState:UIControlStateNormal];
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Btn.titleLabel.font = Font(16);
    Btn.backgroundColor = UIColorFromRGB(0xff4c61);
    [Btn addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    Btn.layer.cornerRadius = 3;
    [self.view addSubview:Btn];
    
    
    // Do any additional setup after loading the view.
}

-(void)ButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
