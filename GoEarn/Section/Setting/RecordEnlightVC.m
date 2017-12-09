//
//  RecordEnlightVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/12/20.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "RecordEnlightVC.h"
#import "Enght_Cell.h"
#import "AssortDetailModel.h"
#import "MJRefresh.h"
#import "EnlighttModel.h"

@interface RecordEnlightVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView  * tableView;
@property (nonatomic,strong) NSMutableArray  * DataArr;
@property (nonatomic,assign) NSInteger    pageNum;//页数
@property (nonatomic,strong) EnlighttModel  *enliModel;
@property (nonatomic,strong) UILabel *nextLab ;

@end

@implementation RecordEnlightVC
{
    NSMutableArray *DaArr ;
}
-(NSMutableArray *)DataArr{
    if (!_DataArr) {
        _DataArr = [NSMutableArray array];
    }
    return _DataArr;
}
-(EnlighttModel *)enliModel{
    if (!_enliModel) {
        _enliModel = [[EnlighttModel alloc] init];
    }
    return _enliModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAINCOLOR;
    DaArr = [NSMutableArray array];//加载总数据
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
    UILabel *TitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, baseView.width, 20)];
    TitleLab.textColor = UIColorFromRGB(0x333333);
    TitleLab.font  = Font(18);
    TitleLab.textAlignment = NSTextAlignmentCenter;
    TitleLab.text = @"收徒记录";
    
    UILabel *nextLab = [[UILabel alloc] initWithFrame:CGRectMake(0, TitleLab.bottom +5,TitleLab.width, 10)];
    nextLab.textColor = UIColorFromRGB(0x808080);
    nextLab.font  = Font(10);
    self.nextLab = nextLab;
    [baseView addSubview:TitleLab];
    nextLab.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:nextLab];
    self.navigationItem.titleView =baseView;
    self.pageNum = 1;
    
    [self createUI];
    
    //默认状态下数据请求
    [self GetAssortReportRequest:self.pageNum dropDowm:NO];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf refreshData];
    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMoreData];
    }];
    
}
-(void)createUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor =UIColorFromRGB(0xf2f5f7);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    [self.view addSubview:self.tableView];
    
}
/** 下拉刷新 */
- (void)refreshData
{
    [self GetAssortReportRequest:1 dropDowm:YES];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self.tableView.mj_footer resetNoMoreData];
    self.tableView.mj_footer.hidden =NO;
}

/** 上拉加载 */
- (void)loadMoreData
{
    
    if ([self.enliModel.isEnd integerValue] ==1) {
        
        [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden =YES;
        [self.tableView.mj_footer resetNoMoreData];
    }else
    {
        self.pageNum++;
        [self GetAssortReportRequest:self.pageNum dropDowm:NO];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        
    }
    
    
}



#pragma UITableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.DataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.DataArr[section];
    return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;//设置尾视图高度为0.01
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    EnlighttModel *model = [EnlighttModel new];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.backgroundColor = UIColorFromRGB(0xf2f5f7);

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 150, 30)];
    title.textColor = UIColorFromRGB(0x999999);
    title.font = Font(12);
    model =self.DataArr[section][0];
    
    NSString *timeStamp2 =model.add_time;
    long long int date1 = (long long int)[timeStamp2 intValue];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date2];
    
    title.text = dateString;
    [headerView addSubview:title];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    EnlighttModel *model = [EnlighttModel new];
    
    Enght_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Enght_Cell"];
    if (cell == nil)
    {
        cell = [[Enght_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Enght_Cell"];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.DataArr.count) {
        NSArray *sectArr= self.DataArr[section];
        model = sectArr[row];
        if (sectArr.count==row+1) {
            cell.LINE.hidden = YES;
        }else{
            cell.LINE.hidden = NO;
        }
    }
    
    [cell.avaterIMG sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"record_default"]];
    if (![model.nickname isEmptyString]) {
        cell.titleLab.text =model.nickname;
    }else{
        cell.titleLab.text =@"昵称";
    }
    
    cell.IDLab.text = [NSString stringWithFormat:@"ID:%@",model.no];
    if ([model.money integerValue] !=0) {
        cell.MoneyLab.text = [NSString stringWithFormat:@"%@元",model.money];
    }else{
        cell.MoneyLab.text = @"暂无贡献";
        cell.MoneyLab.textColor = UIColorFromRGB(0xb2b2b2);
        cell.MoneyLab.font = Font(13);
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)GetAssortReportRequest:(NSInteger)value dropDowm:(BOOL)isDown{
    [self.DataArr removeAllObjects];
    if (isDown==YES) {
        [DaArr removeAllObjects];
    }
    //数据源清空造成替换数据错误
    NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:string forKey:@"session"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)value] forKey:@"p"];
    
    __weak typeof(self) weakSelf = self;
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,ApprenticeListURL] parameters:dic type:NetworkRequestTypeGet resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
            weakSelf.enliModel.isEnd = responseObject[@"data"][@"isEnd"];
            weakSelf.enliModel.count = responseObject[@"data"][@"count"];
            self.nextLab.text = [NSString stringWithFormat:@"(已收徒%@人)",responseObject[@"data"][@"count"]];
            NSArray *SEArr = responseObject[@"data"][@"list"];
            [DaArr addObject:SEArr];
     //timeArr为抽出时间放入一个单独数组
            NSMutableArray *timeArr=[NSMutableArray array];
            NSMutableArray *titleArr=[NSMutableArray array];
            NSMutableArray *FAArr = [NSMutableArray array];
            [DaArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSArray *currentArr = obj;
                [FAArr addObjectsFromArray:currentArr];
                
            }];
            
            [FAArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *currentDict=obj;
                NSString *add_time=[currentDict objectForKey:@"add_time"];
                [timeArr addObject:add_time];
                
            }];
            
            NSLog(@"---------------%@",timeArr);
            //使用asset把timeArr的日期去重
            NSSet *set = [NSSet setWithArray:timeArr];
            NSArray *userArray = [set allObjects];
            NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
            //按日期降序排列的日期数组
            NSArray *myary = [userArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
            //此时得到的myary就是按照时间降序排列拍好的数组
            
            //遍历myary把_titleArray按照myary里的时间分成几个组每个组都是空的数组
            [myary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSMutableArray *arr=[NSMutableArray array];
                [titleArr addObject:arr];
                
            }];
            
            //遍历_dataArray取其中每个数据的日期看看与myary里的那个日期匹配就把这个数据装到_titleArray 对应的组中
            NSMutableArray *HXArr = [NSMutableArray array];
            [DaArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSArray *currentArr = obj;
                [HXArr addObjectsFromArray:currentArr];
                
            }];
            
            [HXArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *currentDict=obj;
                NSString *add_time=[currentDict objectForKey:@"add_time"];
                for (NSString *str in myary)
                {
                    if([str isEqualToString:add_time])
                    {
                        NSMutableArray *arr=[titleArr objectAtIndex:[myary indexOfObject:str]];
                        [arr addObject:currentDict];
                    }
                }
                
            }];
            
            for (int i=0; i<titleArr.count; i++) {
                NSMutableArray *SAArr = [NSMutableArray array];
                NSArray *arr = titleArr[i];
                SAArr = [EnlighttModel mj_objectArrayWithKeyValuesArray:arr];
                [self.DataArr addObject:SAArr];
            }
            [weakSelf.tableView reloadData];
        }else if ([responseObject[@"code"] intValue] ==60003){
            [MBProgressHUD showMessage:responseObject[@"msg"]];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        else
        {
            [MBProgressHUD showMessage:@"msg"];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
    }];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
