//
//  SystemInformVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/9.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "SystemInformVC.h"
#import "SystemTableViewCell.h"
#import "NoticeDataBase.h"

@interface SystemInformVC ()

@end

@implementation SystemInformVC

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];

    UIImageView *placeIMG = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-134)/2, 80, 134, 160)];
    placeIMG.image = [UIImage imageNamed:@"no_news_img"];
    [self.view addSubview:placeIMG];
    
    // Do any additional setup after loading the view.
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
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 108;
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
    SystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemTableViewCell"];
    if (cell == nil)
    {
        cell = [[SystemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SystemTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kClearColor;
    cell.timeLab.text = @"2016年4月2日12：12";
    cell.titleLab.text = @"系统升级";
    cell.detailLab.text = @"赚吧APP 2.0版本在线升级";
    
    
    
    //    GRLog(@"-----%lu",_titleArray.count);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            
        }
    }
    
    
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
