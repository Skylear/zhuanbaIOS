//
//  SettingVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/23.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "SettingVC.h"
#import "JSWave.h"
#import "SettingTableViewCell.h"
#import "AssertsReportVC.h"
#import "PersonalDataVC.h"
#import "PersonalSetVC.h"
#import "DrawMoneyVC.h"
#import "VIPClubVC.h"
#import "WaitAuditVC.h"
#import "RecordListVC.h"
#import "InviteFriendVC.h"
#import "AboutLaojingVC.h"
#import "PublicAlertView.h"
#import "RecordEnlightVC.h"
#import "YXHAlertView.h"

@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource,PublicAlertViewDelegate>
@property (nonatomic, strong) NSMutableDictionary  * titleDic;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic,strong)  UIView *footerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic,strong) UITableView  *MT_tableView;
@property (nonatomic,strong) NSString  * agreeStr;
@end

@implementation SettingVC
{
    UIImageView *avaterIMG;
    UILabel *moneyLab;
    UILabel *EarnCheck;
    UILabel *totalEarn;
    UILabel *moneyOne;
    UILabel *moneyTwo;
}
-(NSMutableDictionary *)titleDic{
    
    if (!_titleDic) {
        _titleDic=[NSMutableDictionary dictionary];
    }
    return _titleDic;
}
//进入刷新
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self secrectGerUserInfomation];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.agreeStr = @"1";
    
    [self loaddata];
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification) name:@"AVATERIMAGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"SETTINGRELOAD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"NOTICERELOAD" object:nil];
}
-(void)notification{
    [self.view addSubview:self.MT_tableView];
    self.MT_tableView.tableHeaderView = [self headerView];
}

-(void)reload:(NSNotification *)notice{
    [self secrectGerUserInfomation];//数据刷新
    
}
//刷新数据
-(void)refreshReload{
    moneyLab.text = [NSString stringWithFormat:@"%@",[LWAccountTool account].today_money];
    EarnCheck.text = [NSString stringWithFormat:@"%@",[LWAccountTool account].check_money];
    totalEarn.text = [NSString stringWithFormat:@"%@",[LWAccountTool account].total_money];
    moneyOne.text = [NSString stringWithFormat:@"%ld/%ld",(long)[LWAccountTool account].score,(long)[LWAccountTool account].total_score];
    moneyTwo.text = [NSString stringWithFormat:@"%@",[LWAccountTool account].money];
}

//刷新数据
-(void)secrectGerUserInfomation
{
    //保存用户编码与表示修改密码备用
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:UserDefaultObjectForKey(@"LWASESSION") forKey:@"session"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetUserInfoData] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        if (responseObject[@"data"]) {
            DLog(@"-----0000%@",responseObject[@"nickname"]);
            // 存储用户信息
            LWAccount *account = [LWAccount mj_objectWithKeyValues:responseObject[@"data"]];
            [LWAccountTool saveAccount:account];
            [self refreshReload];//刷新数据
        }
    }];
}

-(void)loaddata{
    NSDictionary *dictionary;
    dictionary = @{@"0":@[@"个人信息",@"会员俱乐部"],@"3":@[@"我要收徒",@"收徒记录"],@"1":@[@"合作洽谈",@"联系客服"],@"2":@[@"设置"]};
    
    [self.titleDic addEntriesFromDictionary:dictionary];
    GRLog(@"----------%@",self.titleDic);
    
}

-(void)createUI{
    [self.view addSubview:self.MT_tableView];
    self.MT_tableView.tableHeaderView = [self headerView];
    
}

-(UITableView *)MT_tableView{
    if (!_MT_tableView) {
        _MT_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50) style:UITableViewStyleGrouped];
        _MT_tableView.backgroundColor =UIColorFromRGB(0xf2f5f7);
        _MT_tableView.dataSource = self;
        _MT_tableView.delegate   = self;
        _MT_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.MT_tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.MT_tableView.tableFooterView = self.footerView;
    }
    return _MT_tableView;
}

