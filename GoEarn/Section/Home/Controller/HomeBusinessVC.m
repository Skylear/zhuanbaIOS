//
//  HomeBusinessVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/10.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "HomeBusinessVC.h"
#import "FYHomeBusinessView.h"
#import "FYHomeAppHeadView.h"
#import "FYHomeAppCell.h"
@interface HomeBusinessVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView  * tableView;
@property(nonatomic,strong)UILabel  * footLabel;
@end

@implementation HomeBusinessVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];//隐藏 常态时是否隐藏 动画时是否显示
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家推广详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initTableview];
    [self creatFootView];
}
-(void)initTableview
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64 -45*SCREEN_POINT) style:UITableViewStyleGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = [self creatHeadView];
    [self.view addSubview:self.tableView];
}
-(UIView*)creatHeadView
{
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imgBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    [imgBtn setBackgroundImage:[UIImage imageNamed:@"2013011.jpg"] forState:UIControlStateNormal];
    [imgBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return imgBtn;
}
-(void)creatFootView
{
    self.footLabel = [UILabel labelWithTitle:@"领取任务" color:[UIColor whiteColor] font:Font(16)];
    self.footLabel.frame = CGRectMake(0,SCREEN_HEIGHT -64 -45*SCREEN_POINT, SCREEN_WIDTH, 45*SCREEN_POINT);
    self.footLabel.backgroundColor = UIColorFromRGB(0xff4c61);
    self.footLabel.userInteractionEnabled = YES;
    [self.footLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getMission:)]];
    [self.view addSubview:self.footLabel];
}
#pragma mark--tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYHomeAppCell cellWithTableView:self.tableView heightForRowAtIndexPath:indexPath model:[[HomeAppModel alloc]init] isBusiness:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYHomeAppCell *cell = [FYHomeAppCell cellWithTableView:self.tableView model:[[HomeAppModel alloc]init] WithIndexPath:indexPath isBusiness:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FYHomeAppHeadView *head = [FYHomeAppHeadView headViewWithTableView:self.tableView WithSection:section model:[[HomeAppModel alloc]init] isBusiness:YES];
    return head;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ==0?80:0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(void)imgBtnClick:(UIButton*)sender
{
    DLog(@"------------");
}
//领取任务
-(void)getMission:(UIGestureRecognizer*)gesture
{
    FYHomeBusinessView *home = [[FYHomeBusinessView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [KEYWINDOW addSubview:home];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
