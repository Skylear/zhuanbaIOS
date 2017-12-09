//
//  HomeCommiteVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/20.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "HomeCommiteVC.h"
#import "FYHomeMissonCell.h"
#import "TimeLabel.h"
#import "AppDelegate.h"
#import "FYHomeProjectCell.h"
#import "HomeSortVC.h"
#import "HomeVC.h"
#import "UIDevice-Hardware.h"
#import "LocalNotificationTool.h"
#import "CommiteModel.h"
#define collectionH ([UIScreen mainScreen].bounds.size.width -30- 10)/3
@interface HomeCommiteVC ()<UITableViewDataSource,UITableViewDelegate,FYHomeProjectDelegate,FYHomeMissonDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray  * commiteFuckArr;
@property(nonatomic,strong)AppDelegate * appDelegate;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)UIView  * footView;
@end

@implementation HomeCommiteVC

- (NSMutableArray*)commiteFuckArr
{
    if (!_commiteFuckArr) {
        _commiteFuckArr = [NSMutableArray array];
    }
    return _commiteFuckArr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];//隐藏 常态时是否隐藏 动画时是否显示
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交任务";
    self.appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (self.isAgent ==YES) {
        [self.commiteFuckArr addObjectsFromArray:[CommiteModel mj_objectArrayWithKeyValuesArray:self.submitArr]];
    }else
    {
        [self.commiteFuckArr addObjectsFromArray:[CommiteModel mj_objectArrayWithKeyValuesArray:self.appDelegate.submitArr]];
    }
    DLog(@"-----------%@",self.commiteFuckArr);
    [self initTableview];
}
#pragma mark - 初始化表格
-(void)initTableview
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80*SCREEN_POINT)];
    TimeLabel  * footLabel = [[TimeLabel alloc]initWithFrame:CGRectMake(10,17.5*SCREEN_POINT, SCREEN_WIDTH -20, 45*SCREEN_POINT) withAlign:NSTextAlignmentCenter fromList:NO];
    if (self.appDelegate.selectedListModel.countdown&&self.isAgent ==NO) {
        NSDictionary *dateDic = [NSString dictionaryWithDateString:self.appDelegate.timeOutString];
        footLabel.second = [dateDic[@"sec"] intValue];
        footLabel.hour = [dateDic[@"hou"] intValue];
        footLabel.minute = [dateDic[@"min"] intValue];
        footLabel.timeString = @"提交任务";
        footLabel.timerBegain = YES;
        _footView.userInteractionEnabled = YES;
        [_footView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commiteMission:)]];
    }else if (self.isAgent ==YES)
    {
        NSDictionary *dateDic = [NSString dictionaryWithDateString:self.countdown];
        footLabel.second = [dateDic[@"sec"] intValue];
        footLabel.hour = [dateDic[@"hou"] intValue];
        footLabel.minute = [dateDic[@"min"] intValue];
        footLabel.timeString = @"提交任务";
        footLabel.timerBegain = YES;
        _footView.userInteractionEnabled = YES;
        [_footView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commiteAgentMission:)]];
    }
    footLabel.layer.cornerRadius = 5*SCREEN_POINT;
    footLabel.clipsToBounds = YES;
    footLabel.textColor =[UIColor whiteColor];
    footLabel.backgroundColor = UIColorFromRGB(0xff4c61);
    [_footView addSubview:footLabel];
    
    self.tableView.tableFooterView = self.footView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(-34, 0, 64, 0);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    
}
#pragma mark - UITablviewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isAgent ==YES) {
        return self.submitArr.count;
    }else
    {
        return self.appDelegate.submitArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommiteModel *model = self.commiteFuckArr[indexPath.section];
    if ([model.type isEqualToString:@"img"]) {
        return MAX((SCREEN_WIDTH -40)/3 +15, model.rowHeigh);
    }else
    {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     CommiteModel *model = self.commiteFuckArr[section];
    if ([model.type isEqualToString:@"img"]) {
        
        return 50;
    }else
    {
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommiteModel *model = self.commiteFuckArr[section];
    if ([model.type isEqualToString:@"img"]) {
        UITableViewHeaderFooterView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"section2"];
        if (!head)
        {
            head = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"section2"];
            
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
            bgView.tag = 1;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH -20, 40)];
            label.tag = 2;
            [bgView addSubview:label];
            [head addSubview:bgView];
        }
        UIView *bgView = (UIView*)[head viewWithTag:1];
        bgView.backgroundColor = [UIColor whiteColor];
        UILabel *label = (UILabel *)[head viewWithTag:2];
        label.font = Font(15);
        label.text = model.name;
        label.textColor = UIColorFromRGB(0x666666);
        
        return head;
    }else
    {
        UITableViewHeaderFooterView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"section1"];
        if (!head)
        {
            head = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"section1"];
        }
        return head;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommiteModel *model = self.commiteFuckArr[indexPath.section];
    if ([model.type isEqualToString:@"img"]) {
        FYHomeProjectCell *cell = [tableView expandableTextCell:indexPath];
        //FYHomeProjectCell *cell = [FYHomeProjectCell cellWithTableView:self.tableView WithIndenxpath:indexPath];
        cell.delegate = self;
        return cell;
    }else
    {
        FYHomeMissonTFCell *cell = [FYHomeMissonTFCell cellWithTableView:self.tableView WithIndenxpath:indexPath];
        cell.TF.placeholder = model.name;
        cell.TF.delegate = self;
        return cell;
  
    }
}

