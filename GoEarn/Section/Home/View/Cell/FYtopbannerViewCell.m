//
//  FYFiveViewCell.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/29.
//  Copyright © 2016年 Beyondream. All rights reserved.
//


#import "FYtopbannerViewCell.h"
#import "UIImageView+WebCache.h"
#import "HomeAppModel.h"
@interface FYtopbannerViewCell()<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    
    NSInteger _page;
    NSInteger _page1;
    
    BOOL led;
}

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation FYtopbannerViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithTableView:(UITableView *)tableView array:(NSMutableArray *)array
{
    static NSString *cellIndentifier = @"celltop";
    FYtopbannerViewCell *topCell = [[FYtopbannerViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier Array:array];

    return topCell;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Array:(NSArray *)array
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if(self)
    {
        int z = (int)[array count] + 2;
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SCREEN_WIDTH/2)];
        
        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * z, SCREEN_WIDTH/2);
        
        _scrollView.pagingEnabled = YES;//当值是 YES 会自动滚动到 subview 的边界，默认是NO
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width , 0);
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width , 0);
        
        _scrollView.showsHorizontalScrollIndicator = NO;//滚动条是否可见 水平
        _scrollView.showsVerticalScrollIndicator=NO;//滚动条是否可见 垂直
        
        for (int i = 0; i < [array count]; i++)
        {
            UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (i+1), 0, [UIScreen mainScreen].bounds.size.width, SCREEN_WIDTH/2)];
            HomeAppModel *appModel = array[i];
            
            [backView sd_setImageWithURL:[NSURL URLWithString:appModel.path] placeholderImage:placeholder_banner];

            backView.tag = 5000 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clicktap:)];
            [backView addGestureRecognizer:tap];
            
            backView.userInteractionEnabled = YES;//允许点击(UIView中貌似默认是yes 这里默认是no)
            [_scrollView addSubview:backView];
        }
        if (array.count) {
            HomeAppModel *firstAppModel = [array firstObject];
            HomeAppModel *endAppModel = [array lastObject];
            
            //开头
            UIImageView *backView0 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0, 0, [UIScreen mainScreen].bounds.size.width, SCREEN_WIDTH/2)];
            [backView0 sd_setImageWithURL:[NSURL URLWithString:endAppModel.path] placeholderImage:placeholder_banner];
            
            backView0.tag = 5000 + [array count] -1;
            UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clicktap:)];
            [backView0 addGestureRecognizer:tap0];
            backView0.userInteractionEnabled = YES;//允许点击(UIView中貌似默认是yes 这里默认是no)
            
            [_scrollView addSubview:backView0];
            //末尾
            UIImageView *backView9 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * (z-1), 0, [UIScreen mainScreen].bounds.size.width, SCREEN_WIDTH/2)];
            [backView9 sd_setImageWithURL:[NSURL URLWithString:firstAppModel.path] placeholderImage:placeholder_banner];
            
            backView9.tag = 5000;
            UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clicktap:)];
            [backView9 addGestureRecognizer:tap9];
            backView9.userInteractionEnabled = YES;//允许点击(UIView中貌似默认是yes 这里默认是no)
            
            [_scrollView addSubview:backView9];
        }
        
        [self addSubview:_scrollView];
        
        double cun;
        if([UIScreen mainScreen].bounds.size.width == 375)//375*667
        {
            cun = 2.35;
        }else if([UIScreen mainScreen].bounds.size.width == 414)//414*736
        {
            cun = 2.6;
        }else if([UIScreen mainScreen].bounds.size.width == 768)
        {
            cun = 4.85;
        }
        else //if([UIScreen mainScreen].bounds.size.width == 320)// * 568/480
        {
            cun = 2;
        }
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/cun, SCREEN_WIDTH/2 -20, 0, 20)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = [_scrollView.subviews count] -2;
        [_pageControl setCurrentPageIndicatorTintColor:UIColorFromRGB(0xff4c61)];
        [_pageControl setPageIndicatorTintColor:[UIColor colorWithWhite:1 alpha:0.5]];
        
        if (array.count > 1)
        {
            [self addSubview:_pageControl];
            [self addTimer];
        }else
        {
            led = YES;
        }
        
        _page = 1;
        _page1 = [array count]+1;
        

    }
    return self;
}

#pragma mark - UIScrollViewDelegate  scrollView事件

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

-(void)Clicktap:(UITapGestureRecognizer *)sender//点击释放触发
{
    int tag = (int)sender.view.tag-5000;
    if ([self.delegate respondsToSelector:@selector(didSelectedTopbannerViewCellIndex:)]) {
        [self.delegate didSelectedTopbannerViewCellIndex:tag];

    }}


/**
 *  scrollView 开始拖拽的时候调用
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (led)
    {
        
    }else
    {
        [self closeTimer];

    }
}

/**
 *  scrollView 结束拖拽的时候调用
 *
 *  @param scrollView scrollView description
 *  @param decelerate decelerate description
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (led)
    {
        
    }else
    {
       [self addTimer];
    }
}

#pragma mark - timer方法
/**
 *  添加定时器
 */
-(void)addTimer
{
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    //多线程 UI IOS程序默认只有一个主线程，处理UI的只有主线程。如果拖动第二个UI，则第一个UI事件则会失效。
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


-(void)nextImage
{
    _page = _page+1;

    [_scrollView setContentOffset:CGPointMake(_page*_scrollView.frame.size.width, 0) animated:YES];
    
    if (_page == _page1)
    {
        _page=0;
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width*_page, 0);
    }
    //NSLog(@"dfsd");
}

/**
 *  关闭定时器
 */
-(void)closeTimer
{
    [self.timer invalidate];
}


@end
