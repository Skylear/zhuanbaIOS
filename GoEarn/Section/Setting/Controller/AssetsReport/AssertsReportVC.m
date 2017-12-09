//
//  AssertsReportVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/9.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "AssertsReportVC.h"
#import "AssertTableViewCell.h"
#import "AssortDetailModel.h"
#import "MJRefresh.h"
#import "AssortModel.h"

@interface AssertsReportVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray  * DataArr;
@property (nonatomic,strong) NSMutableArray  * TitleArr;
@property (nonatomic,assign) NSInteger    pageNum;//页数
@property (nonatomic,strong) AssortModel  *assortModel;
@end

@implementation AssertsReportVC
-(NSMutableArray *)DataArr{
    if (!_DataArr) {
        _DataArr = [NSMutableArray array];
    }
    return _DataArr;
}
-(NSMutableArray *)TitleArr{
    if (!_TitleArr) {
        _TitleArr = [NSMutableArray array];
    }
    return _TitleArr;
}
-(AssortModel *)assortModel{
    if (!_assortModel) {
        _assortModel = [[AssortModel alloc] init];
    }
    return _assortModel;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
  
    self.pageNum = 1;

    [self createUI];

    //默认状态下数据请求
    [self GetAssortReportRequest:1];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf refreshData];
    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMoreData];
    }];
    self.tableView.mj_footer.backgroundColor = MAINCOLOR;
    self.tableView.mj_footer.hidden =YES;
}


/** 下拉刷新 */
- (void)refreshData
{
    
    [self GetAssortReportRequest:self.pageNum];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self.tableView.mj_footer resetNoMoreData];
    self.tableView.mj_footer.hidden =YES;
}

/** 上拉加载 */
- (void)loadMoreData
{

    
    if ([self.assortModel.isEnd integerValue] ==1) {
      
        [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden =YES;
        [self.tableView.mj_footer resetNoMoreData];
    }else
    {
        self.pageNum++;
        [self GetAssortReportRequest:self.pageNum];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        self.tableView.mj_footer.hidden =YES;
    }
    
    
}

-(void)createUI{
    self.tableView.backgroundColor = MAINCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma UITableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.DataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    AssortDetailModel *model = [AssortDetailModel new];
    
    AssertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssertTableViewCell"];
    if (cell == nil)
    {
        cell = [[AssertTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AssertTableViewCell"];
    }
    if (self.DataArr.count) {
        model = self.DataArr[row];
    }
    NSString *TypeString;
    if ([model.type intValue]==1) {
        TypeString = @"+";
    }else{
        TypeString = @"-";
    }
    NSString *string = [NSString stringWithFormat:@"%@%@",TypeString,model.money];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLab.text =model.desc;
    cell.earnLab.text = string;
    
    NSString *timeStamp2 =model.add_time;
    long long int date1 = (long long int)[timeStamp2 intValue];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date2];
    cell.timeLab.text =dateString;
    
    //    GRLog(@"-----%lu",_titleArray.count);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}
//资产明细request
-(void)GetAssortReportRequest:(NSInteger)value{
    [self.DataArr removeAllObjects];
    NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:string forKey:@"session"];
    [dic setValue:@"1" forKey:@"p"];
    
    __weak typeof(self) weakSelf = self;
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetUserMoneyListURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
           weakSelf.assortModel = [AssortModel mj_objectWithKeyValues:responseObject[@"data"]];
           weakSelf.DataArr = [AssortDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"List"]];
            [weakSelf.tableView reloadData];
        }else if ([responseObject[@"code"] intValue] ==60003){
            [MBProgressHUD showMessage:responseObject[@"msg"]];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        else
        {
            [MBProgressHUD showMessage:@"绑定失败!"];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            [weakSelf.tableView.mj_footer endRefreshing];
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