- (UIView *)headerView{
    
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 277)];
        //波浪
        JSWave *jswave = [[JSWave alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 152+65)];

        [_headerView addSubview:jswave];
        
        [_headerView addSubview: [self earnings]];

        [jswave startWaveAnimation];
        
        [_headerView addSubview:[self UsingView]];
        
        //头像
        UIView *avaterView = [[UIView alloc] initWithFrame:CGRectMake(12, 30, 36, 36)];
        avaterView.cornerRadius = avaterView.height/2;
        avaterView.backgroundColor = [UIColorFromRGB(0xffffff)colorWithAlphaComponent:0.3];
        [_headerView addSubview:avaterView];
        
        avaterIMG = [[UIImageView alloc] initWithFrame:CGRectMake(avaterView.left+3, avaterView.top+3, 30, 30)];
        NSData *imgdata = UserDefaultObjectForKey(@"AVATERIMAGE");
        UIImage *IMG = [UIImage imageWithData:imgdata];
        if (IMG) {
            avaterIMG.image = IMG;
        }else if ([LWAccountTool account].avatar) {
        [avaterIMG sd_setImageWithURL:[NSURL URLWithString:[LWAccountTool account].avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
         }else{
             avaterIMG.image = [UIImage imageNamed:@"avatar_default"];
         }
        avaterIMG.userInteractionEnabled = YES;
        avaterIMG.cornerRadius = avaterIMG.height/2;
        [_headerView addSubview:avaterIMG];
    
        UITapGestureRecognizer *avaterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avaterTap)];
        [avaterIMG addGestureRecognizer:avaterTap];
       //昵称
        UILabel *avaterLab = [[UILabel alloc] initWithFrame:CGRectMake(avaterIMG.right+10, avaterIMG.top+avaterIMG.height/2-15, 70, 15)];
        if (UserDefaultObjectForKey(@"NAMESTRING")) {
            avaterLab.text = UserDefaultObjectForKey(@"NAMESTRING");
        }else{
            avaterLab.text = [[LWAccountTool account].nickname isEmptyString]?@"昵称":[LWAccountTool account].nickname;
        }
        avaterLab.userInteractionEnabled = YES;
        avaterLab.textColor = [UIColor whiteColor];
        avaterLab.font = Font(14);
        [_headerView addSubview:avaterLab];
    
        UILabel *IDLab = [[UILabel alloc] initWithFrame:CGRectMake(avaterIMG.right+10, avaterLab.bottom+5, 70, 10)];
        IDLab.text = [LWAccountTool account].no?[NSString stringWithFormat:@"ID:%@",[LWAccountTool account].no]:@"ID:00000000";
        IDLab.textColor = [UIColor whiteColor];
        IDLab.userInteractionEnabled = YES;
        IDLab.font = Font(9);
        [_headerView addSubview:IDLab];
    
        UILabel *nickIDLAB = [[UILabel alloc] initWithFrame:CGRectMake(avaterIMG.right+10, avaterIMG.top+avaterIMG.height/2-15, 70, 30)];
        nickIDLAB.backgroundColor = [UIColor clearColor];
        nickIDLAB.userInteractionEnabled = YES;
        [_headerView addSubview:nickIDLAB];
    
        UITapGestureRecognizer *IDlabTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avaterTap)];
        [nickIDLAB addGestureRecognizer:IDlabTap];

    
        UILabel *earnList = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, avaterIMG.top+avaterIMG.height/2-10, 88, 25)];
        earnList.textAlignment = NSTextAlignmentRight;
        earnList.text = @"资产明细";
        earnList.textColor = [UIColor whiteColor];
        earnList.font = Font(13);
        earnList.userInteractionEnabled = YES;
        [_headerView addSubview:earnList];
        
        UITapGestureRecognizer *earnTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(earnTapClick)];
        [earnList addGestureRecognizer:earnTap];
        
        UILabel *TodayLab = [[UILabel alloc] initWithFrame:CGRectMake(0, avaterIMG.bottom+12, SCREEN_WIDTH, 15)];
        TodayLab.textColor = [UIColor whiteColor];
        TodayLab.text = @"今日收益(元)";
        TodayLab.font = Font(12);
        TodayLab.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:TodayLab];
       //今日收益
        moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, TodayLab.bottom+12, SCREEN_WIDTH, 50)];
        moneyLab.textAlignment = NSTextAlignmentCenter;
        moneyLab.text = [NSString stringWithFormat:@"%@",[LWAccountTool account].today_money];
        moneyLab.textColor = [UIColor whiteColor];
        moneyLab.font = Font(45);
        [_headerView addSubview:moneyLab];
   
    return _headerView;
}

