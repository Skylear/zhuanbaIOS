//
//  HomeVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/23.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "HomeVC.h"
#import "ScoreModel.h"
#import "SystemModel.h"
#import "SystemCatchModel.h"
#import "CalendarView.h"
#import "FYHomeMenuCell.h"
#import "HomeListModel.h"
#import "HomeCommiteVC.h"
#import "HomeViewModel.h"
#import "QRCodeAlertView.h"
#import "FYShuaxingHeader.h"
#import "DOPDropDownMenu.h"
#import "FYHomeListCell.h"
#import "HomeWebVC.h"
#import "HomeSortVC.h"
#import "HomeAppModel.h"
#import "FYtopbannerViewCell.h"
#import "HomeListType.h"
#import "CalendarModel.h"
#import "HomeListCellModel.h"
#import "PublicAlertView.h"
#import "HomeAgentWebVC.h"
@implementation HomeTableView

@end

@interface HomeVC()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,FYtopbannerViewCellDelegate,FYHomeMenuCellDelegate,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource,QRCodeAlertViewDelegate,PublicAlertViewDelegate,CalendarViewDelegate>
@property(nonatomic,strong)AppDelegate  * appDelegate;
@property(nonatomic,strong)HomeListCellModel  * nowSelectedListModel;
@property(nonatomic,assign)BOOL  isDropCurrentMission;
@property(nonatomic,strong)HomeListModel  * homeModel;
@property(nonatomic,strong)NSArray  * dropMenueArr;
@property(nonatomic,strong)DOPDropDownMenu  * menu;
@property(nonatomic,strong)UIButton  * signBtn;
@property (nonatomic, strong) HomeTableView *tableView;

@property(nonatomic,assign)BOOL isBack;//返回刷新

@property (nonatomic) BOOL led;
@property (nonatomic, strong) UIView *navView;
@property(nonatomic,strong)UILabel  * navLabel;
@property (nonatomic, strong) FYtopbannerViewCell *topCell;

@property (nonatomic, strong) NSMutableArray *bannersArray;

@property(nonatomic,strong)NSMutableArray  * dataSource;
@property(nonatomic,assign)BOOL menuShow;

@end

@implementation HomeVC

