//
//  HomeSortVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/13.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "HomeSortVC.h"
#import "FYShuaxingHeader.h"
#import "DOPDropDownMenu.h"
#import "FYHomeListCell.h"
#import "HomeListModel.h"
#import "QRCodeAlertView.h"
#import "HomeWebVC.h"
#import "HomeListType.h"
#import "HomeListCellModel.h"
#import "HomeAgentWebVC.h"
@interface HomeSortVC ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource,QRCodeAlertViewDelegate,PublicAlertViewDelegate>
@property(nonatomic,assign)BOOL isBack;//返回刷新
@property(nonatomic,strong)AppDelegate  * appDelegate;
@property(nonatomic,strong)HomeListCellModel  * nowSelectedListModel;
@property(nonatomic,assign)BOOL  isDropCurrentMission;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)NSArray  * dropMenueArr;
@property(nonatomic,strong)DOPDropDownMenu  * menu;
@property(nonatomic,strong)HomeListModel  * homeModel;
@property(nonatomic,strong)NSMutableArray  * dataSource;
//@property (nonatomic, strong) UIView *yourSuperView;
@end

@implementation HomeSortVC
-(NSMutableArray*)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTab:) name:MISSONDONENOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTab:) name:BACKFREFRESH object:nil];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];//隐藏 常态时是否隐藏 动画时是否显示
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.title = self.appDelegate.selectedTypeModel.alias;
    [self initData];//初始化数据
    
    [self creatHeadView];

    [self initTableview];//初始化表格
    
    self.isBack = YES;
    //列表数据
    [self initDataWithList:self.appDelegate.selectedTypeModel.ID WithMoney:self.appDelegate.moneyup WithTime:self.appDelegate.timeup];// 列表
}
-(void)creatHeadView
{
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45 fromHome:NO selectedMenudIndex:0 superTab:self.tableView];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    
    self.menu = menu;
    
    NSMutableArray *dropArr = [NSMutableArray array];
    for (HomeListType*list in self.menuArr) {
        [dropArr addObject:list.alias];
    }
    NSInteger selectedInteger = [dropArr indexOfObject:self.appDelegate.selectedTypeModel.alias];
    [menu confiMenuWithSelectRow:selectedInteger];
    [menu inintTitleLayerColor];
}
-(void)reloadTab:(NSNotification*)noti
{
    //[self setupTableView];
    self.isBack = YES;
    self.title = self.appDelegate.selectedTypeModel.alias;
    [self initDataWithList:self.appDelegate.selectedTypeModel.ID WithMoney:self.appDelegate.moneyup WithTime:self.appDelegate.timeup];

    NSMutableArray *dropArr = [NSMutableArray array];
    for (HomeListType*list in self.menuArr) {
        [dropArr addObject:list.alias];
    }
    NSInteger selectedInteger = [dropArr indexOfObject:self.appDelegate.selectedTypeModel.alias];
    [self.menu confiMenuWithSelectRow:selectedInteger];
    [self.menu inintTitleLayerColor];
}
#pragma mark - 初始化表格
-(void)initTableview
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT -64- 45) style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f5f7);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self setupTableView];//初始化下拉刷新(基于tableview需要先初始化tableview)
    
}
#pragma mark - 初始化
-(void)initData
{
    NSMutableArray *dropArr = [NSMutableArray array];
    for (HomeListType*list in self.menuArr) {
        [dropArr addObject:list.alias];
    }
    
    self.dropMenueArr = [NSArray arrayWithObjects:@{@"source":dropArr},@{@"source":@[@"佣金排序"]},@{@"source":@[@"时间排序"]}, nil];
    [self removeAdvImage];
    
}
#pragma mark - 初始化刷新

