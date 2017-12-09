//
//  HomeAgentWebVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/11/7.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "HomeAgentWebVC.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "TimeLabel.h"
#import "HomeCommiteVC.h"
#import "AppDelegate.h"
#import "TKAlertCenter.h"
@interface HomeAgentWebVC ()<NJKWebViewProgressDelegate,PublicAlertViewDelegate,UIGestureRecognizerDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property(nonatomic,strong)UIScrollView  * bgScrollView;
@property(nonatomic,strong)UIWebView *web;
@property(nonatomic,strong)UIView  * footView;
@property(nonatomic,strong)NSString  * toWhereString;
@property (nonatomic,strong) AppDelegate  * appDelegate;
@end

@implementation HomeAgentWebVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];//隐藏 常态时是否隐藏 动画时是否显示
    [self.navigationController.navigationBar addSubview:_progressView];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [_progressView removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:MISSONDONENOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BACKFREFRESH object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.bgScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.scrollEnabled = YES;
    [self.view addSubview:self.bgScrollView];

    
   // DLog(@"jian---_%ld",self.appDelegate.second);
    
    self.title = @"特工任务";
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    self.web.scrollView.bounces = NO;
    self.web.scrollView.showsHorizontalScrollIndicator = NO;
    self.web.scrollView.scrollEnabled = NO;
    [self.web sizeToFit];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _web.backgroundColor = [UIColor clearColor];
    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    _web.delegate = self;
    [self.bgScrollView addSubview:self.web];
    
    UILongPressGestureRecognizer * longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressed.delegate = self;
    [self.web addGestureRecognizer:longPressed];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _web.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    DLog(@"jian---_%ld",self.appDelegate.second);
    
    self.title = self.appDelegate.selectedTypeModel.alias;
    
    DLog(@"self.title---_%@",self.appDelegate.selectedTypeModel.alias);
    
}
- (void)longPressed:(UITapGestureRecognizer*)recognizer{
    
    //只在长按手势开始的时候才去获取图片的url
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [recognizer locationInView:self.web];
    
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *urlToSave = [self.web stringByEvaluatingJavaScriptFromString:js];
    
    if (urlToSave.length == 0) {
        return;
    }
    
    DLog(@"获取到图片地址：%@",urlToSave);
    
    UIAlertController *alet = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"保存图片到本地，方便完成任务！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
        
        UIImage *myImage = [UIImage imageWithData:data];
        
        [self saveImageToPhotos:myImage];
    }];
    [alet addAction:sureAction];
    [alet addAction:cancleAction];
    
    [self presentViewController:alet animated:YES completion:nil];
    
    
}
- (void)saveImageToPhotos:(UIImage*)savedImage

{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}
- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error != NULL){
        [[TKAlertCenter defaultCenter]postAlertWithMessage:@"保存失败"];
       // [MBProgressHUD showError:@"保存失败"];
    }else{
        [[TKAlertCenter defaultCenter]postAlertWithMessage:@"保存成功"];
        //[MBProgressHUD showError:@"保存成功"];
    }
}
//可以识别多个手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    if (progress ==1)
    {
        CGFloat documentHeight = [[_web stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"] floatValue];
        
        //设置到WebView上
        _web.frame = CGRectMake(0, 0, self.view.frame.size.width, documentHeight);
        //获取WebView最佳尺寸（点）
        CGSize frame = [_web sizeThatFits:_web.frame.size];
        
        //再次设置WebView高度（点）
        _web.frame = CGRectMake(0, 0,SCREEN_WIDTH, frame.height);
        
        TimeLabel  * footLabel = [[TimeLabel alloc]initWithFrame:CGRectMake(30,_web.maxY+5, SCREEN_WIDTH-60, 45) withAlign:NSTextAlignmentCenter fromList:NO];
        footLabel.web = _web;
        footLabel.font = Font(16);
        footLabel.text =@"提交任务";
        footLabel.textColor =[UIColor whiteColor];
        footLabel.backgroundColor = UIColorFromRGB(0xff4c61);
        footLabel.layer.cornerRadius = 3;
        footLabel.clipsToBounds = YES;
        if (self.countdown) {
            NSDictionary *dateDic = [NSString dictionaryWithDateString:self.countdown];
            footLabel.second = [dateDic[@"sec"] intValue];
            footLabel.hour = [dateDic[@"hou"] intValue];
            footLabel.minute = [dateDic[@"min"] intValue];
            footLabel.timeString = @"提交任务";
            footLabel.timerBegain = YES;
        }
        footLabel.userInteractionEnabled = YES;
        [footLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commiteMission:)]];
        [self.bgScrollView addSubview:footLabel];
        
        UIButton *dropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dropBtn setFrame:CGRectMake(30,footLabel.maxY+10, SCREEN_WIDTH-60, 45)];
        [dropBtn setBackgroundColor:UIColorFromRGB(0xd9d9d9)];
        dropBtn.titleLabel.font = Font(16);
        dropBtn.layer.cornerRadius = 3;
        dropBtn.clipsToBounds = YES;
        [dropBtn setTitle:@"放弃任务" forState:UIControlStateNormal];
        [dropBtn setTitleColor:UIColorFromRGB(0x8c8c8c) forState:UIControlStateNormal];
        [dropBtn addTarget:self action:@selector(dropAgentMission:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgScrollView addSubview:dropBtn];
        
        self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, frame.height+200);
    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}
//放弃特工任务
-(void)dropAgentMission:(UIButton*)sender
{
    
    PublicAlertView *pub = [[PublicAlertView alloc]initWithTitle:nil message:@"确定放弃特工任务?" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:@"确定" withMsFont:Font(17) withTitleFont:nil];
    [pub show];
    
}
-(void)PublicAlertView:(PublicAlertView *)alert buttonindex:(NSInteger)index
{
    if (index ==1) {
        [MBProgressHUD showIndicator];
        NSMutableDictionary *dataDic =[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",self.utno,@"utno", nil];
        [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,CancelSpyTaskURL] parameters:dataDic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
            [MBProgressHUD hideHUD];
            if (error) {
                [MBProgressHUD showError:@"请求失败，请稍后再试!"];
            }else
            {
                if ([responseObject[@"code"] intValue] ==0) {
                    [MBProgressHUD showMessage:responseObject[@"msg"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }else
                {
                    [MBProgressHUD showError:responseObject[@"msg"]];
                }
                
            }
        }];  
    }
}
-(void)commiteMission:(UIGestureRecognizer*)ges
{

    HomeCommiteVC *vc = [[HomeCommiteVC alloc]init];
    vc.utno = self.utno;
    vc.isAgent = YES;
    vc.countdown = self.countdown;
    vc.submitArr = self.submitArr;
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MISSONDONENOTIFICATION object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
