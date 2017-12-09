//
//  BaseViewController.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/23.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "BaseViewController.h"
#import "NetHelp.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];//隐藏 常态时是否隐藏 动画时是否显示
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf2f5f7);
    //[self initAdvView];
}
#pragma mark - 启动动画

-(void)initAdvView:(CGRect)frame
{
    _yourSuperView = [[UIView alloc] initWithFrame:frame];
    _yourSuperView.backgroundColor = [UIColor whiteColor];
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=9; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_hud_%zd", i]];
        [refreshingImages addObject:image];
    }
    _imaView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, [UIScreen mainScreen].bounds.size.height/2-70, 200, 120)];
    _imaView.animationImages = refreshingImages;
    [_yourSuperView addSubview:_imaView];
    [KEYWINDOW addSubview:_yourSuperView];
    
    _yourSuperView.hidden = NO;
    //设置执行一次完整动画的时长
    _imaView.animationDuration = 9*0.15;
    //动画重复次数 （0为重复播放）
    _imaView.animationRepeatCount = 10;
    [_imaView startAnimating];
}
-(void)removeAdvImage
{
    [UIView animateWithDuration:0.3f animations:^{
        _yourSuperView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        _yourSuperView.alpha = 0.f;
    } completion:^(BOOL finished) {
        //[_yourSuperView removeFromSuperview];//会直接移除，不能再次使用，故使用隐藏
        _yourSuperView.hidden = YES;
        if ([NetHelp isConnectionAvailable]) {
            
        }else
        {
            
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
