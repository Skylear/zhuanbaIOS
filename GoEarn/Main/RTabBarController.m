//
//  RTabBarController.m
//  MiaoChat
//
//  Created by Beyondream on 16/6/15.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "RTabBarController.h"
#import "RNavigationController.h"
#import "HomeVC.h"
#import "SettingVC.h"
#import "MessageVC.h"
#import "SecrectVC.h"
#import "BXTabBar.h"
#import "UIImage+Extension.h"
#import "JPUSHService.h"
@interface RTabBarController ()<UITabBarControllerDelegate,BXTabBarDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIView *redPoint;
/** view */
@property (nonatomic, strong) BXTabBar *mytabbar;
@end

@implementation RTabBarController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    //JPush 监听登陆成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeoj) name:@"REMOVEREDDA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLoadoj) name:@"RELOADREDDA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotice) name:@"YXHNOTICE" object:nil];
    
    self.delegate = self;

    //添加子控制器
    [self setChildController:[[HomeVC alloc] init] title:@"首页" WithNavTitle:@"" image:@"bottombar_home1" selectedImage:@"bottombar_home2"];
    
    [self setChildController:[[MessageVC alloc] init] title:@"资讯" WithNavTitle:@"资讯" image:@"bottombar_infor1" selectedImage:@"bottombar_infor2"];
    
    [self setChildController:[[SecrectVC alloc] init] title:@"密语" WithNavTitle:@"密语" image:@"bottombar_message1" selectedImage:@"bottombar_message2"];
    
    
    [self setChildController:[[SettingVC alloc] init] title:@"我的" WithNavTitle:@"我的" image:@"bottombar_mine1" selectedImage:@"bottombar_mine2"];
    
    // 自定义tabBar
    [self setUpTabBar];
    
    
    NSString *isReg =  UserDefaultObjectForKey(@"firstReg");
    if ([isReg intValue] ==1) {
        [JPUSHService setAlias:[LWAccountTool account].no callbackSelector:nil object:nil];
        AppDelegate *app =(AppDelegate*) [UIApplication appDelegate];
        NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
        NSString *nostring =UserDefaultObjectForKey(USER_INFO_NUM);
        [userDict setObject:nostring forKey:@"no"];
        NSString *sessionString =UserDefaultObjectForKey(USER_INFO_LOGIN);
        [userDict setObject:sessionString forKey:@"session"];
        [app bindingUser:userDict];
    }
    
}

-(void)getNotice{
    NSArray *arr= [[NoticeDataBase sharedNoticeDatabase] allHistory:NoticeTypeSystem];
    NSArray *ARR= [[NoticeDataBase sharedNoticeDatabase] allHistory:NoticeTypeSend];
    if (arr.count>0||ARR.count>0) {

        self.mytabbar.badgeView.hidden = NO;
        
    }else{
        self.mytabbar.badgeView.hidden = YES;
    }
}
#pragma mark - 自定义tabBar
- (void)setUpTabBar
{
    BXTabBar *tabBar = [[BXTabBar alloc] init];
    // 存储UITabBarItem
    tabBar.items = self.items;
    
    tabBar.delegate = self;
    
    tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage createImageWithColor:[UIColor whiteColor]]];

    tabBar.frame = self.tabBar.frame;
    [self.view addSubview:tabBar];
    self.mytabbar = tabBar;
    
    
    if ([UserDefaultObjectForKey(@"ISSYSTEMOPEN") isEqualToString:@"0"]&&[UserDefaultObjectForKey(@"ISNOTICEOPEN") isEqualToString:@"0"]) {

        self.mytabbar.badgeView.hidden = YES;
    }else{
        //红点提示
        NSArray *arr= [[NoticeDataBase sharedNoticeDatabase] allHistory:NoticeTypeSystem];
        NSArray *ARR= [[NoticeDataBase sharedNoticeDatabase] allHistory:NoticeTypeSend];
        if (arr.count>0||ARR.count>0) {

            self.mytabbar.badgeView.hidden = NO;
            
        }else{
            self.mytabbar.badgeView.hidden = YES;
        }
    }
}
-(void)removeoj{
    
    self.mytabbar.badgeView.hidden = YES;
}
-(void)reLoadoj{

    self.mytabbar.badgeView.hidden = NO;
}
/**
 *  初始化子控制器
 *
 *  @param vc            控制器
 *  @param title         名称
 *  @param image         默认图片
 *  @param selectedImage 选中图片
 */
