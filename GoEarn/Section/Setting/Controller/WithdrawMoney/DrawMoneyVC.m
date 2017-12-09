//
//  DrawMoneyVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/13.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "DrawMoneyVC.h"
#import "LTPickerView.h"
#import "WaitMoneyVC.h"
#import "SystemModel.h"
#import "PersonalDataVC.h"


@interface DrawMoneyVC ()

@property (nonatomic,strong) UIButton *selectedBtn;
@property (nonatomic,strong) NSString  * moneyString;
@end

@implementation DrawMoneyVC
{
    UILabel *moneyLab;
    UIButton *moneyBtn;
    NSArray *cashArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    UserDefaultSetObjectForKey(responseObject[@"data"][@"cash_desc"], @"CASH_DESC");
//    UserDefaultSetObjectForKey(responseObject[@"data"][@"money_list"], @"MONEY_LIST");
//    NSData *localData = [[NSUserDefaults standardUserDefaults]valueForKey:SAVESystemMessage];
//    SystemModel *systemModel = [NSKeyedUnarchiver unarchiveObjectWithData:localData];
//    SystemModel *systemModel = UserDefaultObjectForKey(@"MONEY_LIST");
    cashArray = UserDefaultObjectForKey(@"MONEY_LIST");
    
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 55)];
    oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneView];
    
    UILabel *tixianLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 50, oneView.height)];
    tixianLab.textColor = UIColorFromRGB(0x333333);
    tixianLab.text = @"提现到";
    tixianLab.font =Font(15);
    [oneView addSubview:tixianLab];
    
    UILabel *walletLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-82, 0, 70, oneView.height)];
    walletLab.text = @"微信钱包";
    walletLab.textColor = UIColorFromRGB(0x666666);
    walletLab.font = Font(15);
    [oneView addSubview:walletLab];
    
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(0,oneView.bottom+ 10, SCREEN_WIDTH, 133)];
    twoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:twoView];
    
    UILabel *TiMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 70, 45)];
    TiMoneyLab.textColor = UIColorFromRGB(0x333333);
    TiMoneyLab.text = @"提现金额";
    TiMoneyLab.font =Font(15);
    [twoView addSubview:TiMoneyLab];
    
    moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(TiMoneyLab.right+10, 0, 120, 45)];
    moneyLab.text = [NSString stringWithFormat:@"(可用余额%@元)",[LWAccountTool account].money];
    moneyLab.textColor = UIColorFromRGB(0x999999);
    moneyLab.font = Font(14);
    moneyLab.userInteractionEnabled = YES;
    [twoView addSubview:moneyLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, moneyLab.bottom-0.5,SCREEN_WIDTH-12, 0.5)];
    line.backgroundColor = MAINCOLOR;
    [twoView addSubview:line];
    
    for (int i = 0; i<cashArray.count; i++) {
        moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moneyBtn.frame = CGRectMake(12+i*((SCREEN_WIDTH-44)/3+10), line.bottom+15, (SCREEN_WIDTH-44)/3, 60);
        [moneyBtn setTitle:[NSString stringWithFormat:@"%@",cashArray[i]] forState:UIControlStateNormal];
        moneyBtn.titleLabel.font = Font(18);
        [moneyBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [moneyBtn setTitleColor:UIColorFromRGB(0xff4c61) forState:UIControlStateSelected];
        moneyBtn.borderColor = UIColorFromRGB(0xe1e6e6);
        moneyBtn.borderWidth = 1;
        moneyBtn.tag = 990+i;
        moneyBtn.layer.cornerRadius = 3;
        [moneyBtn addTarget:self action:@selector(moneyClick:) forControlEvents:UIControlEventTouchUpInside];
        [twoView addSubview:moneyBtn];
    }
    
    NSString *textStr = [NSString stringWithFormat:@"%@",UserDefaultObjectForKey(@"CASH_DESC")];
    CGSize maxTextSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 24, CGFLOAT_MAX);
    CGSize textSize = [textStr sizeWithFont:Font(13) maxSize:maxTextSize];
//    CGFloat textViewW = textSize.width;
    CGFloat textViewH = textSize.height;
    UILabel *ortLab = [[UILabel alloc] initWithFrame:CGRectMake(12, twoView.bottom+15, SCREEN_WIDTH-24, textViewH+5)];
//    ortLab.text = [NSString stringWithFormat:@"可用余额%@元(满10元可提现)预计24小时之内到账",[LWAccountTool account].money];
    ortLab.text = textStr;
    ortLab.textColor = UIColorFromRGB(0x999999);
    ortLab.numberOfLines = 0;
    ortLab.font = Font(13);
    [self.view addSubview:ortLab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(12, ortLab.bottom+20, SCREEN_WIDTH-24, 45);
    [button setTitle:@"确认提交" forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = UIColorFromRGB(0xff4c61);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view.
}

-(void)moneyClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    
    NSInteger tag = sender.tag-990;
    UIButton *btno = (UIButton *)[self.view viewWithTag:sender.tag];
    UIButton *b1  =  (UIButton *)[self.view viewWithTag:990];
    UIButton *b2  =  (UIButton *)[self.view viewWithTag:991];
    UIButton *b3  =  (UIButton *)[self.view viewWithTag:992];
    GRLog(@"%ld",tag);
    if (sender!= self.selectedBtn) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
    }else{
        self.selectedBtn.selected = YES;
    }
    
    if (tag==0) {
        if (sender.selected) {
            self.moneyString = [NSString stringWithFormat:@"%@",cashArray[0]];
          btno.borderColor = UIColorFromRGB(0xff4c61);
            b2.borderColor = UIColorFromRGB(0xe1e6e6);
            [b2 setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            b3.borderColor = UIColorFromRGB(0xe1e6e6);
            [b3 setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        }else{
            btno.borderColor = UIColorFromRGB(0xe1e6e6);
        }
    }else if (tag==1){
        if (sender.selected) {
            self.moneyString = [NSString stringWithFormat:@"%@",cashArray[1]];
          btno.borderColor = UIColorFromRGB(0xff4c61);
            b1.borderColor = UIColorFromRGB(0xe1e6e6);
            [b1 setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            b3.borderColor = UIColorFromRGB(0xe1e6e6);
            [b3 setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        }else{
        btno.borderColor = UIColorFromRGB(0xe1e6e6);
        }
    }else if (tag==2){
        if (sender.selected) {
            self.moneyString = [NSString stringWithFormat:@"%@",cashArray[2]];
          btno.borderColor = UIColorFromRGB(0xff4c61);
            b1.borderColor = UIColorFromRGB(0xe1e6e6);
            [b1 setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            b2.borderColor = UIColorFromRGB(0xe1e6e6);
            [b2 setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        }else{
        btno.borderColor = UIColorFromRGB(0xe1e6e6);
        }
    }
    
    if (sender.selected) {
        [btno setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }
}

-(void)buttonClick{
    if ([self.moneyString intValue]==0) {
        [MBProgressHUD showSuccess:@"请选择提现金额"];
    }else{
        [self GetCashMoneyRequest];
    }
   
}


-(void)GetCashMoneyRequest{
    
    
    NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:string forKey:@"session"];
    [dic setValue:self.moneyString forKey:@"money"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetCashURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICERELOAD" object:nil];
            WaitMoneyVC * wait = [[WaitMoneyVC alloc]init];
            wait.moneyString = self.moneyString;
            wait.title = @"提现";
            [self.navigationController pushViewController:wait animated:YES];
        }else{
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