//尾部视图
-(UIView *)footerView{
    if (_footerView) {
        return _footerView ;
    }
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    _footerView.backgroundColor = kClearColor;
    return _footerView;
}

//个人中心
-(void)avaterTap{
    PersonalDataVC *person = [[PersonalDataVC alloc] init];
    person.title = @"个人信息";
    [self.navigationController pushViewController:person animated:YES];
}
//资产收益
-(void)earnTapClick{
    AssertsReportVC *assert = [[AssertsReportVC alloc] init];
    assert.title = @"资产明细";
    [self.navigationController pushViewController:assert animated:YES];
    
}

//昨日收益
-(UIView *)earnings{
    UIView *earnings = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.bottom-135, SCREEN_WIDTH, 70)];
    earnings.backgroundColor = [UIColor clearColor];
    
    UILabel *lastLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH/2, 15)];
    lastLab.text = @"待审核(元)";
    lastLab.userInteractionEnabled = YES;
    lastLab.backgroundColor = [UIColor clearColor];
    lastLab.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    lastLab.font = Font(12);
    lastLab.textAlignment = NSTextAlignmentCenter;
    
    //待审核
    EarnCheck = [[UILabel alloc] initWithFrame:CGRectMake(0, lastLab.bottom+10, SCREEN_WIDTH/2, 15)];
    EarnCheck.userInteractionEnabled = YES;
    EarnCheck.text = [NSString stringWithFormat:@"%@",[LWAccountTool account].check_money];
    EarnCheck.textAlignment = NSTextAlignmentCenter;
    EarnCheck.font = Font(18);
    EarnCheck.textColor = [UIColor whiteColor];
    
    UILabel *totalLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,20, SCREEN_WIDTH/2, 15)];
    totalLab.text = @"累计收益(元)";
    totalLab.userInteractionEnabled = YES;
    totalLab.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.7];
    totalLab.font = Font(12);
    totalLab.textAlignment = NSTextAlignmentCenter;
    totalLab.backgroundColor = [UIColor clearColor];
    
//总收益
    totalEarn = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, totalLab.bottom+10, SCREEN_WIDTH/2, 15)];
    totalEarn.userInteractionEnabled = YES;
    totalEarn.text = [NSString stringWithFormat:@"%@",[LWAccountTool account].total_money];
    totalEarn.textAlignment = NSTextAlignmentCenter;
    totalEarn.font = Font(18);
    totalEarn.textColor = [UIColor whiteColor];
    
    [earnings addSubview:lastLab];
    [earnings addSubview:totalLab];
    [earnings addSubview:EarnCheck];
    [earnings addSubview:totalEarn];
    //待审核收益tap
    UIView *lastViewV = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH/2, 40)];
    lastViewV.userInteractionEnabled = YES;
    [earnings addSubview:lastViewV];
    
    UITapGestureRecognizer *EarnLabTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lastTap)];
    [lastViewV addGestureRecognizer:EarnLabTap];
    //总收益tap
    UIView *TotalView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2,20, SCREEN_WIDTH/2, 40)];
    TotalView.userInteractionEnabled = YES;
    [earnings addSubview:TotalView];
    
    UITapGestureRecognizer *totalEarnTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(totalTap)];
    [TotalView addGestureRecognizer:totalEarnTap];
    
    return earnings;
    
}
//待审核
-(void)lastTap{
    WaitAuditVC *audit = [[WaitAuditVC alloc] init];
    audit.title = @"待审核收益";
    [self.navigationController pushViewController:audit animated:YES];
    
}
//总收益
-(void)totalTap{
    AssertsReportVC *assert = [[AssertsReportVC alloc] init];
    assert.title = @"累计收益";
    [self.navigationController pushViewController:assert animated:YES];
}

