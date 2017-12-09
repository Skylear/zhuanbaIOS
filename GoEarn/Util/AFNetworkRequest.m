//
//  AFNetworkRequest.m
//  AF封装
//
//  Created by Beyondream on 15/11/15.
//  Copyright © 2015年 Beyondream. All rights reserved.
//

#import "AFNetworkRequest.h"
#import "AFNetworking.h"
#import "ProTool.h"

@interface  LoadingView()

@property(nonatomic,strong)UIImageView *animationImgView;
@property(nonatomic,strong)UILabel *loadLabel;

@end

LoadingView *loadView = nil;

@implementation LoadingView
//创建实例
+(LoadingView*)shareInstance
{
    if (!loadView) {
        
        loadView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        loadView.backgroundColor =kClearColor;
        
    }
    return loadView;
}
//增加锁
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        if (!loadView) {
            loadView = [super allocWithZone:zone];
        }
    }
    return loadView;
}
//实现copy协议需要实现NSCopying协议
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
-(void)showErrorMessage:(NSString*)message
{
    [KEYWINDOW addSubview:loadView];
    
    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, 20)];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.centerX -MAX(100, size.width +40)/2, self.centerY - 50, MAX(100, size.width +40), 100)];
    [view.layer setBackgroundColor:[[UIColor colorWithWhite:0 alpha:0.75] CGColor]];
    [view.layer setCornerRadius:10];
    [view.layer setMasksToBounds:YES];
    [loadView addSubview:view];
    
    UIImageView * animView= [[UIImageView alloc] initWithFrame:CGRectMake(MAX((100 -50)/2, (size.width +40 -50)/2), 15, 50, 50)];
    animView.image = [UIImage imageNamed:@"inputerror"];
    [view addSubview:animView];
    _animationImgView = animView;
    
    self.loadLabel = [[UILabel alloc]initWithFrame:CGRectMake(animView.minX -30, animView.maxY +7, animView.width+60, 20)];
    self.loadLabel.font = Font(15);
    self.loadLabel.text = message;
    self.loadLabel.textAlignment = NSTextAlignmentCenter;
    self.loadLabel.textColor = [UIColor whiteColor];
    self.loadLabel.text = message;
    [view addSubview:self.loadLabel];
    
    [self performSelector:@selector(removeError) withObject:nil afterDelay:0.5];
}
-(void)removeError
{
    [loadView removeFromSuperview];
    loadView = nil;
    [self.animationImgView removeFromSuperview];
    self.animationImgView = nil;
    [self.loadLabel removeFromSuperview];
    self.loadLabel = nil;
}
-(void)showLoading:(UIViewController*)vc withMessage:(NSString*)message
{
    [KEYWINDOW addSubview:loadView];
    
    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, 20)];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.centerX -MAX(100, size.width +40)/2, SCREEN_HEIGHT/2 - 50, MAX(100, size.width +40), 100)];
    [view.layer setBackgroundColor:[[UIColor colorWithWhite:0 alpha:0.75] CGColor]];
    [view.layer setCornerRadius:10];
    [view.layer setMasksToBounds:YES];
    [loadView addSubview:view];
    
    UIImageView * animView= [[UIImageView alloc] initWithFrame:CGRectMake(MAX((100 -50)/2, (size.width +40 -50)/2), 15, 50, 50)];
    NSMutableArray *imgArr = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"getupload_%d",i+1]];
        [imgArr addObject:img];
    }
    animView.animationImages =imgArr;
    
    // all frames will execute in 1.75 seconds
    animView.animationDuration = 1;
    // repeat the annimation forever
    animView.animationRepeatCount = 0;
    // start animating
    [animView startAnimating];
    // add the animation view to the main window
    [view addSubview:animView];
    _animationImgView = animView;
    
    self.loadLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, animView.maxY +7, size.width, 20)];
    self.loadLabel.font = Font(15);
    self.loadLabel.text = message;
    self.loadLabel.textAlignment = NSTextAlignmentCenter;
    self.loadLabel.textColor = [UIColor whiteColor];
    self.loadLabel.text = @"正在领取任务";
    [view addSubview:self.loadLabel];    
}

