//
//  MessageVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/23.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "MessageVC.h"
#import "MessageListVC.h"
#import "SortView.h"
#import "SpreadCell.h"
#import "ChanneLabel.h"
#import "AllDatabase.h"
#import "NetHelp.h"
#import "ProTool.h"

#define SMALL_H  40

static NSString * const reuseID  = @"Cell";

@interface MessageVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
/** 频道数据模型 */
@property (nonatomic, strong) NSMutableArray *channelList;
/*选中的索引*/
@property(nonatomic,assign)NSInteger selectInteger;
/** 频道列表 */
@property (nonatomic, strong) UIScrollView *smallScrollView;
/** 新闻视图 */
@property (nonatomic, strong) UICollectionView *bigCollectionView;
/** 右侧添加删除排序按钮 */
@property (nonatomic, strong) UIButton *sortButton;
/** 下划线 */
@property (nonatomic, strong) UIView *underline;
/*更多选择页面*/
@property(nonatomic,strong)SortView *sortView;

@property(nonatomic,strong)NSString *questionIDStr;



@end

@implementation MessageVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏 常态时是否隐藏 动画时是否显示
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestGetHeadData];//获取头部数据
}
- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }else{
        result = window.rootViewController;
    }
    return result;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _channelList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SpreadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    cell.art = _channelList[indexPath.row];
    
    // 如果不加入响应者链，则无法利用NavController进行Push/Pop等操作。
    [self addChildViewController:(UIViewController *)cell.newsVC];
    return cell;
}
#pragma mark - UICollectionViewDelegate
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self.bigCollectionView) {
        CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (value < 0) {return;} // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。
        
        NSUInteger leftIndex = (int)value;
        NSUInteger rightIndex = leftIndex + 1;
        if (rightIndex >= [self getLabelArrayFromSubviews].count) {  // 防止滑到最右，再滑，数组越界，从而崩溃
            rightIndex = [self getLabelArrayFromSubviews].count - 1;
        }
        CGFloat scaleRight = value - leftIndex;
        CGFloat scaleLeft  = 1 - scaleRight;
        
        ChanneLabel *labelLeft  = [self getLabelArrayFromSubviews][leftIndex];
        ChanneLabel *labelRight = [self getLabelArrayFromSubviews][rightIndex];
        labelLeft.scale  = scaleLeft;
        labelRight.scale = scaleRight;
        // 点击label会调用此方法1次，会导致【scrollViewDidEndScrollingAnimation】方法中的动画失效，这时直接return。
        if (scaleLeft == 1 && scaleRight == 0) {
            return;
        }
        
        // 下划线动态跟随滚动
        _underline.centerX = labelLeft.centerX   + (labelRight.centerX   - labelLeft.centerX)   * scaleRight;
        _underline.width   = labelLeft.textWidth + (labelRight.textWidth - labelLeft.textWidth) * scaleRight;
        if (_underline.maxX >=labelRight.centerX||_underline.minX > labelLeft.centerX)
        {
            labelRight.textColor = UIColorFromRGB(0xf23d3d);
            labelLeft.textColor = UIColorFromRGB(0x666666);
        }else
        {
            labelLeft.textColor = UIColorFromRGB(0xf23d3d);
            labelRight.textColor = UIColorFromRGB(0x666666);
        }
        
    }
}

/** 手指滑动BigCollectionView，滑动结束后调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.bigCollectionView]) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}
//头部滑动的列表
-(UIScrollView *)smallScrollView
{
    if (!_smallScrollView) {
        _smallScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SMALL_H)];
        _smallScrollView.backgroundColor = [UIColor whiteColor];
        _smallScrollView.showsHorizontalScrollIndicator = NO;
        //设置频道标题
        [self setUPListLable];
        [_smallScrollView addSubview:({
            if ([self getLabelArrayFromSubviews].count==0) {
                return nil;
            }
            ChanneLabel *oneLabel = [self getLabelArrayFromSubviews][0];
            oneLabel.textColor = UIColorFromRGB(0xf23d3d);
            _underline = [[UIView alloc]initWithFrame:CGRectMake(0, SMALL_H-2, oneLabel.textWidth, 2)];
            _underline.centerX = oneLabel.centerX;
            _underline.backgroundColor = UIColorFromRGB(0xf23d3d);
            _underline;
        })];
    }
    return _smallScrollView;
}
//下面的展示区
-(UICollectionView*)bigCollectionView
{
    if (!_bigCollectionView) {
        CGRect frame = CGRectMake(0, self.smallScrollView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.smallScrollView.maxY);
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _bigCollectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
        _bigCollectionView.backgroundColor = [UIColor  whiteColor];
        _bigCollectionView.delegate = self;
        _bigCollectionView.dataSource = self;
        [_bigCollectionView registerClass:[SpreadCell class] forCellWithReuseIdentifier:reuseID];
        
        // 设置cell的大小和细节
        flowLayout.itemSize = _bigCollectionView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _bigCollectionView.pagingEnabled = YES;
        _bigCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _bigCollectionView;
}
/**
 *  设置频道标题
 */