-(void)setChildController:(UIViewController *)vc title:(NSString *)title WithNavTitle:(NSString*)navTitle image:(NSString *)image selectedImage:(NSString *)selectedImage {
    //设置文字和图片
    vc.navigationItem.title = navTitle;
    vc.tabBarItem.title = title;
    
    [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xff4c61),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    vc.tabBarItem.image = [UIImage imageNamed:image] ;
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 记录所有控制器对应按钮的内容
    [self.items addObject:vc.tabBarItem];
    
    //包装一个导航控制器，添加导航控制器为tabbarController的子控制器
    RNavigationController *nav = [[RNavigationController alloc] initWithRootViewController:vc];
    nav.delegate = self;

    [self addChildViewController:nav];
    

}
- (void)tabBar:(BXTabBar *)tabBar didClickBtn:(NSInteger)index
{
    self.selectedIndex = index;

}
#pragma mark navVC代理
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    self.tabBar.hidden = YES;
    // 把系统的tabBar上的按钮干掉
    for (UIView *childView in self.tabBar.subviews) {
        if (![childView isKindOfClass:[BXTabBar class]]) {
            [childView removeFromSuperview];
        }
    }

    
    UIViewController *root = navigationController.viewControllers.firstObject;
    if (viewController != root) {
        //更改导航控制器的高度
        navigationController.view.frame = self.view.bounds;
        //从HomeViewController移除
        [self.mytabbar removeFromSuperview];
        [self.mytabbar.badgeView removeFromSuperview];
        // 调整tabbar的Y值
        CGRect dockFrame = self.mytabbar.frame;
        
        if ([root.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollview = (UIScrollView *)root.view;
            dockFrame.origin.y = scrollview.contentOffset.y + root.view.frame.size.height - 49;
        } else {

            dockFrame.origin.y = root.view.frame.size.height - 49;
        }
        _mytabbar.frame = dockFrame;
        
        //添加dock到根控制器界面
        [root.view addSubview:_mytabbar];
    }
}

// 完全展示完调用
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController *root = navigationController.viewControllers.firstObject;
    RNavigationController *nav = (RNavigationController *)navigationController;
    if (viewController == root) {
        // 更改导航控制器view的frame
        navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
        
        navigationController.interactivePopGestureRecognizer.delegate = nav.popDelegate;
        // 让Dock从root上移除
        [_mytabbar removeFromSuperview];
        [_mytabbar.badgeView removeFromSuperview];
        //_mytabbar添加dock到HomeViewController
        _mytabbar.frame = self.tabBar.frame;
        [self.view addSubview:_mytabbar];
    }
}
// jpush分配别名

/**
 *  登录成功，设置别名，移除监听
 *
 *  @param notification <#notification description#>
 */
- (void)networkDidLogin:(NSNotification *)notification {
    
    [JPUSHService setAlias:[LWAccountTool account].no callbackSelector:nil object:nil];
    DLog(@"******设置别名成功********");
    [[NSNotificationCenter defaultCenter] removeObserver:self
        name:kJPFNetworkDidLoginNotification
      object:nil];
    
//    if (!UserDefaultObjectForKey(@"BINDFIRST")) {
//        UserDefaultSetObjectForKey(@"1", @"BINDFIRST")
//        NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setValue:[LWAccountTool account].no forKey:@"no"];
//        [dic setValue:string forKey:@"session"];
//        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication];
//        [appdelegate bindingUser:dic];
//    }
}

- (NSMutableArray *)items {
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
