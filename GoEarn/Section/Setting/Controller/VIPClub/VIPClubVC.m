//
//  VIPClubVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/13.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "VIPClubVC.h"
#import "PersonTableViewCell.h"
#import "LXGradientProcessView.h"
#import "ScoreLevelModel.h"
#import "AboutLaojingVC.h"

#define avaterimg_w   58
@interface VIPClubVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView  * headerView;
@property (nonatomic,strong) UITableView  * WR_tableView;
@property (nonatomic, strong) LXGradientProcessView *processView;
@property (nonatomic,strong) UIButton  * selectedBtn;
@property (nonatomic) NSInteger  value;
@property (nonatomic,strong) ScoreLevelModel  * ScoreModel;
@property (nonatomic,strong) NSMutableArray  * ScoreArray;
@property (nonatomic,assign) CGFloat passScore;
@end

@implementation VIPClubVC
{
    UIImageView *avaterIMG;
    UIButton *classBtn;
    UILabel *spLab;
    UILabel *jiLab;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication].keyWindow removeFromSuperview];
}

-(UIView *)headerView{
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 315)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *baseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185)];
    baseView.image = [UIImage imageNamed:@"vipclub_bg"];
    [_headerView addSubview:baseView];
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-avaterimg_w)/2, 63, avaterimg_w, avaterimg_w)];
    borderView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    borderView.cornerRadius = avaterimg_w/2;
    [baseView addSubview:borderView];
   //头像
    avaterIMG = [[UIImageView alloc] initWithFrame:CGRectMake(borderView.left+3  , borderView.top+3, avaterimg_w-6, avaterimg_w-6)];
    NSData *imgdata = UserDefaultObjectForKey(@"AVATERIMAGE");
    UIImage *IMG = [UIImage imageWithData:imgdata];
    if (IMG) {
        avaterIMG.image = IMG;
    }else if ([LWAccountTool account].avatar) {
        [avaterIMG sd_setImageWithURL:[NSURL URLWithString:[LWAccountTool account].avatar] placeholderImage:[UIImage imageNamed:@"data_default"]];
    }
    avaterIMG.cornerRadius = avaterIMG.width/2;
    [_headerView addSubview:avaterIMG];
   
