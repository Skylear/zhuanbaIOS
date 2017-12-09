//
//  HomeWebVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/10.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "HomeWebVC.h"
#import "PublicAlertView.h"
#import "WXApi.h"
#import "UIDevice-Hardware.h"
#import "TimeLabel.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "FYHomeBusinessView.h"
#import "OpenOther.h"
#import "LocalNotificationTool.h"
#import "HomeCommiteVC.h"

@interface HomeWebVC ()<PublicAlertViewDelegate,NJKWebViewProgressDelegate,FYHomeBusinessDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property(nonatomic,strong)NSString  * appName;

@property(nonatomic,strong)UIScrollView  * bgScrollView;
//商家
@property(nonatomic,strong)NSArray  * bussinessArr;
//商家图片
@property(nonatomic,strong)NSString  * bussinessUrl;
//商家金额
@property(nonatomic,strong)NSString  * bussinessMoney;

@property(nonatomic,strong)UIWebView *web;
@property(nonatomic,strong)UIView  * footView;
@property(nonatomic,strong)NSString  * toWhereString;
@property(nonatomic,strong)AppDelegate * appDelegate;

@property (nonatomic,assign) CGFloat  CountDown;
@end

@implementation HomeWebVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timeOut) name:MISSONDONENOTIFICATION object:nil];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];//隐藏 常态时是否隐藏 动画时是否显示
    [self.navigationController.navigationBar addSubview:_progressView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backInLocak:) name:BACKINLOCAL object:nil];
}
-(void)backInLocak:(NSNotification*)noti
{
    if ([UserDefaultObjectForKey(BACKINLOCAL) intValue] ==1)
    {
        UserDefaultSetObjectForKey(@"0", BACKINLOCAL)
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [_progressView removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MISSONDONENOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BACKFREFRESH object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BACKINLOCAL object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.CountDown = 1.0;
    
    self.bgScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.scrollEnabled = YES;
    [self.view addSubview:self.bgScrollView];
    
    self.appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];

    DLog(@"jian---_%ld",(long)self.appDelegate.second);
    
    self.title = self.appDelegate.selectedTypeModel.alias;
    
    DLog(@"self.title---_%@",self.appDelegate.selectedTypeModel.alias);
    
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
     self.web.scrollView.bounces = NO;
     self.web.scrollView.showsHorizontalScrollIndicator = NO;
     self.web.scrollView.scrollEnabled = NO;
    [self.web sizeToFit];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _web.backgroundColor = [UIColor clearColor];
    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.appDelegate.selectedUrl]]];
    _web.delegate = self;
    [self.bgScrollView addSubview:self.web];
    
    
    self.jsContext = [_web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //将miaomiao对象指向自身
    self.jsContext[@"miaomiao"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        DLog(@"异常信息：%@", exceptionValue);
    };
    
    DLog(@"urlst====%@",self.appDelegate.selectedUrl);
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _web.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
    if (progress ==1&&[self.appDelegate.selectedTypeModel.ID intValue] ==5) {
        
        CGFloat documentHeight = [[_web stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"] floatValue];
        
        //设置到WebView上
        _web.frame = CGRectMake(0, 0, self.view.frame.size.width, documentHeight);
        //获取WebView最佳尺寸（点）
        CGSize frame = [_web sizeThatFits:_web.frame.size];
        
        //再次设置WebView高度（点）
        _web.frame = CGRectMake(0, 0,SCREEN_WIDTH, frame.height);
        
        TimeLabel  * footLabel = [[TimeLabel alloc]initWithFrame:CGRectMake(30,_web.maxY+5, SCREEN_WIDTH-60, 45) withAlign:NSTextAlignmentCenter fromList:NO];
        footLabel.font = Font(16);
        footLabel.text = @"去做任务";
        footLabel.web = _web;
        footLabel.textColor =[UIColor whiteColor];
        footLabel.backgroundColor = UIColorFromRGB(0xff4c61);
        footLabel.layer.cornerRadius = 3;
        footLabel.clipsToBounds = YES;
        if (self.appDelegate.selectedListModel.countdown) {
            NSDictionary *dateDic = [NSString dictionaryWithDateString:self.appDelegate.timeOutString];
            footLabel.second = [dateDic[@"sec"] intValue];
            footLabel.hour = [dateDic[@"hou"] intValue];
            footLabel.minute = [dateDic[@"min"] intValue];
            footLabel.timeString = @"去做任务";
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
        [dropBtn addTarget:self action:@selector(dropBussinessMission:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgScrollView addSubview:dropBtn];
        
        self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, frame.height+180);
    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"] floatValue];
    
    //设置到WebView上
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, documentHeight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];

    //再次设置WebView高度（点）
    webView.frame = CGRectMake(0, 0,SCREEN_WIDTH, frame.height);
    
    DLog(@"-----------web页heigh---%f",documentHeight);

    if ([self.appDelegate.selectedTypeModel.ID intValue]==1)
    {
        TimeLabel  * footLabel = [[TimeLabel alloc]initWithFrame:CGRectMake(30,_web.maxY+10, SCREEN_WIDTH-60, 45) withAlign:NSTextAlignmentCenter fromList:NO];
        footLabel.web = webView;
        footLabel.font = Font(16);
        footLabel.text =@"放弃任务";
        footLabel.textColor =UIColorFromRGB(0x8c8c8c);
        footLabel.backgroundColor = UIColorFromRGB(0xd9d9d9);
        footLabel.layer.cornerRadius = 3;
        footLabel.clipsToBounds = YES;
        if (self.appDelegate.selectedListModel.countdown) {
            NSDictionary *dateDic = [NSString dictionaryWithDateString:self.appDelegate.timeOutString];
            footLabel.second = [dateDic[@"sec"] intValue];
            footLabel.hour = [dateDic[@"hou"] intValue];
            footLabel.minute = [dateDic[@"min"] intValue];
            footLabel.timeString = @"放弃任务";
            footLabel.timerBegain = YES;
        }
        footLabel.userInteractionEnabled = YES;
        [footLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dropMission:)]];
        [self.bgScrollView addSubview:footLabel];
        
        self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, frame.height+120);
        
    }else if ([self.appDelegate.selectedTypeModel.ID intValue] ==3)
    {
        UIButton *openAppBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [openAppBtn setFrame:CGRectMake(30,_web.maxY+10, SCREEN_WIDTH-60, 45)];
        [openAppBtn setBackgroundColor:UIColorFromRGB(0xffb84c)];
        openAppBtn.titleLabel.font = Font(16);
        openAppBtn.layer.cornerRadius = 3;
        openAppBtn.clipsToBounds = YES;
        [openAppBtn setTitle:@"打开APP" forState:UIControlStateNormal];
        [openAppBtn addTarget:self action:@selector(openAppBtn:) forControlEvents:UIControlEventTouchUpInside];
        [openAppBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.bgScrollView addSubview:openAppBtn];
        
        TimeLabel  * footLabel = [[TimeLabel alloc]initWithFrame:CGRectMake(30,openAppBtn.maxY+10, SCREEN_WIDTH-60, 45) withAlign:NSTextAlignmentCenter fromList:NO];
        footLabel.web = webView;
        footLabel.textColor =[UIColor whiteColor];
        footLabel.backgroundColor = UIColorFromRGB(0xff4c61);
        footLabel.font = Font(16);
        footLabel.text =@"提交任务";
        footLabel.layer.cornerRadius = 3;
        footLabel.clipsToBounds = YES;
        if (self.appDelegate.selectedListModel.countdown) {
            NSDictionary *dateDic = [NSString dictionaryWithDateString:self.appDelegate.timeOutString];
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
        [dropBtn addTarget:self action:@selector(dropAppMission:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgScrollView addSubview:dropBtn];
        
        self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, frame.height+240);
        
        
    }
}

//打开App
-(void)openAppBtn:(UIButton*)sender
{
    BOOL ISOK = [OpenOther findOther:self.appDelegate.urlScheme];
    if (ISOK ==YES)
    {
        //打开时上报
        NSString * open_report = [NSString stringWithFormat:@"%@",self.appDelegate.reportDic[@"open_report"]];
        DLog(@"open_report-----%@",open_report);
        BOOL isNeed =NO;
        if ([UserDefaultObjectForKey(OPENMORE) intValue] ==0||UserDefaultObjectForKey(OPENMORE)==nil) {
            isNeed =YES;
        }
        if ([open_report isEqualToString:@"1"]&&isNeed ==YES) {
            UserDefaultSetObjectForKey(@"1", OPENMORE)
            [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,APPSEARCHREPORT] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",self.appDelegate.missionID,@"utno",@"2",@"time", nil] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
                DLog(@"app 任务上报---%@",responseObject);
                if (error) {
                    [MBProgressHUD showError:@"请求失败，请稍后再试!"];
                }else
                {
                    if ([responseObject[@"code"] intValue] ==0)
                    {
                        //打开app的任务是否在运行
                        if (self.appDelegate.openAppTimer ==nil&&self.appDelegate.second >0) {
                            [self.appDelegate.appOverTimer invalidate];
                            self.appDelegate.appOverTimer = nil;
                            
                            //找到这个app先打开然后进行倒计时
                            [OpenOther openOther:self.appDelegate.urlScheme];
                            
                            [LocalNotificationTool registerLocalNotification:0 message:@"任务计时开始，请保持打开状态！"];
                            
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                self.appDelegate.openAppTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
                                
                                [[NSRunLoop currentRunLoop] run];
                                
                            });
                        }else
                        {
                            //找到这个app先打开然后进行倒计时
                            [OpenOther openOther:self.appDelegate.urlScheme];
                        }
  
                    }else
                    {
                        self.appDelegate.second = 0;
                        [self.appDelegate.openAppTimer invalidate];
                        self.appDelegate.selectedListModel = nil;
                        self.appDelegate.openAppTimer = nil;
                        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                            
                            UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"温馨提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action  = [UIAlertAction actionWithTitle:@"好的,我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                            [alt addAction:action];
                            [self presentViewController:alt animated:YES completion:nil];
                        }else
                        {
                            [LocalNotificationTool registerLocalNotification:0 message:responseObject[@"msg"]];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                }
            }];
        }else
        {
        //打开app的任务是否在运行
        if (self.appDelegate.openAppTimer ==nil&&self.appDelegate.second >0) {
            [self.appDelegate.appOverTimer invalidate];
            self.appDelegate.appOverTimer = nil;
            
            //找到这个app先打开然后进行倒计时
            [OpenOther openOther:self.appDelegate.urlScheme];
            
            [LocalNotificationTool registerLocalNotification:0 message:@"任务计时开始，请保持打开状态！"];
            DLog(@"手动打开----计时开始。。。。。。。。");
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                self.appDelegate.openAppTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
                
                [[NSRunLoop currentRunLoop] run];
                
            });
        }else
        {
            //找到这个app先打开然后进行倒计时
            [OpenOther openOther:self.appDelegate.urlScheme];
        }
     }

    }else
    {
        [MBProgressHUD showError:@"请您去AppStore下载该应用！"];
        
        [self performSelector:@selector(goAppStore) withObject:nil afterDelay:1.5];
        //搜索时上报
        NSString *search_report = [NSString stringWithFormat:@"%@",self.appDelegate.reportDic[@"search_report"]];
        BOOL isNeed =NO;
        if ([UserDefaultObjectForKey(SEARCHMORE) intValue] ==0||UserDefaultObjectForKey(SEARCHMORE)==nil) {
            isNeed =YES;
        }

        DLog(@"search_report-----%@",search_report);
        if ([search_report isEqualToString:@"1"]&&isNeed ==YES) {
            UserDefaultSetObjectForKey(@"1", SEARCHMORE)
            [self requestAppSearchReport:@"1"];
        }
    }
    
}
//APP任务上报
- (void)requestAppSearchReport:(NSString*)time
{
    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,APPSEARCHREPORT] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",self.appDelegate.missionID,@"utno",time,@"time", nil] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        DLog(@"app 任务上报---%@",responseObject);
        if (error) {
            [MBProgressHUD showError:@"请求失败，请稍后再试!"];
        }else
        {
            if ([responseObject[@"code"] intValue] ==0)
            {

            }else
            {
                self.appDelegate.second = 0;
                [self.appDelegate.openAppTimer invalidate];
                self.appDelegate.selectedListModel = nil;
                self.appDelegate.openAppTimer = nil;
                if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                    
                    UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"温馨提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action  = [UIAlertAction actionWithTitle:@"好的,我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alt addAction:action];
                    [self presentViewController:alt animated:YES completion:nil];
                }else
                {
                    [LocalNotificationTool registerLocalNotification:0 message:responseObject[@"msg"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }];
}
//app下载取数据
-(void)setAppData:(NSArray*)arr
{
    if (arr.count>0)
    {
        NSString *urlString = arr[0];
        self.appDelegate.urlScheme = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        DLog(@"appscheme===%@",self.appDelegate.urlScheme);
    }
}

