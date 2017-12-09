//
//  LoginVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/9/29.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "LoginVC.h"
#import "CustomTextField.h"
#import "RegisterVC.h"
#import "EditDataVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    [self CreateUI];
    // Do any additional setup after loading the view.
}
-(void)addClick{
    EditDataVC *edit = [[EditDataVC alloc] init];
    [self.navigationController pushViewController:edit animated:YES];
}
-(void)CreateUI{
    UIImageView *headerAvater = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-76)/2, 97, 76, 76)];
    headerAvater.image = [UIImage imageNamed:@"huhiu"];
    headerAvater.cornerRadius = 15;
    [self.view addSubview:headerAvater];
    CustomTextField *phoneTF = [[CustomTextField alloc] initWithFrame:CGRectMake(36,headerAvater.bottom+45, SCREEN_WIDTH-72, 60) font:14];
    phoneTF.Placeholder = @"请输入11位手机号码";
    [self.view addSubview:phoneTF];
    
    CustomTextField *secretTF = [[CustomTextField alloc] initWithFrame:CGRectMake(36, phoneTF.bottom, SCREEN_WIDTH-72, 60) font:14];
    secretTF.Placeholder = @"请输入密码";
    [self.view addSubview:secretTF];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(36, secretTF.bottom+35, SCREEN_WIDTH-72, 45);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = Font(16);
    loginBtn.backgroundColor = UIColorFromRGB(0xFF4c61);
    loginBtn.layer.cornerRadius = 6;
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UILabel *registerLab = [[UILabel alloc] initWithFrame:CGRectMake(36, loginBtn.bottom+25, 65, 15)];
    registerLab.text = @"还没账号?";
    registerLab.font = Font(14);
    registerLab.textColor = UIColorFromRGB(0x999999);
    [self.view addSubview:registerLab];
    
    UIButton *regiserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regiserBtn.frame = CGRectMake(registerLab.right+15, loginBtn.bottom+25, 50, 15);
    [regiserBtn setTitle:@"去注册" forState:UIControlStateNormal];
    [regiserBtn setTitleColor:UIColorFromRGB(0x486edc) forState:UIControlStateNormal];
    regiserBtn.titleLabel.font = Font(16);
    [regiserBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regiserBtn];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(SCREEN_WIDTH-106,loginBtn.bottom+25, 70    , 15);
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = Font(15);
    [forgetBtn addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
}
//登录
-(void)loginClick{

}
//注册
-(void)registerClick{
    RegisterVC *registervc = [[RegisterVC alloc] init];
    [self.navigationController pushViewController:registervc animated:YES];
}
//忘记密码
-(void)forgetClick{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
