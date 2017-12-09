//
//  RNavigationController.m
//  MiaoChat
//
//  Created by Beyondream on 16/6/15.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "RNavigationController.h"
#import "HomeWebVC.h"
#import "HomeAgentWebVC.h"
@interface RNavigationController()<UINavigationControllerDelegate>

@end

@implementation RNavigationController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancleTask:) name:CANCELTAST object:nil];
    
}
- (void)cancleTask:(NSNotification*)noti
{
    UserDefaultSetObjectForKey(@"1", BACKINLOCAL)
}
/**
 *  当第一次使用这个类的时候回调用一次
 */
+(void)initialize {
    
    //设置导航栏主题
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];

    
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil]];
}

/**
 *  统一所有控制器导航栏左上角的返回按钮
 *  让所有push进来的控制器，它的导航栏左上角的内容都一样
 *  能拦截所有的push操作
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //如果push进来的不是第一个控制器
    if (self.childViewControllers.count > 0) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"return_btn"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        backButton.size = CGSizeMake(70, 30);
        // 让按钮的内容往左边偏移10
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        // 让按钮内部的所有内容左对齐
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

        viewController.hidesBottomBarWhenPushed = YES;
        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    //这句super的push要放在后面，让viewController可以覆盖上面设置leftBarButtonItem
    [super pushViewController:viewController animated:YES];
}

/**
 *  返回按钮
 */
-(void)back{
    [self popViewControllerAnimated:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CANCELTAST object:nil];
}
@end