-(NSMutableArray*)bannersArray
{
    if (!_bannersArray) {
        _bannersArray = [NSMutableArray array];
    }
    return _bannersArray;
}
-(NSMutableArray*)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!UserDefaultObjectForKey(@"firstLogin")||[UserDefaultObjectForKey(FIRST_LODING_FAIL) intValue] ==1) {
        UserDefaultSetObjectForKey(@"1", @"firstLogin")
        [self initDataWithBanner];
    }else
    {
        NSArray *bannerData = [NSKeyedUnarchiver unarchiveObjectWithFile:LOCALBANNERPATH];
        // banner图
        [UserDefaultObjectForKey(BANNERUPDATE) boolValue] ==YES?[self initDataWithBanner]:[self.bannersArray addObjectsFromArray:bannerData];

    }
    DLog(@"typePath =%@",LOCALMISSIONPATH);
    //签到天数
    [self initSignData];
    [self setupnav];//初始化头部
    [self initTableview];//初始化表格
    [self setNav];//真正的头部
    
    self.appDelegate.moneyup = nil;
    self.appDelegate.timeup = nil;
    
}
-(void)reloadTab:(NSNotification*)noti
{
    if (_menu) {
        NSInteger selectedInteger = [self.dropMenueArr indexOfObject:self.appDelegate.selectedTypeModel.alias];

        [_menu confiMenuWithSelectRow:selectedInteger];
        [_menu inintTitleLayerColor];

    }
    int isFail = [UserDefaultObjectForKey(GETSignFail) intValue];
    if (isFail ==1)
    {
        [self initSignData];
    }
    self.isBack =YES;
    //列表数据
    [self initDataWithList:self.appDelegate.selectedTypeModel.ID WithMoney:self.appDelegate.moneyup WithTime:self.appDelegate.timeup];// 列表
}
#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏 常态时是否隐藏 动画时是否显示
    
    if (self.signBtn) {        
        //日历图片
        UIImage *calendImg = [UIImage createShareImage:@"calendar_ico" TEXT:[NSString stringWithFormat:@"%ld",(long)[NSDate day:[NSDate date]]]];
        [self.signBtn setImage:calendImg forState:UIControlStateNormal];
    }
    //图标颜色转换
    if (self.led == NO)
    {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    else
    {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//背景颜色
    self.appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray *dropArr = [NSMutableArray array];
    
    for (HomeListType*list in self.appDelegate.homeTypeArr) {
        [dropArr addObject:list.alias];
    }
    self.dropMenueArr = [NSArray arrayWithObjects:@{@"source":dropArr},@{@"source":@[@"佣金排序"]},@{@"source":@[@"时间排序"]}, nil];
    [self.topCell addTimer];
    //列表数据
    [self initDataWithList:self.appDelegate.selectedTypeModel.ID WithMoney:self.appDelegate.moneyup WithTime:self.appDelegate.timeup];// 列表
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTab:) name:MISSONDONENOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTab:) name:BACKFREFRESH object:nil];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//退出当前ViewController后变回黑色
    [self.topCell closeTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MISSONDONENOTIFICATION object:nil];
    
}
#pragma mark - 初始化表格
-(void)initTableview
{
    self.tableView = [[HomeTableView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+20) style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f5f7);
    self.tableView.isScroing = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self setupTableView];//初始化下拉刷新(基于tableview需要先初始化tableview)
    
}
#pragma mark - 初始化刷新