//商家
-(void)setMerchantData:(NSArray*)arr
{
    if (arr.count>=3) {
        self.bussinessUrl = arr[0];
        self.bussinessArr = [arr[1] componentsSeparatedByString:@","];
        self.bussinessMoney =arr[2];
    }
}
- (void)copyToApp:(NSArray*)key{
    
    DLog(@"-----%@+++",key);
    if (key.count ==2&&[key[1] isEqualToString:@"wechat"])
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:key[0]];
        [MBProgressHUD showMessage:@"已复制到粘贴板!"];
        [self performSelector:@selector(hideHud) withObject:nil afterDelay:0.5];
        if ([UserDefaultObjectForKey(OPENWEIXINDIRECT) intValue] ==1) {
            
            if ([WXApi isWXAppInstalled]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
            }else
            {
                [MBProgressHUD showError:@"请安装微信！"];
            }
            
        }else
        {
            self.toWhereString = @"wechat";
            PublicAlertView *alt= [[PublicAlertView alloc]initWithTitle:@"是否打开【微信】？" message:@"下次直接打开,免提式" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:@"打开" withMsFont:Font(12) withTitleFont:nil];
            alt.tag = 1;
            [alt showUserChoiseBtn];
            [alt show];
        }
    }else if (key.count ==2&&[key[1] isEqualToString:@"app store"])
    {
        self.appName =key[0];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:key[0]];
        [MBProgressHUD showMessage:@"已复制到粘贴板!"];
        [self performSelector:@selector(hideHud) withObject:nil afterDelay:0.5];
        if ([UserDefaultObjectForKey(OPENWEIXINDIRECT) intValue] ==1) {
            
            [self goAppStore];
            
            [self openAppStore];
        }else
        {
            self.toWhereString = @"app store";
            PublicAlertView *alt= [[PublicAlertView alloc]initWithTitle:@"打开app Store完成下载" message:@"下次直接打开app Store,免提式" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:@"打开" withMsFont:Font(12) withTitleFont:nil];
            alt.tag = 2;
            [alt showUserChoiseBtn];
            [alt show];
        }
    }
   
}
-(void)hideHud
{
    [MBProgressHUD hideHUD];
}
-(void)PublicAlertView:(PublicAlertView*)alert buttonindex:(NSInteger)index
{
    if (alert.tag ==1||alert.tag ==2) {
        //1 确定  2:取消
        if (index ==1) {
            if ([self.toWhereString isEqualToString:@"wechat"]) {
                if ([WXApi isWXAppInstalled]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
                }else
                {
                    [MBProgressHUD showError:@"请安装微信！"];
                }
            }else if([self.toWhereString isEqualToString:@"app store"])
            {
                [self goAppStore];
                
                [self openAppStore];
            }
            
        }else
        {
            [alert hiden];
        }

    }else if (alert.tag ==3)//放弃公众号
    {
        if (index ==1) {
            [self CancelCommonList];
        }
    }else if (alert.tag ==4)//放弃APP
    {
        if (index ==1) {
            [self CancelAPPList];
        }
    }else if (alert.tag ==5)//放弃商家
    {
        //1时确定 2时取消
        if (index ==1) {
            [self CancelBussinessList];
        }
    }
}

