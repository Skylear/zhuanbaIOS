//
//  WaitAuditVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/14.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "WaitAuditVC.h"
#import "WaitAuditTableViewCell.h"
#import "CheckListModel.h"


@interface WaitAuditVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray  * titleArray;
@property (nonatomic,strong) CheckListModel  * checkModel;
@end

@implementation WaitAuditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.checkModel = [[CheckListModel alloc] init];
    
    [self createUI];
    [self initWithWaitingRequest];
  
}

-(void)createUI{
    
    self.tableView.backgroundColor = MAINCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma UITableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;//设置尾视图高度为0.01
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    
    self.checkModel = self.titleArray[row];
    
    WaitAuditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WaitAuditTableViewCell"];
    if (cell == nil)
    {
        cell = [[WaitAuditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WaitAuditTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.avater sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.checkModel.img]] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    cell.titleLab.text =  self.checkModel.title;
    cell.moneyLab.text =  self.checkModel.money;
    cell.shenyuLab.text =[NSString stringWithFormat:@"剩余%@", self.checkModel.count];
    cell.auditLab.text = @"审核中";
    
    
    //    GRLog(@"-----%lu",_titleArray.count);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}

-(void)initWithWaitingRequest{
    NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:string forKey:@"session"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetCheckTaskListUrl] parameters:dic type:NetworkRequestTypeGet resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
            self.titleArray = [CheckListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"List"]];
            
            [self.tableView reloadData];
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