//可使用
-(UIView *)UsingView{
    UIView *UsingView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.bottom-65, SCREEN_WIDTH, 65)];
    UsingView.backgroundColor = [UIColor whiteColor];
    
    UILabel *UseLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH/3, 15)];
    UseLab.text = @"可提现金额(元)";
    UseLab.font = Font(12);
    UseLab.userInteractionEnabled = YES;
    UseLab.textColor = UIColorFromRGB(0x8c8c8c);
    
    UIButton *withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom]
    ;
    withdrawBtn.frame = CGRectMake(SCREEN_WIDTH/2-50, UsingView.height/2-5, 40, 10);
    [withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    [withdrawBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    withdrawBtn.titleLabel.font = Font(13);
    [withdrawBtn addTarget:self action:@selector(withdrawClick) forControlEvents:UIControlEventTouchUpInside];
    [UsingView addSubview:withdrawBtn];
    
    UILabel *withdraw = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+15, 15, SCREEN_WIDTH/3, 15)];
    withdraw.text = @"积分/成长值";
    withdraw.font = Font(12);
    withdraw.userInteractionEnabled = YES;
    withdraw.textColor = UIColorFromRGB(0x8c8c8c);
    
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake(SCREEN_WIDTH-50,  UsingView.height/2-5, 40, 10);
    [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    [detailBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    detailBtn.titleLabel.font = Font(13);
    [detailBtn addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
    [UsingView addSubview:detailBtn];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 15, 0.5, UsingView.height-30)];
    line.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [UsingView addSubview:line];
    
    //积分、总积分
    moneyOne = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+15, UseLab.bottom+10, SCREEN_WIDTH/3, 15)];
    moneyOne.text = [NSString stringWithFormat:@"%ld/%ld",(long)[LWAccountTool account].score,(long)[LWAccountTool account].total_score];
    moneyOne.userInteractionEnabled = YES;
    moneyOne.font = [UIFont boldSystemFontOfSize:15];
    moneyOne.textColor = UIColorFromRGB(0xff4c61);
    
    moneyTwo = [[UILabel alloc] initWithFrame:CGRectMake(15, withdraw.bottom+10, SCREEN_WIDTH/3, 15)];
    moneyTwo.text = [NSString stringWithFormat:@"%@",[LWAccountTool account].money];
    moneyTwo.userInteractionEnabled = YES;
    moneyTwo.font = [UIFont boldSystemFontOfSize:15];
    moneyTwo.textColor = UIColorFromRGB(0xff4c61);
    
    [UsingView addSubview:UseLab];
    [UsingView addSubview:withdraw];
    [UsingView addSubview:moneyOne];
    [UsingView addSubview:moneyTwo];
    
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 65)];
    userView.userInteractionEnabled = YES;
    [UsingView addSubview:userView];
    
    UITapGestureRecognizer *userLabTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(withdrawClick)];
    [userView addGestureRecognizer:userLabTap];
    
    UIView *ScoreView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 65)];
    ScoreView.userInteractionEnabled = YES;
    [UsingView addSubview:ScoreView];
    
    UITapGestureRecognizer *ScroeLabTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailClick)];
    [ScoreView addGestureRecognizer:ScroeLabTap];
    
    return UsingView;
}
//提现
-(void)withdrawClick{
    if ([[LWAccountTool account].phone isEmptyString]||[[LWAccountTool account].openid isEmptyString]||[[LWAccountTool account].device_udid isEmptyString]) {
        PublicAlertView *pub = [[PublicAlertView alloc]initWithTitle:nil message:@"您的资料还未完善请绑定\n手机、微信，设备后提现" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:@"去绑定" withMsFont:[UIFont systemFontOfSize:17] withTitleFont:nil];
        [pub haveCashChoiseBtn];
        [pub show];
    }else{
        if ([[LWAccountTool account].agreement integerValue]==0) {
            //未同意用户协议
            YXHAlertView *alertV = [[YXHAlertView alloc] initWithTitle:@"用户协议" message:nil delegate:self cancelButtonTitle:@"拒绝" otherButtonTitle:@"同意" withMsFont:nil withTitleFont:Font(16)];
            [alertV show];
        }else{
            DrawMoneyVC *draw = [[DrawMoneyVC alloc] init];
            draw.title = @"提现";
            [self.navigationController pushViewController:draw animated:YES];
        }
}
}
//publicalertviewdelegate
- (void) PublicAlertView:(PublicAlertView*)alert buttonindex:(NSInteger)index{
    if (index ==1) {
        PersonalDataVC *person = [[PersonalDataVC alloc] init];
        person.title = @"个人资料";
        person.agreeStr = @"1";
        [self.navigationController pushViewController:person animated:YES];
    }
}