-(void)PublicAlertView:(PublicAlertView *)alert userSelecte:(BOOL)isSelected
{
    if (isSelected ==YES) {
        UserDefaultSetObjectForKey(@"1", OPENWEIXINDIRECT)
    }else
    {
      UserDefaultSetObjectForKey(@"0", OPENWEIXINDIRECT)
    }
}
//提交任务
-(void)commiteMission:(UIGestureRecognizer*)gest
{
    DLog(@"shijian---_%ld",(long)self.appDelegate.second);
    
    BOOL isHaveApp = [OpenOther findOther:self.appDelegate.urlScheme];
    if (isHaveApp ==NO) {
        [MBProgressHUD showError:@"请您去AppStore下载该应用！"];
        
        [self performSelector:@selector(goAppStore) withObject:nil afterDelay:1.5];
        //搜索时上报
        NSString * search_report =[NSString stringWithFormat:@"%@", self.appDelegate.reportDic[@"search_report"]];
        BOOL isNeed =NO;
        if ([UserDefaultObjectForKey(SEARCHMORE) intValue] ==0||UserDefaultObjectForKey(SEARCHMORE)==nil) {
            isNeed =YES;
        }

        DLog(@"search_report-----%@",search_report);
        if ([search_report isEqualToString:@"1"]&&isNeed ==YES) {
            UserDefaultSetObjectForKey(@"1", SEARCHMORE)
            [self requestAppSearchReport:@"1"];
        }
        return;
    }

    __weak typeof(self) weakSelf = self;
    if (self.appDelegate.second >0&&[self.appDelegate.selectedTypeModel.ID intValue] ==3&&self.appDelegate.appOverTimer ==nil)
    {
        NSString *message = [NSString stringWithFormat:@"请您再试玩%ld秒",(long)self.appDelegate.second];
        [MBProgressHUD showMessage:message toView:KEYWINDOW complication:nil];
        
        [self performSelector:@selector(doneOpenApp) withObject:nil afterDelay:1.5];
        return;
    }
    if ([self.appDelegate.selectedTypeModel.ID intValue] ==3) {
        if (self.appDelegate.is_upload ==1) {
            
            //上传时上报
            NSString *uplaod_report = [NSString stringWithFormat:@"%@",self.appDelegate.reportDic[@"uplaod_report"]];
            BOOL isNeed =NO;
            if ([UserDefaultObjectForKey(UPDATEMORE) intValue] ==0||UserDefaultObjectForKey(UPDATEMORE)==nil) {
                isNeed =YES;
            }

            DLog(@"uplaod_report-----%@",uplaod_report);
            if ([uplaod_report isEqualToString:@"1"]&&isNeed ==YES) {
                UserDefaultSetObjectForKey(@"1", UPDATEMORE)
                [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,APPSEARCHREPORT] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",self.appDelegate.missionID,@"utno",@"3",@"time", nil] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
                    DLog(@"app 上传任务上报---%@",responseObject);
                    self.appDelegate.second = 0;
                    [self.appDelegate.openAppTimer invalidate];
                    self.appDelegate.openAppTimer = nil;
                    if (error) {
                        [MBProgressHUD showError:@"请求失败，请稍后再试!"];
                    }else
                    {
                        if ([responseObject[@"code"] intValue] ==0)
                        {
                            HomeCommiteVC *vc = [[HomeCommiteVC alloc]init];
                            [self.navigationController pushViewController:vc animated:YES];
                        }else
                        {
                            if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                                UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"温馨提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *action  = [UIAlertAction actionWithTitle:@"好的,我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                    
                                    self.appDelegate.selectedListModel = nil;
                                   
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                }];
                                [alt addAction:action];
                                [self presentViewController:alt animated:YES completion:nil];
                            }else
                            {
                                [LocalNotificationTool registerLocalNotification:0 message:responseObject[@"msg"]];
                                self.appDelegate.selectedListModel = nil;
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }
                    }
                }];
            }else
            
            self.appDelegate.second = 0;
            [self.appDelegate.openAppTimer invalidate];
            self.appDelegate.openAppTimer = nil;
            HomeCommiteVC *vc = [[HomeCommiteVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else
        {
        NSMutableDictionary *partDic = [[UIDevice currentDevice] phoneMessageDictionary];
        NSString *jsonString = [NSString toJSONData:partDic];
        [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,CommiteMission] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",weakSelf.appDelegate.missionID,@"utno",jsonString,@"device_info", nil] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
            self.appDelegate.second = 0;
            [self.appDelegate.openAppTimer invalidate];
            self.appDelegate.selectedListModel = nil;
            self.appDelegate.openAppTimer = nil;
            UserDefaultSetObjectForKey(@"0", SEARCHMORE)
            UserDefaultSetObjectForKey(@"0", OPENMORE)
            UserDefaultSetObjectForKey(@"0", UPDATEMORE)
            if (error) {
                [MBProgressHUD showError:@"请求失败，请稍后再试!"];
            }else
            {
                if ([responseObject[@"code"] intValue] ==0) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    [MBProgressHUD showMessage:@"提交成功"];
                    [LocalNotificationTool registerLocalNotification:0 message:@"恭喜你完成此项任务！"];
                }else
                {
                    [MBProgressHUD showError:responseObject[@"msg"]];
                }
                
            }
        }];
        }
    }
    else if ([self.appDelegate.selectedTypeModel.ID intValue] ==5)
    {
        FYHomeBusinessView *home = [[FYHomeBusinessView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withUrl:self.bussinessUrl withArr:self.bussinessArr withMoney:self.bussinessMoney];
        home.delegate = self;
        [KEYWINDOW addSubview:home];
    }
}
//下载完成
-(void)doneOpenApp
{
    [self openAppBtn:nil];
}
//打开appstore
-(void)openAppStore
{
    //搜索时上报
    NSString *search_report =[NSString stringWithFormat:@"%@", self.appDelegate.reportDic[@"search_report"]];
    DLog(@"search_report-----%@",search_report);
    BOOL isNeed =NO;
    if ([UserDefaultObjectForKey(SEARCHMORE) intValue] ==0||UserDefaultObjectForKey(SEARCHMORE)==nil) {
        isNeed =YES;
    }
    
    if ([search_report isEqualToString:@"1"]&&isNeed ==YES) {
        UserDefaultSetObjectForKey(@"1", SEARCHMORE)
        [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,APPSEARCHREPORT] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",self.appDelegate.missionID,@"utno",@"1",@"time", nil] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
            DLog(@"app 任务上报---%@",responseObject);
            if (error) {
                [MBProgressHUD showError:@"请求失败，请稍后再试!"];
            }else
            {
                if ([responseObject[@"code"] intValue] ==0)
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        if (!self.appDelegate.appOverTimer) {
                            self.appDelegate.appOverTimer =[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(findAppDone) userInfo:nil repeats:YES];
                            [[NSRunLoop currentRunLoop] run];
                        }
                    });
                }else
                {
                    self.appDelegate.second = 0;
                    [self.appDelegate.openAppTimer invalidate];
                    self.appDelegate.selectedListModel = nil;
                    self.appDelegate.openAppTimer = nil;
                    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                        
                        UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"温馨提示" message:responseObject[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action  = [UIAlertAction actionWithTitle:@"好的,我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        [alt addAction:action];
                        [self presentViewController:alt animated:YES completion:nil];
                    }else
                    {
                        [LocalNotificationTool registerLocalNotification:0 message:responseObject[@"msg"]];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }
        }];
    }else
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (!self.appDelegate.appOverTimer) {
                self.appDelegate.appOverTimer =[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(findAppDone) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] run];
            }
        });
    }
    
}
//放弃公众号任务
-(void)dropMission:(UIGestureRecognizer*)gesture
{
    PublicAlertView *pub = [[PublicAlertView alloc]initWithTitle:nil message:@"确定放弃商家任务?" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:@"确定" withMsFont:Font(17) withTitleFont:nil];
    pub.tag = 3;
    [pub show];
}
-(void)CancelCommonList{
    [MBProgressHUD showIndicator];
    __weak typeof(self) weakSelf = self;
    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,CancelTaskURL] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",weakSelf.appDelegate.missionID,@"utno", nil] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [MBProgressHUD showError:@"请求失败，请稍后再试!"];
        }else
        {
            if ([responseObject[@"code"] intValue] ==0) {
                self.appDelegate.second = 0;
                [self.appDelegate.openAppTimer invalidate];
                self.appDelegate.openAppTimer = nil;
                [self.appDelegate.appOverTimer invalidate];
                self.appDelegate.appOverTimer = nil;
                self.appDelegate.dropAgain = YES;
                [MBProgressHUD showMessage:responseObject[@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
            
        }
    }];
}
//放弃APP任务
-(void)dropAppMission:(UIButton*)sender
{
    PublicAlertView *pub = [[PublicAlertView alloc]initWithTitle:nil message:@"确定放弃APP任务?" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:@"确定" withMsFont:Font(17) withTitleFont:nil];
    pub.tag =4;
    [pub show];
}