-(void)setupTableView
{
    self.tableView.mj_header = [FYShuaxingHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 马上进入刷新状态
    //[self.tableView.mj_header beginRefreshing];
    self.navView.hidden = YES;
}

-(void)loadNewData
{
    //清除缓存：
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
    //列表数据
    [self initDataWithList:self.appDelegate.selectedTypeModel.ID WithMoney:self.appDelegate.moneyup WithTime:self.appDelegate.timeup];// 列表
    self.navView.hidden = NO;
    [self performSelector:@selector(timeAction) withObject:nil afterDelay:3];
}
#pragma mark - 初始化头部
-(void)setupnav
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//背景颜色
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];//里面的item颜色
    self.navigationController.navigationBar.translucent = NO;//是否为半透明
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;//默认开启,侧滑返回
   
}
//重新初始化头部,考虑到navigationController定制度很高
-(void)setNav
{
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(-0.5, -0.5, [UIScreen mainScreen].bounds.size.width+1, 64.5)];
    self.navView.backgroundColor = [UIColor whiteColor];
    self.navView.backgroundColor = [self.navView.backgroundColor colorWithAlphaComponent:0];
    
    [self.view addSubview:self.navView];
    //日历图片
    UIImage *calendImg = [UIImage createShareImage:@"calendar_ico" TEXT:[NSString stringWithFormat:@"%ld",(long)[NSDate day:[NSDate date]]]];
    
    self.signBtn = [UIButton buttonWithTitle:@" 未签到" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] imageName:calendImg target:self action:@selector(signBtnClick:) backImage:[UIImage createImageWithColor:[UIColor colorWithWhite:0 alpha:0.15]]];
    
    self.signBtn.layer.cornerRadius = 15;
    self.signBtn.layer.masksToBounds = YES;
    self.signBtn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.25].CGColor;
    self.signBtn.layer.borderWidth = 1.0f;
    
    [self.signBtn setFrame:CGRectMake(SCREEN_WIDTH -85, 27, 80, 30)];
    
    [self.navView addSubview:self.signBtn];
    
    self.navLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, SCREEN_WIDTH -200, self.navView.boundsHeight - 20)];
    self.navLabel.text = @"捞金";
    self.navLabel.font = [UIFont boldSystemFontOfSize:17];
    self.navLabel.textColor = [UIColor clearColor];
    self.navLabel.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:self.navLabel];
    
}
#pragma mark - ScrollView 使用头文件刷新 中的距离
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
       // self.tableView.isScroing = YES;
        CGFloat offsetY = self.tableView.contentOffset.y;
        
        if (offsetY <= 0 && offsetY >= -20)
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.navView.alpha = 1.0;
                             } completion:^(BOOL finished) {
                             }];
            self.navView.backgroundColor = [self.navView.backgroundColor colorWithAlphaComponent:0];
            
        }
        else if (offsetY < -20)
        {
            
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.navView.alpha = 0.0;
                             } completion:^(BOOL finished) {
                             }];
        }
        else if (offsetY > 0)
        {
            if (self.navView.alpha == 0.0)
            {
                self.navView.alpha = 1.0;
            }
            self.navView.backgroundColor = [self.navView.backgroundColor colorWithAlphaComponent:offsetY / 120];
            
        }
            if (offsetY>=SCREEN_WIDTH/2 +6) {
               // DLog(@"+++++*%f",offsetY);
                CGRect newFrame = CGRectMake(0, 64, SCREEN_WIDTH, 45);
                self.menu.frame = newFrame;

                self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 50, 0);
            } else {
               // DLog(@"----*%f",offsetY);
                
                if (_menuShow ==YES) {
                    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 220, 0);
                    self.navView.backgroundColor = [UIColor whiteColor];
                }else
                {
                    CGRect newFrame = CGRectMake(0, SCREEN_WIDTH/2 +6 +64-offsetY, SCREEN_WIDTH, 45);
                    self.menu.frame = newFrame;
                    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 50, 0);
                }
                

            }
        
        //图标颜色转换
        if (offsetY < 80 && offsetY > -25)
        {
            if (self.led == NO)
            {
                self.led = YES;
                self.signBtn.hidden = NO;
                self.navLabel.textColor = [UIColor clearColor];
                [self.signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.signBtn.layer.cornerRadius = 15;
                self.signBtn.layer.masksToBounds = YES;
                self.signBtn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.25].CGColor;
                self.signBtn.layer.borderWidth = 1.0f;
                [self.signBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:0 alpha:0.15]] forState:UIControlStateNormal];
                self.navView.layer.borderWidth = 0.0;//边框线
                self.navView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor;
                
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            }
        }else
        {
            if (self.led == YES)
            {
                self.led = NO;

                if (offsetY < -25)
                {
                    self.signBtn.hidden = YES;
                    self.navView.layer.borderWidth = 0.0;//边框线
                    self.navView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor;
                }else
                {
                    self.signBtn.hidden = NO;
                    self.navView.layer.borderWidth = 0.5;//边框线
                    self.navView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor;
                    self.navLabel.textColor = UIColorFromRGB(0x333333);
                    [self.signBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                    self.signBtn.layer.cornerRadius = 0;
                    self.signBtn.layer.masksToBounds = YES;
                    self.signBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                    self.signBtn.layer.borderWidth = 0.0f;
                    [self.signBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
                }
                
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }
        }
    }
}

#pragma mark - UITablviewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==2) {
        return self.dataSource.count;// <3?3:self.dataSource.count;
    }else
    {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return  indexPath.section ==0?SCREEN_WIDTH/2:80;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ==2?45:0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section ==1?10:0.0001;
}