- (void)PublicAlertView:(PublicAlertView *)alert userSelecte:(BOOL)isSelected
{
    if (isSelected ==NO) {
        alert.isNotAgree = YES;
        
    }else
    {
        alert.isNotAgree = NO;
        
    }
}
#pragma mark----点击协议出现代理
- (void)PublicAlertView:(PublicAlertView *)alert String:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    DLog(@"+++回调++");
    AboutLaojingVC *about = [[AboutLaojingVC alloc] init];
    about.title = @"用户协议";
    [self.navigationController pushViewController:about animated:YES];
}
//详情
-(void)detailClick{
    VIPClubVC *Vip = [[VIPClubVC alloc] init];
    [self.navigationController pushViewController:Vip animated:YES];
    
}
-(UILabel*)labelWithFrame:(CGRect)frame text:(NSString*)textString textAlignment:(NSTextAlignment)textAlignment Font:(UIFont *)font textColor:(UIColor *)textColor{
    UILabel *baseLab = [[UILabel alloc]init];
    baseLab.frame = frame;
    baseLab.text = textString;
    baseLab.textAlignment = textAlignment;
    baseLab.font = font;
    baseLab.textColor = textColor;
    
    return baseLab;
}

#pragma UITableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleDic.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }else if (section==1){
        return 2;
    }else if(section==2){
        return 2;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;//设置尾视图高度为0.01
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
    if (cell == nil)
    {
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.PhoneLab.hidden = YES;
    if (section==0) {
        cell.titleLab.text = self.titleDic[@"0"][row];
        if (row==1) {
            cell.line.hidden = YES;
        }
    }else if (section==1){
        cell.titleLab.text = self.titleDic[@"3"][row];
        if (row==0) {
            
        }else{
        cell.line.hidden = YES;
        }
    }
    else if (section==2){
        cell.titleLab.text = self.titleDic[@"1"][row];
        if (row==1) {
            cell.PhoneLab.hidden = NO;
            cell.PhoneLab.text = UserDefaultObjectForKey(@"PHONETEL");
            cell.line.hidden = YES;
        }
    }else{
        cell.titleLab.text = self.titleDic[@"2"][0];
        cell.line.hidden = YES;
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    
    if (section==0) {
        if (row==0) {
            PersonalDataVC *person = [[PersonalDataVC alloc] init];
            person.title = @"个人中心";
            [self.navigationController pushViewController:person animated:YES];
            
        }else if (row==1) {
            VIPClubVC *Vip = [[VIPClubVC alloc] init];
            [self.navigationController pushViewController:Vip animated:YES];
        }
        
    }else if (section==1){
    
        if (row==0) {
            
            InviteFriendVC *invate = [InviteFriendVC new];
            invate.title = @"我要收徒";
            [self.navigationController pushViewController:invate animated:YES];
        }else{
            RecordEnlightVC *Record = [[RecordEnlightVC alloc] init];
            Record.title = @"收徒记录";
            [self.navigationController pushViewController:Record animated:YES];
        }
    }
    else if (section==2){
        if (row==0) {
            AboutLaojingVC *about = [[AboutLaojingVC alloc] init];
            about.title = @"合作洽谈";
            [self.navigationController pushViewController:about animated:YES];
        }else{
            if ([UserDefaultObjectForKey(@"PHONETEL") containsString:@"-"]) {
                UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:nil message:UserDefaultObjectForKey(@"PHONETEL") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel://%@",UserDefaultObjectForKey(@"PHONETEL")];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }];
                [alertcontroller addAction:action1];
                [alertcontroller addAction:action2];
                [self presentViewController:alertcontroller animated:YES completion:nil];
            }else{
                UIPasteboard *paste = [UIPasteboard generalPasteboard];
                paste.string = UserDefaultObjectForKey(@"PHONETEL");
                [MBProgressHUD showMessage:@"复制成功"];
            }
        }
    }

    else if (section==3){
        if (row==0) {
            PersonalSetVC *personal = [[PersonalSetVC alloc] init];
            personal.title = @"设置";
            [self.navigationController pushViewController:personal animated:YES];
        }
    }
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}



@end