-(void)setupTableView
{
    self.tableView.mj_header = [FYShuaxingHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];    
    // 马上进入刷新状态
   // [self.tableView.mj_header beginRefreshing];
}
-(void)loadNewData
{
    //清除缓存：
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
    //然后检查缓存是否被清：
    NSInteger sizeInteger = [[NSURLCache sharedURLCache] currentDiskUsage];
    float sizeInMB = sizeInteger / (1024.0f * 1024.0f);
    DLog(@"缓存%f",sizeInMB);

    [self initDataWithList:self.appDelegate.selectedTypeModel.ID WithMoney:self.appDelegate.moneyup WithTime:self.appDelegate.timeup];
    [self performSelector:@selector(timeAction) withObject:nil afterDelay:3];
}
//刷新失败嗲用
-(void)timeAction {

    //  停止刷新
    [_tableView.mj_header endRefreshing];
    
}
#pragma mark - UITablviewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeListCellModel *model = self.dataSource[indexPath.row];
    UITableViewCell *cell = [FYHomeListCell cellWithTableView:tableView model:model cellType:[self.appDelegate.selectedTypeModel.ID intValue] withIndexPath:indexPath];
    return cell;  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.appDelegate.selectedTypeModel.ID intValue]==4) {
        //抢任务
        HomeListCellModel *model = self.dataSource[indexPath.row];
        [self goFuckAgentMisson:model.no];
    }else
    {
    //抢任务
    HomeListCellModel *model = self.dataSource[indexPath.row];
    self.nowSelectedListModel = model;
    if ([self.appDelegate.selectedListModel.no intValue] ==[self.nowSelectedListModel.no intValue]&&self.appDelegate.dropAgain == NO)
    {
        HomeWebVC *web = [[HomeWebVC alloc]init];
        FYHomeListCell *cell = (FYHomeListCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        if (model.status !=0)
        {
            NSString *time = [NSString stringWithFormat:@"%ld",cell.timeOutLabel.minute *60+cell.timeOutLabel.second];
            DLog(@"000000------%@",time);
            self.appDelegate.timeOutString = time;
        }else
        {
            NSDictionary *dateDic = [NSString dictionaryWithDateString:model.countdown];
            NSString *time = [NSString stringWithFormat:@"%ld",[dateDic[@"min"] integerValue]*60+[dateDic[@"sec"] integerValue]];
            self.appDelegate.timeOutString = time;
            DLog(@"111111------%@",time);
            
        }
        [self.navigationController pushViewController:web animated:YES];
    }else
    {
      [self goFuckTheMisson:model.no];
    }
    }
}
#pragma mark---dropmeueDelegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return self.dropMenueArr.count;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    NSArray *arr = self.dropMenueArr[column][@"source"];
    return arr.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    NSArray *arr = self.dropMenueArr[indexPath.column][@"source"];
    
    return arr[indexPath.row];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    self.appDelegate.selectedTypeModel =self.appDelegate.homeTypeArr[indexPath.row];
    self.title = self.appDelegate.selectedTypeModel.alias;
    [self initDataWithList:self.appDelegate.selectedTypeModel.ID WithMoney:self.appDelegate.moneyup WithTime:self.appDelegate.timeup];
}
-(void)munu:(DOPDropDownMenu*)menu disSelectedSort:(NSDictionary*)sortDic
{
    DLog(@"sortDic === %@",sortDic);
    if ([sortDic[@"money"] isEqualToString:@"1"]) {
        _appDelegate.moneyup = @"asc";
    }else if ([sortDic[@"money"] isEqualToString:@"2"])
    {
        _appDelegate.moneyup = @"desc";
    }else
    {
        _appDelegate.moneyup = nil;
    }if ([sortDic[@"time"] isEqualToString:@"1"]) {
        _appDelegate.timeup = @"asc";
    }else if ([sortDic[@"time"] isEqualToString:@"2"])
    {
        _appDelegate.timeup = @"desc";
    }else
    {
        _appDelegate.timeup = nil;
    }
    [self initDataWithList:self.appDelegate.selectedTypeModel.ID WithMoney:self.appDelegate.moneyup WithTime:self.appDelegate.timeup];
}
-(void)menu:(DOPDropDownMenu *)menu show:(BOOL)show
{
}
#pragma alertdelegare
-(void)alertView:(QRCodeAlertView *)alertView message:(NSString *)message
{
    [MBProgressHUD showMessage:message];
}