-(void)hiden
{
    [loadView removeFromSuperview];
    loadView = nil;
    [self.animationImgView removeFromSuperview];
    self.animationImgView = nil;
    [self.loadLabel removeFromSuperview];
    self.loadLabel = nil;
}
@end


@interface AFNetworkRequest ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, assign, getter=isConnected) BOOL connected;/**<网络是否连接*/
@end

@implementation AFNetworkRequest

- (void)requestWithVC:(UIViewController*)VC   URLString:(NSString *)urlString
                     parameters:(NSMutableDictionary *)parameters
                           type:(NetworkRequestType)type
                    resultBlock:(NetworkRequestResultBlock)resultBlock {
    if ([urlString containsString:@"http://zbinfo.91miaotui.com:88/v1"]) {
        AddArticalDic(parameters);
    }else
    {
        AddDic(parameters);
    }

    NSSet *acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                     @"text/html",
                                     @"text/json",
                                     @"text/javascript",
                                     @"text/plain", nil];
    self.manager.operationQueue.maxConcurrentOperationCount = 5;
    self.manager.requestSerializer.timeoutInterval = 5;
    self.manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    switch (type) {
        case NetworkRequestTypePost: {
            [self.manager POST:urlString
                    parameters:parameters
                       success:^(NSURLSessionDataTask *task, id responseObject) {
                           
                           [self handleRequestResultWithDataTask:task
                                                  responseObject:responseObject
                                                           error:nil
                                                     resultBlock:resultBlock];
                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                           [self handleRequestResultWithDataTask:task
                                                  responseObject:nil
                                                           error:error
                                                     resultBlock:resultBlock];
                       }];
            break;
        }
        case NetworkRequestTypeGet: {
            [self.manager GET:urlString
                   parameters:parameters
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          [self handleRequestResultWithDataTask:task
                                                 responseObject:responseObject
                                                          error:nil
                                                    resultBlock:resultBlock];
                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                          [self handleRequestResultWithDataTask:task
                                                 responseObject:nil
                                                          error:error
                                                    resultBlock:resultBlock];
                      }];
            break;
        }
        case NetworkRequestTypePut: {
            [self.manager PUT:urlString
                   parameters:parameters
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          [self handleRequestResultWithDataTask:task
                                                 responseObject:responseObject
                                                          error:nil
                                                    resultBlock:resultBlock];
                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                          [self handleRequestResultWithDataTask:task
                                                 responseObject:nil
                                                          error:error
                                                    resultBlock:resultBlock];
                      }];
            break;
        }
        case NetworkRequestTypeHead: {
            [self.manager HEAD:urlString
                    parameters:parameters
                       success:^(NSURLSessionDataTask *task) {
                           [self handleRequestResultWithDataTask:task
                                                  responseObject:nil
                                                           error:nil
                                                     resultBlock:resultBlock];
                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                           [self handleRequestResultWithDataTask:task
                                                  responseObject:nil
                                                           error:error
                                                     resultBlock:resultBlock];
                       }];
            break;
        }
        case NetworkRequestTypeDelete:{
            [self.manager DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
                [self handleRequestResultWithDataTask:task
                                       responseObject:nil
                                                error:nil
                                          resultBlock:resultBlock];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self handleRequestResultWithDataTask:task
                                       responseObject:nil
                                                error:error
                                          resultBlock:resultBlock];
            }];
            break;
        }
    }
}

- (BOOL)isConnected {
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

- (AFHTTPSessionManager *)manager {
    if (!_manager) {

        _manager = [[AFHTTPSessionManager alloc]
                    initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    }
    return _manager;
}

- (void)handleRequestResultWithDataTask:(NSURLSessionDataTask *)task
                         responseObject:(id)responseObject
                                  error:(NSError *)error
                            resultBlock:(NetworkRequestResultBlock)resultBlock {
    //[[LoadingView shareInstance] hiden];
    //do something here...
    if(resultBlock) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        resultBlock(responseObject,error);
    }
}

@end
