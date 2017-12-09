//
//  HomeAppVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/10.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "HomeAppVC.h"
#import "HomeAppModel.h"
#import "FYHomeAppCell.h"
#import "FYHomeAppHeadView.h"
#import "TimeLabel.h"
@interface HomeAppVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView  * tableView;
@property(nonatomic,strong)TimeLabel  * footLabel;

@end

@implementation HomeAppVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启定时器
    
    //[self.footLabel.timer setFireDate:[NSDate distantPast]]; //很远的过去
    [self.navigationController setNavigationBarHidden:NO animated:YES];//隐藏 常态时是否隐藏 动画时是否显示
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    // [self.footLabel.timer setFireDate:[NSDate distantFuture]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.cellType ==2?@"APP下载详情":@"特工任务";
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
    [self.view addSubview:self.tableView];
}
-(void)creatFootView
{
    self.footLabel = [[TimeLabel alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT -64 -45*SCREEN_POINT, SCREEN_WIDTH, 45*SCREEN_POINT)];
    self.footLabel.textColor =[UIColor whiteColor];
    self.footLabel.backgroundColor = UIColorFromRGB(0xff4c61);
    self.footLabel.hour = 0;
    self.footLabel.minute =30;
    self.footLabel.second = 00;
    [self.view addSubview:self.footLabel];
}
#pragma mark----tableViewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ==2?4:1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ==0?80:45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYHomeAppCell cellWithTableView:self.tableView heightForRowAtIndexPath:indexPath model:[[HomeAppModel alloc]init] isBusiness:NO];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYHomeAppCell *cell = [FYHomeAppCell cellWithTableView:self.tableView model:[[HomeAppModel alloc]init] WithIndexPath:indexPath isBusiness:NO];
    if (self.cellType ==2) {
        cell.imgView.image = [UIImage imageNamed:@"download_link"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FYHomeAppHeadView *head = [FYHomeAppHeadView headViewWithTableView:self.tableView WithSection:section model:[[HomeAppModel alloc]init] isBusiness:NO];
    return head;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
