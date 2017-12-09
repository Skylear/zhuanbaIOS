//
//  LeadVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/23.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "LeadVC.h"
#import "STPageControl.h"
#import "RTabBarController.h"
#import "LoginVC.h"
@interface LeadVC ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *startScrollView;
@property (strong, nonatomic)UIPageControl *pageControl;

@end

@implementation LeadVC

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
}

- (void)createUI
{
    _startScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _startScrollView.delegate = self;
    _startScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, 0);
    _startScrollView.showsVerticalScrollIndicator = NO;
    _startScrollView.showsHorizontalScrollIndicator = NO;
    _startScrollView.pagingEnabled = YES;
    _startScrollView.bounces = YES;
    _startScrollView.delegate = self;
    [self.view addSubview:_startScrollView];
    
    //后期添加跳不跳过/////////
    UIButton *buUon = [UIButton buttonWithType:UIButtonTypeCustom];
    buUon.frame = CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH/4),0, SCREEN_WIDTH/4,(SCREEN_WIDTH/4));
    [buUon setImage:[UIImage imageNamed:@"jump_over"] forState:UIControlStateNormal];

    [buUon addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buUon];

    NSArray * startImageArr =nil;
    
    if (iPhone4)
    {  startImageArr=@[@"640-960_1",@"640-960_2",@"640-960_3",@"640-960_4"];
        
    }else if (iPhone5)
    {
      startImageArr=@[@"640-1136_1",@"640-1136_2",@"640-1136_3",@"640-1136_4"];
    }else if (iPhone6)
    {
       startImageArr=@[@"750-1334_1",@"750-1334_2",@"750-1334_3",@"750-1334_4"]; 
    }else if (iPhone6P)
    {
       startImageArr=@[@"1242-2208_1",@"1242-2208_2",@"1242-2208_3",@"1242-2208_4"];
    }else if (IPad)
    {
        startImageArr=@[@"768-1024_1",@"768-1024_2",@"768-1024_3",@"768-1024_4"];
    }else if (IpadAir)
    {
        startImageArr=@[@"1536-2048_1",@"1536-2048_2",@"1536-2048_3",@"1536-2048_4"];
    }else if (IpadPro)
    {
        startImageArr=@[@"2732-2048_1",@"2732-2048_2",@"2732-2048_3",@"2732-2048_4"];
    }else
    {
      startImageArr=@[@"750-1334_1",@"750-1334_2",@"750-1334_3",@"750-1334_4"];   
    }

    
    for (NSInteger index = 0; index < 4; index++) {
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageV.userInteractionEnabled = YES;
        imageV.image = [UIImage imageNamed:startImageArr[index]];
        //后期添加跳不跳过
        if (index == 3) {
            UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            goBtn.frame = CGRectMake(SCREEN_WIDTH/2-50*SCREEN_POINT,SCREEN_HEIGHT -100*SCREEN_POINT, 100*SCREEN_POINT,30*SCREEN_POINT);
            [goBtn setImage:[UIImage imageNamed:@"once_open"] forState:UIControlStateNormal];
            [goBtn addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
            [imageV addSubview:goBtn];            
        }
        
        [_startScrollView addSubview:imageV];
    }
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.frame = CGRectMake(SCREEN_WIDTH/2-50*SCREEN_POINT, SCREEN_HEIGHT-50*SCREEN_POINT, 100*SCREEN_POINT, 20*SCREEN_POINT);
    _pageControl.numberOfPages = startImageArr.count;
    [_pageControl setValue:[UIImage imageNamed:@"star_unchecked"] forKeyPath:@"pageImage"];
    [_pageControl setValue:[UIImage imageNamed:@"star_opt"] forKeyPath:@"currentPageImage"];
    [self.view addSubview:_pageControl];
    
    
}

-(void)buttonClick:(UIButton *)btn
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    UIApplication *al = [UIApplication sharedApplication];

    al.delegate.window.rootViewController = [[RTabBarController alloc]init];
    [al.delegate.window makeKeyAndVisible];
    
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = x/scrollViewW;
    if (x<=2*SCREEN_WIDTH) {
        _pageControl.hidden = NO;
    }else
    {
        _pageControl.hidden = YES;
    }
    _pageControl.currentPage = page;
    
    if (x > 3*SCREEN_WIDTH+SCREEN_WIDTH/4) {
        [self onTap:nil];
    }
}
- (void)onTap:(UIButton *)aTap
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    UIApplication *al = [UIApplication sharedApplication];
    al.delegate.window.rootViewController = [[RTabBarController alloc]init];
    [al.delegate.window makeKeyAndVisible];
    
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