//任务列表数据
-(void)initDataWithList:(NSString*)number WithMoney:(NSString*)money WithTime:(NSString*)time
{
    if (self.isBack ==YES) {
        [MBProgressHUD showIndicator];
    }
    typeof(self)weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[LWAccountTool account].no forKey:@"no"];
    [dic setObject:number forKey:@"type"];
    if (time) {
        [dic setObject:time forKey:@"time_sort"];
    }if (money) {
        [dic setObject:money forKey:@"money_sort"];
    }
    
    [[[AFNetworkRequest alloc]init] requestWithVC:self URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetTaskListURL] parameters:dic type:NetworkRequestTypeGet resultBlock:^(id responseObject, NSError *error) {
        weakSelf.isBack = NO;
        [MBProgressHUD hideAllHUD];
        [weakSelf.dataSource removeAllObjects];
        if (error) {
            [MBProgressHUD showError:@"请求失败，请稍后再试!"];
        }else
        {
            if ([responseObject[@"code"] intValue] ==0) {
                NSDictionary *dict =responseObject[@"data"];
                weakSelf.homeModel =[HomeListModel mj_objectWithKeyValues:dict];
                [weakSelf.dataSource addObjectsFromArray:self.homeModel.listing];
            }else
            {
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
            
        }
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView.mj_header endRefreshing];
    }];
}
//抢任务
-(void)goFuckTheMisson:(NSString*)missionID
{
    NSString * isDrop = self.isDropCurrentMission ==YES?@"1":@"0";
    
    [[LoadingView shareInstance]showLoading:self withMessage:@"正在领取任务"];
    [[[AFNetworkRequest alloc]init] requestWithVC:self URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GLOMTask] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",missionID,@"tno",isDrop,@"is", nil] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        [[LoadingView shareInstance]hiden];
        if (error) {
            [MBProgressHUD showError:@"请求失败，请稍后再试!"];
        }else
        {
            if ([responseObject[@"code"] intValue] ==0) {
                UserDefaultSetObjectForKey(@"0", SEARCHMORE)
                UserDefaultSetObjectForKey(@"0", OPENMORE)
                UserDefaultSetObjectForKey(@"0", UPDATEMORE)
                NSDictionary *dic = responseObject[@"data"];
                HomeWebVC *web = [[HomeWebVC alloc]init];
                self.appDelegate.dropAgain = YES;
                if ([self.appDelegate.selectedTypeModel.ID intValue] !=3)
                {
                    self.appDelegate.second = 0;
                    [self.appDelegate.openAppTimer invalidate];
                    self.appDelegate.openAppTimer = nil;
                    [self.appDelegate.appOverTimer invalidate];
                    self.appDelegate.appOverTimer = nil;
                }else
                {
                    if (self.appDelegate.second ==0)
                    {
                        self.appDelegate.second = [UserDefaultObjectForKey(APP_TIME) integerValue] *60;
                        [self.appDelegate.openAppTimer invalidate];
                        self.appDelegate.openAppTimer = nil;
                        [self.appDelegate.appOverTimer invalidate];
                        self.appDelegate.appOverTimer = nil;
                    }
                    
                }
                self.appDelegate.selectedListModel = self.nowSelectedListModel;
                self.appDelegate.timeOutString = dic[@"countdown"];
                self.appDelegate.missionID = dic[@"utno"];
                self.appDelegate.selectedUrl =dic[@"url"];
                
                self.appDelegate.reportDic = dic[@"app"];
                self.appDelegate.submitArr = dic[@"submit"];
                DLog(@"submitArr抢过-----%@", self.appDelegate.submitArr );
                self.appDelegate.is_upload = [dic[@"is_upload"] intValue];
            DLog(@"self.appDelegate.missionID===%@",self.appDelegate.missionID);
                [self.navigationController pushViewController:web animated:YES];
                
            }else if([responseObject[@"code"] intValue] ==60006)
            {
                NSDictionary *dic = responseObject[@"data"];
                self.appDelegate.timeOutString = dic[@"countdown"];
                self.appDelegate.is_upload = [dic[@"is_upload"] intValue];
                self.appDelegate.submitArr = dic[@"submit"];
                
                self.appDelegate.reportDic = dic[@"app"];
                DLog(@"submitArr之前抢过---%@", self.appDelegate.submitArr );
                self.appDelegate.missionID = dic[@"utno"];
                self.appDelegate.selectedUrl = dic[@"url"];
                NSString *IDString = dic[@"type"];
                
                for (HomeListType *type in self.appDelegate.homeTypeArr)
                {
                    if ([type.ID isEqualToString:IDString])
                    {
                        self.appDelegate.nowSelectedTypeModel = type;
                    }
                }

                PublicAlertView *pub = [[PublicAlertView alloc]initWithTitle:nil message:@"您有未完成的任务\n要放弃这个任务吗" delegate:self cancelButtonTitle:@"放弃" otherButtonTitle:@"继续" withMsFont:[UIFont systemFontOfSize:17] withTitleFont:nil];
                [pub show];
            }else
            {
                PublicAlertView *pub = [[PublicAlertView alloc]initWithTitle:nil message:responseObject[@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitle:@"我知道了" withMsFont:[UIFont systemFontOfSize:15] withTitleFont:nil];
                [pub show];
            }
        }
    }];
}

//抢特工任务
-(void)goFuckAgentMisson:(NSString*)missionID
{
    [[LoadingView shareInstance]showLoading:self withMessage:@"正在领取任务"];
    [[[AFNetworkRequest alloc]init] requestWithVC:self URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,FUCKAGENTMISSION] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",missionID,@"tno", nil] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        [[LoadingView shareInstance]hiden];
        if (error) {
            [MBProgressHUD showError:@"请求失败，请稍后再试!"];
        }else
        {
            if ([responseObject[@"code"] intValue] ==0)
            {
                NSDictionary *dic = responseObject[@"data"];
                HomeAgentWebVC *vc = [[HomeAgentWebVC alloc]init];
                vc.submitArr = dic[@"submit"];
                vc.utno = dic[@"utno"];
                vc.countdown = dic[@"countdown"];
                vc.url = dic[@"url"];
                DLog(@"sub特工----%@",dic[@"submit"]);
                [self.navigationController pushViewController:vc animated:YES];
                
            }else
            {
                PublicAlertView *pub = [[PublicAlertView alloc]initWithTitle:nil message:responseObject[@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitle:@"我知道了" withMsFont:[UIFont systemFontOfSize:15] withTitleFont:nil];
                [pub show];
            }
        }
    }];
}

#define mark --弹框delegate
-(void)PublicAlertView:(PublicAlertView *)alert buttonindex:(NSInteger )index
{
    //1去完成 2放弃
    if (index ==1) {
        self.isDropCurrentMission = NO;
        
        self.appDelegate.selectedTypeModel = self.appDelegate.nowSelectedTypeModel;
        
        HomeWebVC *web = [[HomeWebVC alloc]init];
        [self.navigationController pushViewController:web animated:YES];
    }else
    {
        self.isDropCurrentMission = YES;
        [self goFuckTheMisson:self.nowSelectedListModel.no];
        self.isDropCurrentMission = NO;
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MISSONDONENOTIFICATION object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MISSONDONENOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BACKFREFRESH object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