-(void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath imageArr:(NSMutableArray *)imgArr
{
    CommiteModel *model = self.commiteFuckArr[indexPath.section];
    
    model.rowHeigh = height;
    DLog(@"projectHeigh===%f %ld",model.rowHeigh,(long)indexPath.section);
   
    model.imgArr =imgArr;
    //[self.tableView reloadData];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    FYHomeMissonTFCell *cell = (FYHomeMissonTFCell*)textField.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CommiteModel *model = self.commiteFuckArr[indexPath.section];
    model.textString = textField.text;
}
//增加图片的代理方法
-(void)missonCellAddRow:(FYHomeMissonCell *)cell withSource:(NSMutableArray*)sourceArr  withRow:(int)row section:(NSInteger)section
{
    int _Row = row>=3 ?3:row;
    
    CommiteModel *model = self.commiteFuckArr[section];
    
    model.rowHeigh = (collectionH+5)*_Row+10;
    DLog(@"projectHeigh===%f %d",model.rowHeigh,row);
    [model.imgArr removeAllObjects];
    model.imgArr =sourceArr;
    [self.tableView reloadData];
}
-(void)missonCellDeleteRow:(FYHomeProjectCell *)cell withSource:(NSMutableArray *)sourceArr withRow:(int)row  section:(NSInteger)section
{
    CommiteModel *model = self.commiteFuckArr[section];
    
    model.rowHeigh = (collectionH+5)*row+10;
    DLog(@"projectHeigh===%f %d",model.rowHeigh,row);
    [model.imgArr removeAllObjects];
    model.imgArr =sourceArr;
    [self.tableView reloadData];
}
//非正常任务
-(void)commiteAgentMission:(UIGestureRecognizer*)gest
{
    for (CommiteModel *model in self.commiteFuckArr) {
        if ([model.type isEqualToString:@"img"]) {
            if (model.imgArr.count ==0) {
                [MBProgressHUD showError:@"请上传图片"];
                return;
            }
        }else
        {
            DLog(@"输入文字-----%@",model.textString);
            if ([model.textString isEqualToString:@""]||!model.textString) {
                [MBProgressHUD showError:@"请输入文字信息"];
                return;
            }
        }
    }
    
    [MBProgressHUD showIndicator];
    
    NSMutableDictionary *dataDic =[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",self.utno,@"utno", nil];

    NSMutableArray *realImgArr = [NSMutableArray array];
    NSMutableArray *textArr = [NSMutableArray array];
    for (CommiteModel *model in self.commiteFuckArr) {
        if ([model.type isEqualToString:@"img"]) {
            NSMutableArray *nowArr = [[NSMutableArray alloc]initWithCapacity:0];
            for (UIImage *searchImg in model.imgArr) {
                
               UIImage *lastImg = [searchImg imagetargetWidth:720];
                
                NSData * dataObj =  UIImageJPEGRepresentation(lastImg, 0.2);
                NSString * imageType = [UIImage typeForImageData:dataObj];
                
                NSString * encodedImageStr = [dataObj base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                NSString * searchString = [NSString stringWithFormat:@"data:%@;base64,%@",imageType ,encodedImageStr];
                
                [nowArr addObject:searchString];
            }
            [realImgArr addObject:nowArr];
        }else
        {
            [textArr addObject:model.textString];
        }
        
    }
    
    NSDictionary *partDic = [NSDictionary dictionaryWithObjectsAndKeys:realImgArr,@"img",textArr,@"string",nil];
    
    NSString *jsonString = [NSString toJSONData:partDic];
    
    
    [dataDic setObject:jsonString forKey:@"check_content"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,CommiteAGENTMISSION] parameters:dataDic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [MBProgressHUD showError:@"请求失败，请稍后再试!"];
        }else
        {
            if ([responseObject[@"code"] intValue] ==0) {
                
                NSArray *temArray = self.navigationController.viewControllers;
                for(UIViewController *temVC in temArray)
                {
                    if ([temVC isKindOfClass:[HomeSortVC class]]||[temVC isKindOfClass:[HomeVC class]])
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:BACKFREFRESH object:nil];
                        [self.navigationController popToViewController:temVC animated:YES];
                        [MBProgressHUD showMessage:@"提交成功"];
                    }
                }
            }else
            {
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
            
        }
    }];
}

