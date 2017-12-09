//
//  TSHomeMenuCell.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/29.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#define TAG 1000

#import "FYHomeMenuCell.h"
#import "FYMenuBtnView.h"
#import "HomeListType.h"
@interface FYHomeMenuCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIView *_backView1;
    
    UIView *_backView0;//用来实现滚动效果
    UIView *_backView4;
    
   // UIPageControl *_pageControl;
}

@property (nonatomic, strong) UILongPressGestureRecognizer *pressRecognizer;

@end

@implementation FYHomeMenuCell

+(instancetype)cellWithTableView:(UITableView *)tableView menuArray:(NSMutableArray *)menuArray
{
    FYHomeMenuCell *cell = [[FYHomeMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0" menuArray:menuArray];

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSArray *)menuArray
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        _backView1 = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 180)];

        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)];
        scrollView.scrollEnabled = NO;
        scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*5, 180);
        
        scrollView.pagingEnabled = YES;//当值是 YES 会自动滚动到 subview 的边界，默认是NO
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width , 0);
        scrollView.delegate = self;
        
        scrollView.showsHorizontalScrollIndicator = NO;//滚动条是否可见 水平
        scrollView.showsVerticalScrollIndicator=NO;//滚动条是否可见 垂直
        
        /* 用来实现滚动效果的附加view */
        _backView0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)];
        _backView4 = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*4, 0, [UIScreen mainScreen].bounds.size.width, 180)];
        [scrollView addSubview:_backView0];
        [scrollView addSubview:_backView4];
        
        /* ～ */
        NSArray *backView = @[_backView1];
        
        [scrollView addSubview:_backView1];

        
        [self addSubview:scrollView];
        
        for(int i = 0; i < [menuArray count]; i++)
        {
            HomeListType *type = menuArray[i];
            CGRect frame = CGRectMake(i%[menuArray count]*[UIScreen mainScreen].bounds.size.width/[menuArray count], (i/5)%2*80, [UIScreen mainScreen].bounds.size.width/[menuArray count], 80);
            NSString *title = type.name;
            NSString *imagestr = type.img;
                
            FYMenuBtnView *btnView = [[FYMenuBtnView alloc]initWithFrame:frame title:title imagestr:imagestr];
            btnView.tag = TAG + i;

            [backView[i/10] addSubview:btnView];

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clicktap:)];
            
            [btnView addGestureRecognizer:tap];
            /* 长按手势来形成按钮效果（按钮会和scrollView以及tableView的滑动冲突） */
            self.pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];//用长按来做出效果
            self.pressRecognizer.minimumPressDuration = 0.05;
            
            self.pressRecognizer.delegate = self;//用来实现长按不独占
            self.pressRecognizer.cancelsTouchesInView = NO;
            
            [btnView addGestureRecognizer:self.pressRecognizer];
        }
        
        double cun;
        if([UIScreen mainScreen].bounds.size.width == 375)//375*667
        {
            cun = 2.35;
        }else if([UIScreen mainScreen].bounds.size.width == 414)//414*736
        {
            cun = 2.6;
        }else//[UIScreen mainScreen].bounds.size.width == 320 * 568/480
        {
            cun = 2;
        }  
    }
    return self;//ScrollView由三个和屏幕等宽的view拼接而成
}
/*
#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView//手指拖动后调用
{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;

    _pageControl.currentPage = page-1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView//拖动结束后调用
{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    
    if (page == 0)
    {
        scrollView.contentOffset  = CGPointMake(scrollView.frame.size.width*([scrollView.subviews count] -2), 0);
    }
    if (page == [scrollView.subviews count] -1)
    {
        scrollView.contentOffset  = CGPointMake(scrollView.frame.size.width*1, 0);
    }
    
}
*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
        return YES;//长按手势会独占对象，故用代理将他取消独占
}

-(void)longPress:(UITapGestureRecognizer *)sender//长按触发
{

    if (sender.state == UIGestureRecognizerStateBegan)
    {
        sender.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        sender.view.backgroundColor = [UIColor whiteColor];
    }

}

-(void)Clicktap:(UITapGestureRecognizer *)sender//点击释放触发
{
    DLog(@"tag:%ld",sender.view.tag);
    UIView *backView = (UIView *)sender.view;
    int tag = (int)backView.tag-TAG;
    if ([self.delegate respondsToSelector:@selector(didSelectedHomeMenuCellAtIndex:)]) {
        [self.delegate didSelectedHomeMenuCellAtIndex:tag ];
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

