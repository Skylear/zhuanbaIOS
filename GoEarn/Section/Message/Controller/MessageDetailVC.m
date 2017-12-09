//
//  MessageDetailVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/27.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "MessageDetailVC.h"

@interface MessageDetailVC ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *web;


@end

@implementation MessageDetailVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"文章详情";
    
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _web.backgroundColor = [UIColor clearColor];
    [self requestToGetDetail:self.aid];
    //[_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.adUrl]]];
    _web.delegate = self;
    _web.scalesPageToFit =YES;
    [self.view addSubview:self.web];
    
}
-(void)requestToGetDetail:(NSString*)adStr
{
    NSMutableDictionary   *dic = [NSMutableDictionary dictionary];
    if (adStr) {
        [dic setObject:adStr forKey:@"aid"];
    }
    [MBProgressHUD showIndicator];
    [dic setObject:[NSString stringWithFormat:@"%@",@"1"] forKey:@"uid"];
        __block typeof(self)  weakSelf = self;
    [[[AFNetworkRequest alloc]init] requestWithVC:self URLString:[NSString stringWithFormat:@"%@%@",BASE_URL,GETART_DETAIL] parameters:dic type:NetworkRequestTypeGet resultBlock:^(id responseObject, NSError *error) {
        [MBProgressHUD hideAllHUD];
        if (!error) {
            //清除缓存
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *storage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [storage cookies]) {
                [storage deleteCookie:cookie];
            }
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            
            //一些网页上的图片在线显示不出来，先将html内容保存到本地 然后加载本地文件
            //沙盒中文件
           // NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
          //  NSString *filePath=[path stringByAppendingPathComponent:@"detail.html"];
            //创建数据缓冲
           // NSMutableData *writer = [[NSMutableData alloc] init];
            //将字符串添加到缓冲中
            //[writer appendData:[responseObject[@"data"] dataUsingEncoding:NSUTF8StringEncoding]];
            //将缓冲的数据写入到文件中
          //  [writer writeToFile:filePath atomically:YES];
            NSDictionary *dict = responseObject[@"data"];
            //加载本地文件
           // NSURL *localUrl = [NSURL fileURLWithPath:responseObject];
            NSURL *localUrl = [NSURL URLWithString:dict[@"url"]];
            NSURLRequest *localRequest = [NSURLRequest requestWithURL:localUrl];
            //打开网页
            [weakSelf.web loadRequest:localRequest];
        }else
        {
            [MBProgressHUD showMessage:@"网络错误"];
        }
    }];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //self.title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
