//
//  SecrectVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/23.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "SecrectVC.h"
#import "SecretTableViewCell.h"
//#import "LoginVC.h"

#import "NoticeInformVC.h"
#import "EditDataVC.h"

@interface SecrectVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL isSystemOpen;
@property (nonatomic,assign) BOOL isNoticeOpen;
@property (nonatomic,assign) NSInteger  oldNBadge;
@end

@implementation SecrectVC
//移除黑线
-(void)useMethodToFindBlackLineAndHind
{
    UIImageView* blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //隐藏黑线（在viewWillAppear时隐藏，在viewWillDisappear时显示）
    blackLineImageView.hidden = YES;
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   // [self useMethodToFindBlackLineAndHind];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UserDefaultSetObjectForKey(@"0", @"ISSYSTEMOPEN");
    UserDefaultSetObjectForKey(@"0", @"ISNOTICEOPEN");
    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YXHSYSTEM) name:@"YXHSYSTEM" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YXHNOTICE) name:@"YXHNOTICE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice) name:@"REMOVEREDDA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SystemVEREDDA) name:@"SystemVEREDDA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NOticeVEREDDA) name:@"NOticeVEREDDA" object:nil];
}
-(void)SystemVEREDDA{
    
    dispatch_async(dispatch_get_main_queue(), ^(){

        UserDefaultSetObjectForKey(@"1", @"ISSYSTEMOPEN");
        [self.tableView reloadData];
    });
}
-(void)NOticeVEREDDA{
    
    dispatch_async(dispatch_get_main_queue(), ^(){
    
        UserDefaultSetObjectForKey(@"1", @"ISNOTICEOPEN");
        [self.tableView reloadData];
    });
}
-(void)YXHSYSTEM{
     UserDefaultSetObjectForKey(@"0", @"ISSYSTEMOPEN");
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        [self.tableView reloadData];
    });
}
-(void)YXHNOTICE{
    UserDefaultSetObjectForKey(@"0", @"ISNOTICEOPEN");
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        [self.tableView reloadData];
    });
}
-(void)notice{
    UserDefaultSetObjectForKey(@"0", @"ISSYSTEMOPEN");
    UserDefaultSetObjectForKey(@"0", @"ISNOTICEOPEN");
    dispatch_async(dispatch_get_main_queue(), ^(){
      
         [self.tableView reloadData];
    });
 
}
-(void)createUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor =UIColorFromRGB(0xf2f5f7);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.scrollEnabled = YES;
}

#pragma UITableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;//设置尾视图高度为0.01
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"SecretTableViewCell";
    SecretTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    cell.userInteractionEnabled = YES;
    if (cell == nil)
    {
        cell = [[SecretTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.editing = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
        NSArray *arr= [[NoticeDataBase sharedNoticeDatabase] allHistory:NoticeTypeSystem];
        cell.titleLab.text = @"系统消息";
        cell.avaterIMG.image = [UIImage imageNamed:@"system_notice"];
        if (arr.count!=0) {
            NSDictionary *dic = [arr lastObject];
            cell.detailLab.text = arr.count==0?@"还没消息哦":dic[@"MESSAGE"];
            //未读系统消息记录
            NSString *oldsystembadge = UserDefaultObjectForKey(@"OLDSYSTEM");
            cell.bage.badgeValue = arr.count==0?@"0":[NSString stringWithFormat:@"%ld",(unsigned long)(arr.count-[oldsystembadge integerValue])];
            
        }else{
            cell.detailLab.text =@"还没消息哦";
            cell.bage.badgeValue = @"0";
        }
   }else{
        
        NSArray *arr= [[NoticeDataBase sharedNoticeDatabase] allHistory:NoticeTypeSend];
        NSDictionary *dic = [arr lastObject];
        cell.titleLab.text = @"通知消息";
        cell.avaterIMG.image = [UIImage imageNamed:@"message_notice"];
        if (arr.count!=0) {
        cell.detailLab.text = arr.count==0?@"还没消息哦":dic[@"MESSAGE"];
        //未读通知消息记录
        NSString *oldnoticebadge = UserDefaultObjectForKey(@"OLDNOTICE");
        cell.bage.badgeValue = arr.count==0?@"0":[NSString stringWithFormat:@"%ld",(unsigned long)(arr.count-[oldnoticebadge integerValue])];
            
        }else{
        cell.detailLab.text = @"还没消息哦";
        cell.bage.badgeValue = @"0";
        }
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SecretTableViewCell *systemCell = (SecretTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
     SecretTableViewCell *localCell = (SecretTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if (indexPath.section==0) {
        NoticeInformVC *system = [[NoticeInformVC alloc] init];
        system.title = @"系统通知";
        system.noticeType = NoticeSystemType;
        if ([localCell.bage.badgeValue intValue] ==0&&[systemCell.bage.badgeValue intValue] ==0) {
            system.isNotice = YES;
        }else if ([localCell.bage.badgeValue intValue] ==0&&[systemCell.bage.badgeValue intValue] !=0)
        {
          system.isNotice = YES;
        }else if ([localCell.bage.badgeValue intValue] !=0&&[systemCell.bage.badgeValue intValue] ==0)
        {
          system.isNotice = NO;
        }else
        {
           system.isNotice = NO;
        }
        [self.navigationController pushViewController:system animated:YES];
    }else{
        NoticeInformVC *notice = [[NoticeInformVC alloc] init];
        notice.title = @"消息通知";
        notice.noticeType = NoticeLocalType;
        if ([localCell.bage.badgeValue intValue] ==0&&[systemCell.bage.badgeValue intValue] ==0) {
            notice.isNotice = YES;
        }else if ([localCell.bage.badgeValue intValue] !=0&&[systemCell.bage.badgeValue intValue] ==0)
        {
            notice.isNotice = YES;
        }else if ([localCell.bage.badgeValue intValue] ==0&&[systemCell.bage.badgeValue intValue] !=0)
        {
            notice.isNotice = NO;
        }else
        {
            notice.isNotice = NO;
        }
        [self.navigationController pushViewController:notice animated:YES];
       
    }
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