//自定义的section的头部 或者 底部

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat Heigh =section ==2?45:0.0001;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, Heigh)];
    if(section ==2&&!self.menu)
    {
        DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, SCREEN_WIDTH/2 +6+20+64) andHeight:45 fromHome:YES selectedMenudIndex:0 superTab:self.tableView];
        menu.dataSource = self;
        menu.delegate = self;
        [self.view addSubview:menu];
        self.menu = menu;
    }
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat FHeigh = section ==1?10:0.0001;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, FHeigh)];
    footerView.backgroundColor = UIColorFromRGB(0xf2f5f7);
    
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        self.topCell = [FYtopbannerViewCell cellWithTableView:tableView array:self.bannersArray];
        self.topCell.delegate = self;
        return self.topCell;
    }else if(indexPath.section == 1)
    {
        FYHomeMenuCell *cell = [FYHomeMenuCell cellWithTableView:tableView menuArray:self.appDelegate.homeTypeArr];
        cell.delegate = self;
        return cell;
    }
    else
    {
        if (_homeModel.listing.count-1<indexPath.row||!_homeModel) {
            UITableViewCell*cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"noCell"];
            return cell;
        }else
        {
            HomeListCellModel *model = self.dataSource[indexPath.row];
            UITableViewCell *cell = [FYHomeListCell cellWithTableView:tableView model:model cellType:[self.appDelegate.selectedTypeModel.ID intValue] withIndexPath:indexPath];
            return cell;
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //没有数据时
    if (_homeModel.listing.count-1<indexPath.row||!_homeModel) {
        
    }else
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
    if (indexPath.row>arr.count) {
        return self.appDelegate.selectedTypeModel.alias;
    }
    return arr[indexPath.row];
    
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    DLog(@"column:%li row:%li", (long)indexPath.column, (long)indexPath.row);
    self.appDelegate.selectedTypeModel =self.appDelegate.homeTypeArr[indexPath.row];
    [self initDataWithList:self.appDelegate.selectedTypeModel.ID WithMoney:self.appDelegate.moneyup WithTime:self.appDelegate.timeup];
    DLog(@"%@",self.appDelegate.selectedTypeModel.alias);
    
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
    if (show) {
        _menuShow = YES;
        self.tabBarController.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT+49, SCREEN_WIDTH, 49);
        
        [UIView animateWithDuration:0.1 animations:^{
          [self.tableView setContentOffset:CGPointMake(0, SCREEN_WIDTH/2 +6)];
        } completion:nil];
    }else
    {
        _menuShow = NO;
        if (self.homeModel.listing.count ==0) {
            [UIView animateWithDuration:0.1 animations:^{
                [self.tableView setContentOffset:CGPointMake(0, -20)];
            } completion:nil];
        }
       self.tabBarController.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
    }
}
#pragma HomeMenuDelegate
-(void)didSelectedHomeMenuCellAtIndex:(NSInteger)index
{
    HomeSortVC *vc = [[HomeSortVC alloc]init];
    vc.menuArr = self.appDelegate.homeTypeArr;
    self.appDelegate.selectedTypeModel = self.appDelegate.homeTypeArr[index];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma alertdelegare
-(void)alertView:(QRCodeAlertView *)alertView message:(NSString *)message
{
    [MBProgressHUD showMessage:message];
}
//  签到
-(void)signBtnClick:(UIButton*)sender
{
    BOOL isSign = NO;
    if ([self.signBtn.titleLabel.text isEqualToString:@" 未签到"])
    {
        isSign = YES;
        [[CalendarView shareInstance] signToday];
        [CalendarView shareInstance].delegate = self;
    }else
    {
        isSign = NO;
        [[CalendarView shareInstance] setUpCalendarView:isSign];
        [CalendarView shareInstance].delegate = self;
    }
}
#pragma nark---轮播图
-(void)didSelectedTopbannerViewCellIndex:(NSInteger)index
{
    
}
#pragma mark----获取轮播图
-(void)initDataWithBanner
{
    HomeViewModel *model = [[HomeViewModel alloc]init];
    typeof(self)weakSelf = self;
    [model handleDataWithVC:self URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetBannerListURL] parameters:[NSMutableDictionary dictionary] type:NetworkRequestTypeGet WithSuccess:^(NetworkResponse *response) {
       [weakSelf.bannersArray removeAllObjects];
        //存储banner数据
       [NSKeyedArchiver archiveRootObject:[HomeAppModel mj_objectArrayWithKeyValuesArray:response.data] toFile:LOCALBANNERPATH];
        
       [weakSelf.bannersArray addObjectsFromArray:[HomeAppModel mj_objectArrayWithKeyValuesArray:response.data]];
       [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败，请稍后再试!"];
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
                
                vc.submitArr  = dic[@"submit"];
                
                DLog(@"sumarr====%@",vc.submitArr);

                vc.utno = dic[@"utno"];
                vc.countdown = dic[@"countdown"];
                vc.url = dic[@"url"];
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }else
            {
                PublicAlertView *pub = [[PublicAlertView alloc]initWithTitle:nil message:responseObject[@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitle:@"我知道了" withMsFont:[UIFont systemFontOfSize:17] withTitleFont:nil];
                [pub show];
            }
        }
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
                self.appDelegate.dropAgain = NO;
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
                self.appDelegate.is_upload = [dic[@"is_upload"] intValue];
                self.appDelegate.submitArr = dic[@"submit"];
                self.appDelegate.reportDic = dic[@"app"];
                DLog(@"missionInfo----%@",dic);
                DLog(@"self.appDelegate.submitArr====%@",self.appDelegate.submitArr);
                self.appDelegate.missionID = dic[@"utno"];
                self.appDelegate.selectedUrl = dic[@"url"];
                [self.navigationController pushViewController:web animated:YES];
                
            }else if([responseObject[@"code"] intValue] ==60006)
            {
                NSDictionary *dic = responseObject[@"data"];
                self.appDelegate.timeOutString = dic[@"countdown"];
                self.appDelegate.is_upload = [dic[@"is_upload"] intValue];
                self.appDelegate.submitArr = dic[@"submit"];
            DLog(@"self.appDelegate.submitArr60006====%@",self.appDelegate.submitArr);
                self.appDelegate.reportDic = dic[@"app"];
                
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
//任务列表数据
-(void)initDataWithList:(NSString*)number WithMoney:(NSString*)money WithTime:(NSString*)time
{
    typeof(self)weakSelf = self;
    
    if (self.isBack ==YES) {
        [MBProgressHUD showIndicator];
    }
    
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
        [weakSelf.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}
//刷新失败嗲用
-(void)timeAction {
        //  停止刷新
        [_tableView.mj_header endRefreshing];

}
//获取签到天数
-(void)initSignData
{
    __weak typeof(self) weakSelf = self;
    
    [[[AFNetworkRequest alloc]init] requestWithVC:self URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetMonthSignInURL] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no", nil] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        if ([responseObject[@"code"] intValue] ==0) {
            NSDictionary *jsonArr = responseObject[@"data"];
            CalendarModel *model =[CalendarModel mj_objectWithKeyValues:jsonArr];

            NSArray *dayArr = [model.days componentsSeparatedByString:@","];
            
            if ([[dayArr lastObject] integerValue] ==[weakSelf day:[NSDate date]]) {
               [self.signBtn setTitle:@" 已签到" forState:UIControlStateNormal];
            }
            //存储任务类型数据
            [NSKeyedArchiver archiveRootObject:model toFile:CALENDARDATAPATH];
        }else
        {
            UserDefaultSetObjectForKey(@"1", GETSignFail);
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
#pragma mark--签到协议
-(void)signToday:(BOOL)isSign
{
    if (isSign ==YES) {
        [self.signBtn setTitle:@" 已签到" forState:UIControlStateNormal];
    }else
    {
       [self.signBtn setTitle:@" 未签到" forState:UIControlStateNormal];
    }
}
//判断今天
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MISSONDONENOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BACKFREFRESH object:nil];
    
}
@end
