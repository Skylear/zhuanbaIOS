//
//  UserNameVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/9.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "UserNameVC.h"

@interface UserNameVC ()<UITextFieldDelegate>

@end

@implementation UserNameVC
{
    UITextField *NameTF;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self performSelector:@selector(nameSponese) withObject:nil afterDelay:0.8f];
}
-(void)nameSponese{
    [NameTF becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改昵称";
    self.view.backgroundColor = MAINCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *NameV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 50)];
    NameV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:NameV];
    
    NameTF = [[UITextField alloc] initWithFrame:CGRectMake(10,0 , SCREEN_WIDTH-20, 50)];
    NameTF.placeholder = @"请输入昵称";
    NameTF.tintColor = [UIColor grayColor];
    NameTF.delegate = self;
    NameTF.keyboardType = UIKeyboardTypeDefault;
    [NameV addSubview:NameTF];

    // Do any additional setup after loading the view.
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSMutableString *copyString = [textField.text mutableCopy];
    if (copyString.length>0){
        if (_changename) _changename(copyString);
        //修改名称
        [self GetUserUpdateInforRequest:copyString];
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

-(void)GetUserUpdateInforRequest:(NSString*)nameStr{
    NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:string forKey:@"session"];
    [dic setValue:nameStr forKey:@"nickname"];
    
    
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetUserUpdateURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
            [MBProgressHUD showMessage:@"修改成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICERELOAD" object:nil];
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
