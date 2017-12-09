//
//  PersonalSetVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/12.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "PersonalSetVC.h"
#import "FeedbackVC.h"
#import "AboutLaojingVC.h"

@interface PersonalSetVC ()
@property (nonatomic,strong) NSMutableDictionary  * titleDic;
@property (nonatomic,strong) NSString  * CacheString;
@end

@implementation PersonalSetVC
{
    UILabel *clearcacheLab;
}
-(NSMutableDictionary *)titleDic{
    if (!_titleDic) {
        _titleDic = [NSMutableDictionary dictionary];
    }
    return _titleDic;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //本地缓存
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       NSLog(@"files :%ld",(unsigned long)[files count]);
                       
                       self.CacheString = [NSString stringWithFormat:@"%ldM",(unsigned long)[files count]];
                       
                      
                   }
                   );


}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic =@{@"0":@"关于捞金",@"1":@[@"支持捞金",@"帮助中心",@"意见反馈",@"用户协议"],@"2":@"清除缓存"};
    [self.titleDic addEntriesFromDictionary:dic];
    
    [self createUI];
    GRLog(@"%@",self.titleDic);
  
    
}
-(void)createUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = MAINCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
}

#pragma UITableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
     if (section==1){
        return 4;
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
    static NSString *cellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 70,50)];
    titleLab.textColor = UIColorFromRGB(0x545454);
    titleLab.font = Font(15);
    UIImageView *mark = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-16.5, (50-11.5)/2, 6.5, 11.5)];
    mark.image = [UIImage imageNamed:@"arrows"];
    [cell.contentView addSubview:mark];
    
    if (indexPath.section==0){
        titleLab.text = self.titleDic[@"0"];
        UILabel *Lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 90, 50)];
        Lab.text = [NSString stringWithFormat:@"版本:V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        Lab.font = Font(14);
        Lab.textColor = UIColorFromRGB(0x808080);
        Lab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:Lab];
        mark.hidden = YES;
    }else if (indexPath.section==1){
        titleLab.text = self.titleDic[@"1"][indexPath.row];
    }
    else{
        
        titleLab.text = self.titleDic[@"2"];
        
        clearcacheLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70.5, 0, 50, 50)];
        clearcacheLab.textAlignment = NSTextAlignmentRight;
        clearcacheLab.textColor = UIColorFromRGB(0x545454);
        clearcacheLab.text = self.CacheString;
        clearcacheLab.font = Font(15);
        [cell.contentView addSubview:clearcacheLab];
    }
    [cell.contentView addSubview:titleLab];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xe1e6e6);
    [cell.contentView addSubview:line];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    if (section==0){
        AboutLaojingVC *about = [[AboutLaojingVC alloc] init];
        about.title = @"关于捞金";
        [self.navigationController pushViewController:about animated:YES];
    }else if (section==1){
        if (row==0) {
            AboutLaojingVC *about = [[AboutLaojingVC alloc] init];
            about.title = @"支持捞金";
            [self.navigationController pushViewController:about animated:YES];
        }else if (row==1){
            AboutLaojingVC *about = [[AboutLaojingVC alloc] init];
            about.title = @"帮助中心";
            [self.navigationController pushViewController:about animated:YES];
        }else if(row==2){
            FeedbackVC *feedback = [[FeedbackVC alloc] init];
            feedback.title = @"意见反馈";
            [self.navigationController pushViewController:feedback animated:YES];
        }else{
            AboutLaojingVC *about = [[AboutLaojingVC alloc] init];
            about.title = @"用户协议";
            [self.navigationController pushViewController:about animated:YES];
        }

    }
    
    else if (section==2){
        
        NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
        
        NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
        
        for ( NSString * p in files) {
            
            NSError * error = nil ;
            
            NSString * path = [cachPath stringByAppendingPathComponent :p];
            
            if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
                
                [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
                
            }
            
        }

        [self clearTmpPics];//清除缓存
        
    }
    
}

#pragma 清除缓存
- (void)clearTmpPics

{
    NSString*str=[NSString stringWithFormat:@"清理%@缓存",self.CacheString];
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction     *action  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction     *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];//可有可无
        //本地缓存
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        NSLog(@"files :%ld",(unsigned long)[files count]);
        self.CacheString = [NSString stringWithFormat:@"0M"];
        
        [self.tableView reloadData];
    }];
    [alertvc addAction:action];
    [alertvc addAction:action1];
    [self presentViewController:alertvc animated:YES completion:^{
        
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