-(void)CancelAPPList{
    [MBProgressHUD showIndicator];
    __weak typeof(self) weakSelf = self;
    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,CancelTaskURL] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",weakSelf.appDelegate.missionID,@"utno", nil] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [MBProgressHUD showError:@"请求失败，请稍后再试!"];
        }else
        {
            if ([responseObject[@"code"] intValue] ==0) {
                UserDefaultSetObjectForKey(@"0", SEARCHMORE)
                UserDefaultSetObjectForKey(@"0", OPENMORE)
                UserDefaultSetObjectForKey(@"0", UPDATEMORE)
                self.appDelegate.second = 0;
                [self.appDelegate.openAppTimer invalidate];
                self.appDelegate.openAppTimer = nil;
                self.appDelegate.dropAgain = YES;
                [self.appDelegate.appOverTimer invalidate];
                self.appDelegate.appOverTimer = nil;
                [MBProgressHUD showMessage:responseObject[@"msg"]];
                [NSThread sleepForTimeInterval:1.0];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
        }
    }];
}
//放弃商家任务
-(void)dropBussinessMission:(UIButton*)sender
{
    PublicAlertView *pub = [[PublicAlertView alloc]initWithTitle:nil message:@"确定放弃商家任务?" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:@"确定" withMsFont:Font(17) withTitleFont:nil];
    pub.tag = 5;
    [pub show];
}
-(void)CancelBussinessList{
    [MBProgressHUD showIndicator];
    __weak typeof(self) weakSelf = self;
    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,CancelTaskURL] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",weakSelf.appDelegate.missionID,@"utno", nil] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [MBProgressHUD showError:@"请求失败，请稍后再试!"];
        }else
        {
            if ([responseObject[@"code"] intValue] ==0) {
                self.appDelegate.second = 0;
                [self.appDelegate.openAppTimer invalidate];
                self.appDelegate.openAppTimer = nil;
                self.appDelegate.dropAgain = YES;
                [self.appDelegate.appOverTimer invalidate];
                self.appDelegate.appOverTimer = nil;
               [MBProgressHUD showMessage:responseObject[@"msg"]];
                [NSThread sleepForTimeInterval:1.0];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
        }
    }];
}
//监测app是否下载完成
-(void)findAppDone
{
      BOOL canOpen = [OpenOther openOther:self.appDelegate.urlScheme];
        if (canOpen ==YES) {
            [self.appDelegate.appOverTimer invalidate];
            self.appDelegate.appOverTimer = nil;
            
            if (self.appDelegate.openAppTimer ==nil&self.appDelegate.second>0) {
                [LocalNotificationTool registerLocalNotification:0 message:@"任务计时开始，请保持打开状态！"];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    self.appDelegate.openAppTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
                    
                    [[NSRunLoop currentRunLoop] run];
                    
                });
 
            }else
            {
                [OpenOther openOther:self.appDelegate.urlScheme];
            }
            
        }
}
//30s打开一次app
- (void)timeHeadle{
    
    self.appDelegate.second-=1;
    
    if (self.appDelegate.second%30 == 0) {
        
        BOOL canOpen = [OpenOther openOther:self.appDelegate.urlScheme];
        if (canOpen ==YES)
        {
            if (self.appDelegate.second==0)
            {
                //自动提交任务
                [self commiteMission:nil];
                
            }
            
        }
    }
}
//前往appstrore
- (void) goAppStore
{
    
    NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/search?mt=8&submit=edit&term=%@#software",
                     
    [@""stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
 
}
//商家任务提交审核完成
- (void) FYHomeBusiness:(FYHomeBusinessView*)businessView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) timeOut
{
    [MBProgressHUD showError:@"任务超时，请您重新抢任务！"];
    [self.navigationController popViewControllerAnimated:NO];
}
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MISSONDONENOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BACKINLOCAL object:nil];

}
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