-(void)setUPListLable
{
    CGFloat margin = 10.0f;
    CGFloat x = 8;
    CGFloat h = _smallScrollView.bounds.size.height;
    for (int i = 0; i<self.channelList.count; i++) {
        ArticalList *art = self.channelList[i];
        ChanneLabel *lable= [ChanneLabel channelLabelWithTitle:art.title];
        lable.font = Font(head_Font);
        lable.frame = CGRectMake(x, 0, lable.width+margin, h);
        lable.textColor = UIColorFromRGB(0x666666);
        [_smallScrollView addSubview:lable];
        x += lable.bounds.size.width;
        lable.tag = i;
        [lable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
    _smallScrollView.contentSize = CGSizeMake(x+margin +self.sortButton.width, 0);
    //线
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(-150, SMALL_H-0.5, _smallScrollView.contentSize.width+300, 0.5)];
    lineLabel.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [self.smallScrollView addSubview:lineLabel];
}
/** 频道Label点击事件 */
-(void)labelClick:(UITapGestureRecognizer*)gesture
{
    ChanneLabel *label = (ChanneLabel*)gesture.view;
    self.selectInteger = label.tag;
    //点击collection滑动
    [_bigCollectionView setContentOffset:CGPointMake(label.tag *_bigCollectionView.frame.size.width, 0)];
    //让label滑动到点击位置
    [self scrollViewDidEndScrollingAnimation:self.bigCollectionView];
}
/** 手指点击smallScrollView */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //获取点击的索引
    NSUInteger index = scrollView.contentOffset.x /self.bigCollectionView.width;
    self.selectInteger = index;
    //点击的label 滑动到中间位置
    ChanneLabel *label = [self getLabelArrayFromSubviews][index];
    CGFloat offsetX = 0.0f;
    CGFloat offsetMax = 0.0f;
    if (self.smallScrollView.contentSize.width<SCREEN_WIDTH) {
        offsetX = label.center.x;
        offsetMax = 0;
        
    }else
    {
        offsetX = label.center.x - _smallScrollView.width *0.5;
        offsetMax = _smallScrollView.contentSize.width - _smallScrollView.width;
    }
    //最左最右的情况
    if (offsetX<0) {
        offsetX = 0;
    }if (offsetX>offsetMax) {
        offsetX = offsetMax;
    }
    //改变选中颜色
    for (int i=0; i<[self getLabelArrayFromSubviews].count; i++) {
        ChanneLabel *otherLabel = [self getLabelArrayFromSubviews][i];
        otherLabel.textColor = UIColorFromRGB(0x666666);
    }
    //下划线滚动  头部视图滑动
    [UIView animateWithDuration:0.5 animations:^{
        [self.smallScrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
        _underline.width = label.textWidth;
        _underline.centerX = label.centerX;
        label.textColor = UIColorFromRGB(0xf23d3d);
    }];
    
}
/** 获取smallScrollView中所有的ChannelLabel，合成一个数组，因为smallScrollView.subViews中有其他非Label元素 */
- (NSArray *)getLabelArrayFromSubviews
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (ChanneLabel *label in _smallScrollView.subviews) {
        if ([label isKindOfClass:[ChanneLabel class]]) {
            [arrayM addObject:label];
        }
    }
    return arrayM.copy;
}
/*右侧更多按钮*/
-(UIButton*)sortButton
{
    if (!_sortButton) {
        _sortButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-SMALL_H+3, 21, SMALL_H-2, SMALL_H-2)];
        [_sortButton setImage:[UIImage imageNamed:@"more-ico"] forState:UIControlStateNormal];
        [_sortButton setImageEdgeInsets:UIEdgeInsetsMake(10.5, 10.5, 10.5, 10.5)];
        _sortButton.backgroundColor = [UIColor whiteColor];
        _sortButton.layer.borderColor = [UIColor clearColor].CGColor;
        [_sortButton addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortButton;
}
- (SortView *)sortView
{
    if (!_sortView) {
        // 上面高度44的描述栏(覆盖smallScrollView)
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, SMALL_H)];
        label.text = @"所有分类";
        label.tag = 1000;
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:detail_Head_Font];
        [self.view addSubview:label];
        //线
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SMALL_H-0.5+20, SCREEN_WIDTH, 0.5)];
        lineLabel.tag = 1001;
        lineLabel.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [self.view addSubview:lineLabel];
        
        _sortView = [[SortView alloc] initWithFrame:CGRectMake(0,SMALL_H+20,SCREEN_WIDTH,SMALL_H +_bigCollectionView.height) channelList:self.channelList withSelect:self.selectInteger];
        __block typeof(self) weakSelf = self;
        // 排序完成回调
        _sortView.sortCompletedBlock = ^(NSMutableArray *channelList,NSInteger selectInteger){
            weakSelf.channelList = channelList;
            //数据库更新数据
            [[AllDatabase sharedAllDatabase]removeAllHistory:AllDatabaseTypeHot];
            [[AllDatabase sharedAllDatabase]insertHistoryItem:channelList WithSql:AllDatabaseTypeHot];
            // 去除旧的排序
            for (ChanneLabel *label in [weakSelf getLabelArrayFromSubviews]) {
                [label removeFromSuperview];
            }
            // 加入新的排序
            [weakSelf setUPListLable];
            // 滚到第一个频道！offset、下划线、着色，都去第一个. 直接模拟第一个label被点击：
            ChanneLabel *label = [weakSelf getLabelArrayFromSubviews][selectInteger];
            UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
            [tap setValue:label forKey:@"view"];
            [weakSelf labelClick:tap];
        };
        // cell按钮点击回调
        _sortView.cellButtonClick = ^(UIButton *button){
            // 模拟label被点击
            for (ChanneLabel *label in [weakSelf getLabelArrayFromSubviews]) {
                if ([label.text isEqualToString:button.titleLabel.text]) {
                    [weakSelf sortBtnClick:weakSelf.sortButton]; // 关闭sortView
                    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
                    [tap setValue:label forKey:@"view"];
                    [weakSelf labelClick:tap];
                }
            }
        };
    }
    return _sortView;
}
/*更多按钮的点击方法*/
-(void)sortBtnClick:(UIButton*)sender
{
    UILabel *label = (UILabel*)[self.view viewWithTag:1000];
    UILabel *lineLabel = (UILabel*)[self.view viewWithTag:1001];
    if (self.smallScrollView.hidden==NO) {
        self.smallScrollView.hidden  = YES;
        [sender setTransform:CGAffineTransformMakeRotation(M_PI_4)];
        [self.view addSubview:self.sortView];
        [UIView animateWithDuration:0.1 animations:^{
            _sortView.y = SMALL_H +20;
             self.tabBarController.tabBar.y +=49;
        }];
    }else
    {
        self.smallScrollView.hidden  = NO;
        [sender setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        // 箭头点击回调general_jianTouShang
        [UIView animateWithDuration:0.1 animations:^{
            [self.sortView removeFromSuperview];
            [label removeFromSuperview];
            [lineLabel removeFromSuperview];
            self.sortView = nil;
          // self.tabBarController.tabBar.hidden = NO;
            self.tabBarController.tabBar.y =SCREEN_HEIGHT - 49;
            // 这么写防止用户多次点击label和排序按钮，造成tabbar错乱
        }];
    }
}
#pragma mark--获取头部试图数据
-(void)requestGetHeadData
{
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
         __weak typeof(self) weakSelf = self;
    dispatch_group_async(group, queue, ^{
        AFNetworkRequest *networkRequest = [[AFNetworkRequest alloc]init];
        [networkRequest requestWithVC:self URLString:[NSString stringWithFormat:@"%@%@",BASE_URL,GETART_LIST] parameters:[NSMutableDictionary dictionary] type:NetworkRequestTypeGet resultBlock:^(id responseObject, NSError *error) {
            if (!error) {
                NSArray *respDataArr = responseObject[@"data"];
                _channelList = [ArticalList mj_objectArrayWithKeyValuesArray:respDataArr];
                for (int i=0; i<_channelList.count; i++) {
                    ArticalList *art = _channelList[i];
                    art.urlStr = [NSString stringWithFormat:@"%d",[art.artID intValue]];
                }
                NSMutableArray*nowArr = [[AllDatabase sharedAllDatabase] allHistory:AllDatabaseTypeHot];
                if (nowArr.count==_channelList.count) {
                    for (int i=0; i<_channelList.count; i++) {
                        if ([nowArr indexOfObject:_channelList[i]]) {
                            _channelList = nowArr;
                        }else
                        {
                            [[AllDatabase sharedAllDatabase]insertHistoryItem:_channelList WithSql:AllDatabaseTypeHot];
                        }
                    }
                }else
                {
                    [[AllDatabase sharedAllDatabase]insertHistoryItem:_channelList WithSql:AllDatabaseTypeHot];
                }
                if (_channelList.count!=0) {
                    [self.view addSubview:self.smallScrollView];
                    [self.view addSubview:self.bigCollectionView];
                    [self.view addSubview:self.sortButton];
                    weakSelf.smallScrollView.hidden = NO;
                    weakSelf.bigCollectionView.hidden = NO;
                    weakSelf.sortButton.hidden = NO;
                }
            }else
            {
                weakSelf.smallScrollView.hidden = YES;
                weakSelf.bigCollectionView.hidden = YES;
                weakSelf.sortButton.hidden = YES;
                UIImageView*imghold = [ProTool setViewPlaceHoldImage:145 WithBgView:self.view];
                imghold.userInteractionEnabled = YES;
                [imghold addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadData:)]];
            }
        }];
    });
}
//勿网状态重新加载
-(void)loadData:(UIGestureRecognizer*)gesture
{
    if (![NetHelp isConnectionAvailable]) {
        return;
    }
    UIImageView*bgimg =(UIImageView*)gesture.view;
    [bgimg removeFromSuperview];
    bgimg = nil;
    [self.smallScrollView removeFromSuperview];
    self.smallScrollView = nil;
    [self requestGetHeadData];//获取头部数据
}
//属性初始化
-(NSMutableArray*)channelList
{
    if (!_channelList) {
        _channelList = [NSMutableArray array];
    }
    return _channelList;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
