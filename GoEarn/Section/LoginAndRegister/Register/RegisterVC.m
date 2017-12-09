//
//  RegisterVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/9/29.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "RegisterVC.h"
#import "CustomTextField.h"
#import "CodeButton.h"

@interface RegisterVC ()<UITextFieldDelegate>
@property (nonatomic,strong) CustomTextField *secretTF;
@end

@implementation RegisterVC
{
    CodeButton *_VerificationButton;
    UIButton *registerBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    CustomTextField *phoneTF = [[CustomTextField alloc] initWithFrame:CGRectMake(36, 84, SCREEN_WIDTH-72, 60)font:14];
    phoneTF.Placeholder = @"请输入11位手机号码";
    phoneTF.tag = 1001;
    phoneTF.delegate = self;
    [self.view addSubview:phoneTF];
    
    CustomTextField *codeTF = [[CustomTextField alloc] initWithFrame:CGRectMake(36, phoneTF.bottom, SCREEN_WIDTH-72, 60)font:14];
    codeTF.clearButtonMode = UITextFieldViewModeNever;
    codeTF.clearsOnBeginEditing = NO;
    codeTF.Placeholder = @"请输入验证码";
    codeTF.tag = 1002;
    [self.view addSubview:codeTF];
    
    _VerificationButton = [CodeButton buttonWithType:UIButtonTypeCustom];
    _VerificationButton.frame = CGRectMake(SCREEN_WIDTH-116, codeTF.minY,80, 60);
    _VerificationButton.backgroundColor = [UIColor clearColor];
    [_VerificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _VerificationButton.titleLabel.font =[UIFont boldSystemFontOfSize:14];
    _VerificationButton.timeOut =59;
    [_VerificationButton setTitleColor:UIColorFromRGB(0xd9d9d9) forState:UIControlStateNormal];
    [_VerificationButton addTarget:self action:@selector(veriButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_VerificationButton];
    
    
    _secretTF = [[CustomTextField alloc] initWithFrame:CGRectMake(36, codeTF.bottom, SCREEN_WIDTH-72, 60)font:14];
    _secretTF.Placeholder = @"请输入6-12位非纯数字密码";
    _secretTF.secureTextEntry = YES;
    _secretTF.tag = 1003;
    _secretTF.clearButtonMode = UITextFieldViewModeNever;
    [self.view addSubview:_secretTF];
    
    UIButton *seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seeBtn.frame = CGRectMake(SCREEN_WIDTH-54, _secretTF.top, 18, _secretTF.height);
    [seeBtn setImage:[UIImage imageNamed:@"shadowpassword"] forState:UIControlStateNormal];
    [seeBtn setImage:[UIImage imageNamed:@"showpassword"] forState:UIControlStateSelected];
    [seeBtn addTarget:self action:@selector(seeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seeBtn];

    registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(36, _secretTF.bottom+35, SCREEN_WIDTH-72, 45);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:UIColorFromRGB(0xb9b9bb) forState:UIControlStateNormal];
    registerBtn.enabled = NO;
    registerBtn.titleLabel.font = Font(16);
    registerBtn.backgroundColor = UIColorFromRGB(0xE4E4E4);
    registerBtn.layer.cornerRadius = 6;
    [registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
}
-(void)seeClick:(UIButton*)sender{
    GRLog(@"显示");
    sender.selected  = !sender.selected;
    _secretTF.secureTextEntry = !_secretTF.secureTextEntry;
}

-(void)registerClick{

}


-(void)veriButton:(CodeButton *)btn
{
    
    GRLog(@"验证码");
//    if (![phoneTF.text isValidateMobile]) {
//        [MBProgressHUD showMessage:@"请输入正确格式的手机号"];
//        
//        return ;
//    }
//    else{
//        //获取验证码
//        [self GetCode:(CodeButton *)btn];
//        
//       
//        btn.selected = YES;
//        
//    }
}
#pragma mark - 验证码接口请求
//
//- (void) GetCode:(CodeButton *)btn
//{
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:phoneTF.text forKey:@"phone"];
//    [dic setObject:@"3" forKey:@"type"];
//    AddDic(dic);
//    
//    [[AFEngine share] POST:[NSString stringWithFormat:@"%@%@",BASE_URL,CodeURL] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
//     {
//         
//         if (responseObject) {
//             [btn startCountdown];
//             logButton.enabled = YES;
//             logButton.backgroundColor =[UIColor colorWithRed:0.81f green:0.00f blue:0.00f alpha:1.00f];
//             GRLog(@"message:%@",[responseObject objectForKey:@"msg"]);
//             AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
//             MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:app.window];
//             [app.window addSubview:HUD];
//             HUD.labelText = @"提示";
//             HUD.detailsLabelText = @"发送成功 注意查收短信";
//             [mailTextFiled becomeFirstResponder];
//             HUD.mode = MBProgressHUDModeText;
//             [HUD showAnimated:YES whileExecutingBlock:^{
//                 sleep(1.0);
//             } completionBlock:^{
//                 [HUD removeFromSuperview];
//             }];
//             
//             
//             
//         }else
//         {
//             
//             logButton.enabled = NO;
//             logButton.backgroundColor =[UIColor colorWithRed:1.000 green:0.400 blue:0.400 alpha:1.000];
//             [MBProgressHUD showMessage:@"链接错误"];
//         }
//         
//         
//         
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         [MBProgressHUD showError:@"网络异常"];
//     }];
//    
//    
//    
//    
//}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *copyString = [textField.text mutableCopy];
    [copyString replaceCharactersInRange:range withString:string];
    
    NSInteger integer = textField.tag;
    if (integer==1001) {
        if (string.length>0) {
            [_VerificationButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [registerBtn setBackgroundColor:UIColorFromRGB(0xFF4c61)];
            registerBtn.enabled = YES;
        }else{
            [_VerificationButton setTitleColor:UIColorFromRGB(0xd9d9d9) forState:UIControlStateNormal];
            [registerBtn setTitleColor:UIColorFromRGB(0xb9b9bb) forState:UIControlStateNormal];
            [registerBtn setBackgroundColor:UIColorFromRGB(0xE4E4E4)];
        
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [_VerificationButton setTitleColor:UIColorFromRGB(0xd9d9d9) forState:UIControlStateNormal];
    [registerBtn setTitleColor:UIColorFromRGB(0xb9b9bb) forState:UIControlStateNormal];
    [registerBtn setBackgroundColor:UIColorFromRGB(0xE4E4E4)];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
