//
//  ConpendVC.m
//  writeApp
//
//  Created by miaomiaokeji on 2016/10/12.
//  Copyright © 2016年 ios03. All rights reserved.
//

#import "ConpendVC.h"
#import "RegisterTextField.h"
#import "CodeButton.h"

@interface ConpendVC ()<UITextFieldDelegate>
@property (nonatomic,strong) UIView       * naviView;

@end

@implementation ConpendVC
{
    RegisterTextField *phoneTF;
    RegisterTextField *codeTF;
    CodeButton *_VerificationButton;
    UIButton *quedingBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAINCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //自定义导航条
//    [self.view addSubview:[self naviView]];

    [self createUI];
    // Do any additional setup after loading the view.
}



-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createUI{

    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    
    phoneTF = [[RegisterTextField alloc] initWithFrame:CGRectMake(12, 20, SCREEN_WIDTH-100, 60)];
    phoneTF.Placeholder = @"请输入11位手机号码";
    phoneTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signphone"]];
    phoneTF.delegate = self;
    phoneTF.tintColor = [UIColor grayColor];
    [backview addSubview:phoneTF];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, phoneTF.bottom, SCREEN_WIDTH-12, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xe1e6e6);
    [backview addSubview:line];
    
    
    _VerificationButton = [CodeButton buttonWithType:UIButtonTypeCustom];
    _VerificationButton.frame = CGRectMake(SCREEN_WIDTH-116, phoneTF.bottom,100, 60);
    _VerificationButton.backgroundColor = [UIColor clearColor];
    [_VerificationButton setTitle:@"获取语音验证码" forState:UIControlStateNormal];
    _VerificationButton.titleLabel.font =[UIFont boldSystemFontOfSize:13];
    _VerificationButton.timeOut =59;
    [_VerificationButton setTitleColor:UIColorFromRGB(0xd9d9d9) forState:UIControlStateNormal];
    _VerificationButton.enabled = NO;
    [_VerificationButton addTarget:self action:@selector(voiceButton:) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:_VerificationButton];
    
    codeTF = [[RegisterTextField alloc] initWithFrame:CGRectMake(12, phoneTF.bottom, SCREEN_WIDTH-100, 60)];
    codeTF.clearButtonMode = UITextFieldViewModeNever;
    codeTF.clearsOnBeginEditing = NO;
    codeTF.Placeholder = @"请输入验证码";
    codeTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"securitycode"]];
    [backview addSubview:codeTF];
    
    quedingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quedingBtn.frame = CGRectMake(12, codeTF.bottom+35, SCREEN_WIDTH-24, 40);
    [quedingBtn setTitle:@"确定" forState:UIControlStateNormal];
    quedingBtn.titleLabel.font = Font(16);
    quedingBtn.layer.cornerRadius = 3;
    quedingBtn.enabled =NO;
    [quedingBtn setTitleColor:UIColorFromRGB(0xb9b9bb) forState:UIControlStateNormal];
    quedingBtn.backgroundColor = UIColorFromRGB(0xe4e4e4);
    [quedingBtn addTarget:self action:@selector(quedingBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quedingBtn];
    
}

-(void)quedingBtn:(UIButton*)sender{
    if ([codeTF.text isEmptyString]) {
        [MBProgressHUD showMessage:@"请输入验证码!"];
    }else{
    
        [self GetBindPhoneRequest];
    }
    
}
//绑定手机号
-(void)GetBindPhoneRequest{
    NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:string forKey:@"session"];
    [dic setValue:phoneTF.text forKey:@"phone"];
    [dic setValue:codeTF.text forKey:@"code"];
    
    __weak typeof(self) weakSelf = self;
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetUserBindPhoneURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICERELOAD" object:nil];
            [NSThread sleepForTimeInterval:0.5];
            [MBProgressHUD showMessage:@"手机绑定成功!"];
            UserDefaultSetObjectForKey(@"1", @"bindingPhone");
            [self.navigationController popViewControllerAnimated:YES];

        }else if ([responseObject[@"code"] intValue] ==60003){
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
        
        else
        {
            [MBProgressHUD showMessage:@"绑定失败!"];
        }

    }];
}

#pragma mark - UItextFieldDelegate
//限制文本输入
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSMutableString *textString = [textField.text mutableCopy];
    [textString replaceCharactersInRange:range withString:string];
    CGFloat  textValue  = textString.length;
    
        if (textValue>11) {
            return NO;
    }
    
        if (textValue>0) {
            quedingBtn.backgroundColor = UIColorFromRGB(0xff4c61);
            quedingBtn.enabled = YES;
            [quedingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_VerificationButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            _VerificationButton.enabled = YES;
        }else{
            [quedingBtn setTitleColor:UIColorFromRGB(0xb9b9bb) forState:UIControlStateNormal];
            quedingBtn.backgroundColor = UIColorFromRGB(0xe4e4e4);
            quedingBtn.enabled = NO;
            [_VerificationButton setTitleColor:UIColorFromRGB(0xd9d9d9) forState:UIControlStateNormal];
            _VerificationButton.enabled = NO;
        }
        if (textValue <=11)
        {
            return  YES;
        } else {
            return NO;
        }

    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField;{
    [quedingBtn setTitleColor:UIColorFromRGB(0xb9b9bb) forState:UIControlStateNormal];
    quedingBtn.backgroundColor = UIColorFromRGB(0xe4e4e4);
    quedingBtn.enabled = NO;
    [_VerificationButton setTitleColor:UIColorFromRGB(0xd9d9d9) forState:UIControlStateNormal];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

-(void)voiceButton:(CodeButton *)btn{
    if (![phoneTF.text isValidateMobile]) {
        [MBProgressHUD showMessage:@"请输入正确格式的手机号"];
        
        return ;
    }
    else{
        //获取验证码
        [self GetCode:(CodeButton *)btn];
        btn.selected = YES;
    }
    
}
//语音验证码
-(void)GetCode:(CodeButton *)btn{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:phoneTF.text forKey:@"phone"];
    [dic setObject:@"1" forKey:@"type"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetVoiceURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
           
        AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
         MBProgressHUD*HUD = [[MBProgressHUD alloc] initWithView:app.window];
         [app.window addSubview:HUD];
         HUD.labelText = @"提示";
         HUD.detailsLabelText = @"正在发送语音信息!";
         [codeTF becomeFirstResponder];
         HUD.mode = MBProgressHUDModeText;
         [HUD showAnimated:YES whileExecutingBlock:^{
             sleep(1.0);
         } completionBlock:^{
             [HUD removeFromSuperview];
         }];

            
        }else
        {
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
    }];
    


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