//昵称
    NSString *nameStr = [LWAccountTool account].nickname;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, avaterIMG.bottom+10, SCREEN_WIDTH, 15)];
   if(UserDefaultObjectForKey(@"NAMESTRING")){
        titleLab.text = UserDefaultObjectForKey(@"NAMESTRING");
    }else if (nameStr) {
        titleLab.text = nameStr;
    }
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont boldSystemFontOfSize:17];
    titleLab.textColor = [UIColor whiteColor];
    [baseView addSubview:titleLab];
    
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, titleLab.bottom+10, 0.5, 15)];
    upView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:upView];
    
    UILabel *ChengLab = [[UILabel alloc] initWithFrame:CGRectMake(upView.left-85, titleLab.bottom+10, 72, 15)];
    ChengLab.text = [NSString stringWithFormat:@"成长值:%ld",(long)[LWAccountTool account].total_score];
    ChengLab.textAlignment = NSTextAlignmentRight;
    ChengLab.textColor = [UIColor whiteColor];
    ChengLab.font = Font(12);
    [baseView addSubview:ChengLab];
    
    UILabel *JifenLab =[[UILabel alloc] initWithFrame:CGRectMake(upView.right+13, titleLab.bottom+10, 80, 15)];
    JifenLab.text = [NSString stringWithFormat:@"积分:%ld",(long)[LWAccountTool account].score];
    JifenLab.textColor = [UIColor whiteColor];
    JifenLab.font = Font(12);
    [baseView addSubview:JifenLab];
    
    jiLab = [[UILabel alloc] initWithFrame:CGRectMake(0, baseView.bottom+15, SCREEN_WIDTH, 15)];
    jiLab.textAlignment = NSTextAlignmentCenter;
    jiLab.textColor = UIColorFromRGB(0x999999);
    jiLab.font = Font(12);
    [_headerView addSubview:jiLab];
    
    // 渐变进度条
    self.processView = [[LXGradientProcessView alloc] initWithFrame:CGRectMake(15, jiLab.bottom+10, SCREEN_WIDTH-30,10)];
    [_headerView addSubview:self.processView];
    
    NSDictionary *dic = @{@"0":@[@"rank_one_get",@"rank_two_get",@"rank_three_get",@"rank_four_get",@"rank_five_get"],@"1":@[@"rank_one_not",@"rank_two_not",@"rank_three_not",@"rank_four_not",@"rank_five_not"],@"2":@[@"小兵",@"中尉",@"少校",@"将军",@"霸主"]};
    
    for (int i=0; i<5; i++) {
        classBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        classBtn.frame = CGRectMake(15+((SCREEN_WIDTH-50-classBtn.width*5)/4+classBtn.width)*i, _processView.bottom+10, 20, 30);

        [classBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"1"][i]]] forState:UIControlStateNormal];
        [classBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"0"][i]]] forState:UIControlStateSelected];

        [classBtn setImageEdgeInsets:UIEdgeInsetsMake(-15, 3, classBtn.titleLabel.height, 0)];
        [classBtn setTitle:dic[@"2"][i] forState:UIControlStateNormal];

        [classBtn setTitleEdgeInsets:UIEdgeInsetsMake(classBtn.imageView.height-5,-20 ,- classBtn.imageView.height, -5)];
        classBtn.titleLabel.font = Font(11);
    
        [classBtn setTitleColor:UIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [classBtn setTitleColor:UIColorFromRGB(0xff4c61) forState:UIControlStateSelected];
        [classBtn addTarget:self action:@selector(classClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:classBtn];
    }
    
    spLab = [[UILabel alloc] initWithFrame:CGRectMake(15,classBtn.bottom+15, SCREEN_WIDTH*2/3, 10)];
    
    [_headerView addSubview:spLab];
    
    return _headerView;
}
-(void)classClick:(UIButton*)sender{
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    
    
    _selectedBtn = sender;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self initWithScorelevelRequest];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.WR_tableView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 30, 15, 27);
    [backBtn setImage:[UIImage imageNamed:@"return_btn_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    
//    if (!UserDefaultObjectForKey(@"firstLogin")||[UserDefaultObjectForKey(FIRST_LODING_FAIL) intValue] ==1) {
//        UserDefaultSetObjectForKey(@"1", @"firstLogin")
//        [self initDataWithBanner];
//    }else
//    {
//        NSArray *bannerData = [NSKeyedUnarchiver unarchiveObjectWithFile:LOCALBANNERPATH];
//        // banner图
//        [UserDefaultObjectForKey(BANNERUPDATE) boolValue] ==YES?[self initDataWithBanner]:[self.bannersArray addObjectsFromArray:bannerData];
//        
//    }
    
}

-(void)totalScore{
    ScoreLevelModel *scroModel;
    NSInteger  score ;
    CGFloat    paScore;
    NSString *str;
    NSString *lenStr;
    NSMutableArray  *scroArr = [NSMutableArray array];
    for (int i=0; i<self.ScoreArray.count; i++) {
         scroModel = self.ScoreArray[i];
        [scroArr addObject:scroModel.score];
    }
    
    score = [LWAccountTool account].total_score;
    if (score>0&&score<20) {
        score = 20;
    }
    
    NSInteger  SCORE0 = [scroArr[0] integerValue];
    NSInteger  SCORE1 = [scroArr[1] integerValue];
    NSInteger  SCORE2 = [scroArr[2] integerValue];
    NSInteger  SCORE3 = [scroArr[3] integerValue];
    NSInteger  SCORE4 = [scroArr[4] integerValue];
    if (score>SCORE0&&score<=SCORE1) {
        paScore = 0.26*120*score/SCORE1;
        lenStr = [NSString stringWithFormat:@"%d",(int)(SCORE1-[LWAccountTool account].total_score)];
        str = [NSString stringWithFormat:@"距离下一等级还需%@成长值",lenStr];
        jiLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)[LWAccountTool account].total_score,(long)SCORE1];
    }else if (score>SCORE1&&score<=SCORE2){
        paScore=0.28*120*(score-SCORE1)/SCORE2+30;
        lenStr = [NSString stringWithFormat:@"%d",(int)(SCORE2-[LWAccountTool account].total_score)];
        str = [NSString stringWithFormat:@"距离下一等级还需%@成长值",lenStr];
        jiLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)[LWAccountTool account].total_score,(long)SCORE2];
    }else if (score>SCORE2&&score<=SCORE3){
        paScore=0.35*120*(score-SCORE2)/SCORE3+53;
        
        lenStr = [NSString stringWithFormat:@"%d",(int)(SCORE3-[LWAccountTool account].total_score)];
        str = [NSString stringWithFormat:@"距离下一等级还需%@成长值",lenStr];
        jiLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)[LWAccountTool account].total_score,(long)SCORE3];
    }else if (score>SCORE3&&score<=SCORE4){
        paScore=0.35*120*(score-SCORE3)/SCORE4+83;
        
        lenStr = [NSString stringWithFormat:@"%d",(int)(SCORE4-[LWAccountTool account].total_score)];
        str = [NSString stringWithFormat:@"距离下一等级还需%@成长值",lenStr];
        jiLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)[LWAccountTool account].total_score,(long)SCORE4];
    }
    self.processView.percent =paScore;//0-120
    
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x444444),NSFontAttributeName:Font(12)}];
    [mutableStr addAttribute:NSFontAttributeName value:Font(16) range:NSMakeRange(8, lenStr.length)];
    [mutableStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xff4c61) range:NSMakeRange(8,lenStr.length)];
    spLab.attributedText = mutableStr;
}

-(UITableView *)WR_tableView{
    if (!_WR_tableView) {
        _WR_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _WR_tableView.backgroundColor = MAINCOLOR;
        _WR_tableView.dataSource = self;
        _WR_tableView.delegate   = self;
        _WR_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _WR_tableView.tableHeaderView = self.headerView;
      
    }
    
    return _WR_tableView;
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
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
    NSArray *array = @[@"会员权限说明"];
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonTableViewCell"];
    if (cell == nil)
    {
        cell = [[PersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLab.text = array[row];
    cell.titleLab.font = Font(15);
    cell.titleLab.textColor = UIColorFromRGB(0x545454);
//    if (row==0) {
//        cell.showLab.text = @"点击购买";
//        cell.showLab.textColor = UIColorFromRGB(0xff4c61);
//        cell.showLab.font = Font(14);
//    }else
        if (row==0){
        cell.lineView.hidden = YES;
        }
    if (self.ScoreArray.count>0) {
        [self totalScore];
        }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger  section = indexPath.section;
    NSInteger  row     = indexPath.row;
    if (row==0) {
        AboutLaojingVC *about = [[AboutLaojingVC alloc] init];
        about.title = @"会员权限说明";
        [self.navigationController pushViewController:about animated:YES];
    }
    
}

-(void)initWithScorelevelRequest{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetScoreLevelURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
           self.ScoreArray  = [ScoreLevelModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            [self.WR_tableView reloadData];
        }else
        {
            [MBProgressHUD showMessage:responseObject[@"msg"]];
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
