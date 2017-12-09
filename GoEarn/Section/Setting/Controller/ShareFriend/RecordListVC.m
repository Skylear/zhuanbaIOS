//
//  RecordListVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/26.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "RecordListVC.h"
#import "RecordTableViewCell.h"



@interface RecordListVC ()

@end


@implementation RecordListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请记录";
    [self createUI];
    
    
    
}
-(void)createUI{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor =UIColorFromRGB(0xf2f5f7);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma UITableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *secView = [UIView new];
    UILabel *secHeaderLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 30)];
    secHeaderLab.text = @"2016年10月24日";
    secHeaderLab.textColor = UIColorFromRGB(0x666666);
    secHeaderLab.font =Font(13);
    [secView addSubview:secHeaderLab];
    return secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;//设置尾视图高度为0.01
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"RecordTableViewCell";
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil)
    {
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
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