// 正常任务
-(void)commiteMission:(UIGestureRecognizer*)gest
{
    [MBProgressHUD showIndicator];
    
    NSMutableDictionary *dataDic =[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",self.appDelegate.missionID,@"utno", nil];
    
    NSMutableArray *realImgArr = [NSMutableArray array];
    NSMutableArray *textArr = [NSMutableArray array];
    for (CommiteModel *model in self.commiteFuckArr) {
        if ([model.type isEqualToString:@"img"]) {
            NSMutableArray *nowArr = [NSMutableArray array];
            for (UIImage *searchImg in model.imgArr) {
                UIImage *lastImg = [searchImg imagetargetWidth:720];
                NSData *dataObj =  UIImageJPEGRepresentation(lastImg, 0.2);
                NSString*str=[UIImage typeForImageData:dataObj];
                NSString *_encodedImageStr = [dataObj base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                NSString*searchString=[NSString stringWithFormat:@"data:%@;base64,%@",str,_encodedImageStr];
                [nowArr addObject:searchString];
            }
            [realImgArr addObject:nowArr];
        }else
        {
            [textArr addObject:model.textString];
        }
        
    }
    
    NSDictionary *partDic = [NSDictionary dictionaryWithObjectsAndKeys:realImgArr,@"img",textArr,@"string",nil];
    
    NSString *jsonString = [NSString toJSONData:partDic];
    [dataDic setObject:jsonString forKey:@"check_content"];
    
    NSMutableDictionary *deviceDic = [[UIDevice currentDevice] phoneMessageDictionary];
    NSString *deviceString = [NSString toJSONData:deviceDic];
    
    [dataDic setObject:deviceString forKey:@"device_info"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,CommiteMission] parameters:dataDic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [MBProgressHUD showError:@"请求失败，请稍后再试!"];
        }else
        {
            if ([responseObject[@"code"] intValue] ==0) {
                UserDefaultSetObjectForKey(@"0", SEARCHMORE)
                UserDefaultSetObjectForKey(@"0", OPENMORE)
                UserDefaultSetObjectForKey(@"0", UPDATEMORE)
                NSArray *temArray = self.navigationController.viewControllers;
                for(UIViewController *temVC in temArray)
                {
                    if ([temVC isKindOfClass:[HomeSortVC class]]||[temVC isKindOfClass:[HomeVC class]])
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:BACKFREFRESH object:nil];
                        self.appDelegate.selectedListModel = nil;
                        [self.navigationController popToViewController:temVC animated:YES];
                        [MBProgressHUD showMessage:@"提交成功"];
                        [LocalNotificationTool registerLocalNotification:0 message:@"恭喜你完成此项任务！"];
                    }
                }
            }else
            {
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
            
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
