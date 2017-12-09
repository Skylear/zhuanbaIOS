//
//  AboutLaojingVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/11/5.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "AboutLaojingVC.h"
#import "ProTool.h"

@interface AboutLaojingVC ()<UIWebViewDelegate>
@property(nonatomic,strong) UIWebView *webView;


@end

@implementation AboutLaojingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAINCOLOR;
    if ([self.title isEqualToString:@"关于捞金"]) {
        self.navigationItem.title = @"关于捞金";
    }else if ([self.title isEqualToString:@"帮助中心"]){
        self.navigationItem.title = @"帮助中心";
    }else if ([self.title isEqualToString:@"用户协议"]){
        self.navigationItem.title = @"用户协议";
    }
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.opaque = NO;
    _webView.userInteractionEnabled = YES;
    _webView.backgroundColor = MAINCOLOR;
    [_webView setScalesPageToFit:YES];
    
    _webView.delegate =self;
    
    [self.view addSubview:self.webView];
    if ([self.title isEqualToString:@"关于捞金"]) {
        NSString *oldAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSLog(@"--->>>>>>old agent :%@", oldAgent);
        NSString *str = [NSString stringWithFormat:@" laojin/%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        NSString *newAgent = [oldAgent stringByAppendingString:str];
        NSLog(@"++++++++++++>>new agent :%@", newAgent);
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        
    }

    NSString * name;
    if ([self.title isEqualToString:@"支持捞金"]) {
        NSString *str =@"https://itunes.apple.com/us/app/lao-jin/id1164775597?l=zh&ls=1&mt=8";
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str]]]];
    }else if ([self.title isEqualToString:@"消息详情"]){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.urlStr]]]];
    }
    else{
    if ([self.title isEqualToString:@"关于捞金"]) {
    name = @"ABOUT_ZB";
    }else if([self.title isEqualToString:@"帮助中心"]){
    name = @"HELP_CORE";
    }else if ([self.title isEqualToString:@"合作洽谈"]){
    name = @"CONTACT_US";
    }else if ([self.title isEqualToString:@"会员权限说明"]){
    name = @"MEMBER_R_D";
    }else if ([self.title isEqualToString:@"用户协议"]){
    name = @"USER_AGREEMENT";
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:name forKey:@"name"];
    AddDic(dic);
        
   NSString *namestring = dic[@"name"];
   NSString *sign       = dic[@"sign"];
   NSString *signString = dic[@"signStr"];
   NSString *signTimestring = dic[@"signTime"];

   NSString *SIGNURL = [NSString stringWithFormat:@"name=%@&sign=%@&signStr=%@&signTime=%@",namestring,sign,signString,signTimestring];
    
//NSString *url =  [NSString stringWithFormat:@"%@%@?%@",KBASE_URL,GetContentUrl,SIGNURL];
  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",KBASE_URL,GetContentUrl,SIGNURL]]]];
    }
    
}




- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView

{
    
    // finished loading, hide the activity indicator in the status bar
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}


/*
 
 Mozilla/5.0 (iPhone; CPU iPhone OS 10_1_1 like Mac OS X) AppleWebKit/602.2.14 (KHTML, like Gecko) Mobile/14B100
 Mozilla/5.0 (iPhone; CPU iPhone OS 10_1_1 like Mac OS X) AppleWebKit/602.2.14 (KHTML, like Gecko) Mobile/14B100 MicroMessenger/6.3.30 NetType/WIFI Language/zh_CN
 **/
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
