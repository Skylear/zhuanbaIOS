//
//  MessageListVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/27.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "MessageListVC.h"
#import "ArticalModel.h"
#import "NewsCell.h"
#import "ProTool.h"
#import "NetHelp.h"
#import "MessageDetailVC.h"
#import "MessageDetailVC.h"
@interface MessageListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataList;//存储文章列表
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)int pageNum;//页数

@property(nonatomic,assign)int totalNum;//总页数

@property(nonatomic,assign)BOOL isEnd;

@end

@implementation MessageListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requsetGetArticalData];//获取文章信息
    
    self.pageNum = 1;
    self.totalNum = 2;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20-49-40) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.tableView flashScrollIndicators];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}
/** 下拉刷新 */
- (void)refreshData
{
    self.pageNum=1;
    [self requsetGetArticalData];//获取文章信息
    [self.tableView.mj_header endRefreshing];
}

/** 上拉加载 */
- (void)loadMoreData
{
    if (self.isEnd) {
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        
        return;
    }else{
        self.pageNum++;
        [self requsetGetArticalData];//获取文章信息
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticalModel *newmodel = _dataList[indexPath.row];
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewsCell cellReuseID:newmodel]];
    if (!cell) {
        cell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewsCell cellReuseID:newmodel]];
    }
    cell.model = newmodel;
    
    if (self.titleID ==23&&[self.headTitle isEqualToString:@"商业"])
    {
        cell.timeLabel.hidden = YES;
    }
    [self creatCycleImageClickWithCell:cell newModel:newmodel];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc]initWithFrame:CGRectZero];
    return head;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticalModel *newsModel = self.dataList[indexPath.row];
    return [NewsCell cellForHeight:newsModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticalModel *art = self.dataList[indexPath.row];
    MessageDetailVC *VC = [[MessageDetailVC alloc]init];
    VC.aid = art.artID;
    VC.adUrl = art.url;
    VC.model = art;
    [self.navigationController pushViewController:VC animated:YES];
}
/**
 *获取文章信息
 */
-(void)requsetGetArticalData
{
    NSMutableDictionary *dic  =[NSMutableDictionary dictionary];
    
    [dic setObject:self.urlString forKey:@"cateId"];
    
    [dic setObject:[NSString stringWithFormat:@"%d",self.pageNum] forKey:@"p"];
        __weak typeof(self) weakSelf = self;
    [[[AFNetworkRequest alloc]init] requestWithVC:self URLString:[NSString stringWithFormat:@"%@%@",BASE_URL,GETART_DATA] parameters:dic type:NetworkRequestTypeGet resultBlock:^(id responseObject, NSError *error) {
        if (!error) {
            weakSelf.tableView.hidden = NO;
            NSDictionary *respDataDic = responseObject[@"data"];
            NSArray*respDataArr = respDataDic[@"list"];
            // NSArray *adArr = respDataDic[@"adver"];
            self.isEnd = [respDataDic[@"isEnd"] boolValue];
            if ([respDataArr isEqual:[NSNull null]]) {
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                return ;
            }
            else {
                if (self.pageNum==1)
                {
                    [self.dataList removeAllObjects];
                }
                self.totalNum++;
                NSArray *dataArr = [ArticalModel mj_objectArrayWithKeyValuesArray:respDataArr];
                if (self.isEnd==1) {
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                }else
                {
                    [self.tableView.mj_footer setState:MJRefreshStateIdle];
                }
                [self.dataList addObjectsFromArray:dataArr];
                if ([self.urlString intValue]==1&self.pageNum ==1)
                {
                    for (int i=0; i<4; i++)
                    {
                        ArticalModel *art = self.dataList[i];
                        UIImageView *img = [[UIImageView alloc]init];
                        [img sd_setImageWithURL:[NSURL URLWithString:art.img]];
                    }
                    
                    ArticalModel *art = [[ArticalModel alloc]init];
                    art.ads = @[self.dataList[0],self.dataList[1],self.dataList[2],self.dataList[3]];
                    [self.dataList removeObjectsInRange: NSMakeRange(0, 4)];
                    [self.dataList insertObject:art atIndex:0];
                }
                [self.tableView reloadData];
            }
            self.tableView.mj_footer.hidden = NO;
        }else
        {
            weakSelf.tableView.hidden = YES;
            self.tableView.mj_footer.hidden = NO;
            UIImageView*imghold = [ProTool setViewPlaceHoldImage:100 WithBgView:self.view];
            imghold.userInteractionEnabled = YES;
            [imghold addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadData:)]];
        }
    }];
    
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
    [self refreshData];//获取文章信息
}
/**
 *  点击cycle图片
 */
-(void)creatCycleImageClickWithCell:(NewsCell*)cell newModel:(ArticalModel*)newModel
{
    cell.cycleImageClickBlock=^(NSInteger index,ArticalModel *art)
    {
                BOOL isTaobao = [ProTool judgeTaoBaoString:art.url];
                
                if (isTaobao ==YES)
                {
                    NSString *realString = [ProTool tansfromTaoBaoString:art.url];
                    NSURL *url = [NSURL URLWithString:realString];
                    // 判断当前系统是否有安装淘宝客户端
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        // 如果已经安装淘宝客户端，就使用客户端打开链接
                        [[UIApplication sharedApplication] openURL:url];
                    } else {
                        MessageDetailVC *VC = [[MessageDetailVC alloc]init];
                        VC.aid = art.artID;
                        VC.adUrl = art.url;
                        VC.model = art;
                        [self.navigationController pushViewController:VC animated:YES];
                    }
                }else {
                    
                    MessageDetailVC *VC = [[MessageDetailVC alloc]init];
                    VC.aid = art.artID;
                    VC.adUrl = art.url;
                    VC.model = art;
                    [self.navigationController pushViewController:VC animated:YES];
                }
     };
}
//初始化
-(NSMutableArray*)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
