//
//  BindingWeChatVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/13.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "BindingWeChatVC.h"

@interface BindingWeChatVC ()<UIWebViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIScrollView  * bgScrollView;
@end

@implementation BindingWeChatVC
{
    UIButton *btn;
    UITextField *TF;
}
-(void)viewWillAppear:(BOOL)animated{
    [self performSelector:@selector(loadRequest) withObject:self afterDelay:0.1f];
}
-(void)loadRequest{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  KBASE_URL,GetBindingWechatURL]]]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAINCOLOR;
    
    self.bgScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.scrollEnabled = YES;
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.webView];
    
    self.jsContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //将miaomiao对象指向自身
    self.jsContext[@"miaomiao"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        DLog(@"异常信息：%@", exceptionValue);
    };
    
//    [self BindingDataRequest];
   
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,0)];
        _webView.opaque = NO;
        _webView.userInteractionEnabled = YES;
        _webView.backgroundColor = MAINCOLOR;
        [_webView setScalesPageToFit:YES];
        [_webView sizeToFit];
        _webView.delegate =self;
    }
    return _webView;
}

- (void)copyToApp:(NSArray*)array{

    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:array[0]];
    [MBProgressHUD showMessage:@"已复制到粘贴板!"];
    
}

#pragma mark - UIWebViewDelegate

-(void)buttonClick{
    [self BindingWeChatRequest];

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    CGFloat documentHeight = [[_webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"] floatValue];
    
    //设置到WebView上
    _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, documentHeight-300);
    //获取WebView最佳尺寸（点）
//    CGSize frame = [_webView sizeThatFits:_webView.frame.size];
//    
//    //再次设置WebView高度（点）
//    _webView.frame = CGRectMake(0, 0,SCREEN_WIDTH, frame.height);
    DLog(@"-----------web页heigh---%f",documentHeight);
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, documentHeight);
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(15, _webView.bottom+10, SCREEN_WIDTH-30, 45)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollView addSubview:baseView];
    
    UILabel *yanLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 67, baseView.height)];
    yanLab.text = @"验证码:";
    yanLab.textColor = UIColorFromRGB(0x333333);
    yanLab.textAlignment = NSTextAlignmentRight;
    yanLab.font = Font(15);
    [baseView addSubview:yanLab];
    
    TF = [[UITextField alloc] initWithFrame:CGRectMake(yanLab.right+5, 0, baseView.width-yanLab.width, baseView.height)];
    TF.font = Font(15);
    TF.delegate =self;
    TF.placeholder = @"请输入微信验证码";
    [baseView addSubview:TF];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, baseView.bottom+15, SCREEN_WIDTH-30, 45);
    [btn setTitle:@"绑定微信" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    btn.backgroundColor = UIColorFromRGB(0xE4E4E4);
    btn.titleLabel.font = Font(15);
    btn.layer.cornerRadius = 3;
    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:btn];
    
    
}
//textfielddelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *mutableStr = [textField.text mutableCopy];
    [mutableStr replaceCharactersInRange:range withString:string];
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length>0) {
        btn.backgroundColor = UIColorFromRGB(0xFF4c61);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.enabled = YES;
        return YES;
    }else{
        btn.backgroundColor = UIColorFromRGB(0xE4E4E4);
        [btn setTitleColor:UIColorFromRGB(0xb9b9bb) forState:UIControlStateNormal];
        btn.enabled = NO;
        return YES;
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    reason = UITextFieldDidEndEditingReasonCommitted;
    
}

-(void)BindingWeChatRequest{
    
    NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:string forKey:@"session"];
    
    [dic setValue:TF.text forKey:@"code"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetBindingWechatURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICERELOAD" object:nil];
            [NSThread sleepForTimeInterval:0.5];
            [MBProgressHUD showMessage:@"微信绑定成功!"];
            UserDefaultSetObjectForKey(@"1", @"bindingwechat")
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
