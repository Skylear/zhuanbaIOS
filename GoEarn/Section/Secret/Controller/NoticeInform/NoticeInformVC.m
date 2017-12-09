//
//  NoticeInformVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/11/4.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "NoticeInformVC.h"
#import "NoticeTableViewCell.h"
#import "NoticeCell.h"
#import "NoticeDataBase.h"
#import "NoticeModel.h"
#import "JPUSHService.h"
#import "AboutLaojingVC.h"

@interface NoticeInformVC ()<UITableViewDataSource,UITableViewDelegate,PublicAlertViewDelegate,NoticeTableViewCellDelegate>
@property (nonatomic,assign) CGFloat  textHeight;
@property (nonatomic,strong) NSMutableArray  * Marr;
@property (nonatomic,strong) UITableView  * MT_tableView;
@end

@implementation NoticeInformVC
{
    NoticeDatabaseType type;//通知类型
    UIView *base;
    UIButton* ClearBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MAINCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.Marr = [NSMutableArray array];
    
    ClearBtn = [UIButton buttonWithTitle:@"清空" titleColor:UIColorFromRGB(0x808080) font:Font(16) target:self action:@selector(clearClick)];
    [ClearBtn setFrame:CGRectMake(0, 0, 70, 20)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ClearBtn];
    
    [self getBackNotice];
    [self createUI];
    [self placeIMG];
    if (self.Marr.count==0) {
        base.hidden = NO;
    }else{
        base.hidden =YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickNotice) name:@"YXHSYSTEM" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickNotice) name:@"YXHNOTICE" object:nil];
}
-(void)setIsNotice:(BOOL)isNotice{
    _isNotice = isNotice;
}
-(void)getBackNotice{
    
    if (self.noticeType ==NoticeSystemType) {
        type = NoticeTypeSystem;
        self.Marr= [[NoticeDataBase sharedNoticeDatabase] allHistory:NoticeTypeSystem];
        NSString *old = [NSString stringWithFormat:@"%ld",(long)self.Marr.count];
        UserDefaultSetObjectForKey(old, @"OLDSYSTEM");
        if (self.Marr.count>0) {
            ClearBtn.hidden = NO;
        }else{
            ClearBtn.hidden = YES;
        }
       [[NSNotificationCenter defaultCenter] postNotificationName:@"SystemVEREDDA" object:nil];
    }else{
        type = NoticeTypeSend;
        self.Marr= [[NoticeDataBase sharedNoticeDatabase] allHistory:NoticeTypeSend];
        NSString *old = [NSString stringWithFormat:@"%ld",(long)self.Marr.count];
        UserDefaultSetObjectForKey(old, @"OLDNOTICE");
        if (self.Marr.count>0) {
            ClearBtn.hidden = NO;
        }else{
            ClearBtn.hidden = YES;
        }
        
       [[NSNotificationCenter defaultCenter] postNotificationName:@"NOticeVEREDDA" object:nil];
    }
    if (_isNotice ==YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVEREDDA" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADREDDA" object:nil];
    }
    //逆向遍历排序
    NSEnumerator *enumerator = [self.Marr reverseObjectEnumerator];
    self.Marr = (NSMutableArray*)[enumerator allObjects];
}
//无数据展位图
-(void)placeIMG{
    base = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    base.backgroundColor = MAINCOLOR;
    [self.view addSubview:base];
    UIImageView *placeIMG = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-134)/2, 80, 134, 160)];
    placeIMG.image = [UIImage imageNamed:@"no_news_img"];
    [base addSubview:placeIMG];
}

-(void)clearClick{
    PublicAlertView *pub = [[PublicAlertView alloc]initWithTitle:nil message:@"确定清空消息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:@"确定" withMsFont:[UIFont systemFontOfSize:17] withTitleFont:nil];
    [pub show];
}
#pragma mark - PublicAlertViewDelegate
-(void)PublicAlertView:(PublicAlertView*)alert buttonindex:(NSInteger)index{
    if (index ==1) {
        if (type== NoticeTypeSystem) {
            [[NoticeDataBase sharedNoticeDatabase] removeAllHistory:NoticeTypeSystem];
            ClearBtn.hidden = YES;
        }else{
            [[NoticeDataBase sharedNoticeDatabase] removeAllHistory:NoticeTypeSend];
            ClearBtn.hidden = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getBackNotice];//后台通知数据
            base.hidden = NO;
            [self.MT_tableView reloadData];
        });
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVEREDDA" object:nil];
        [MBProgressHUD showSuccess:@"清除成功"];
    }
}

//通知刷新
-(void)clickNotice{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getBackNotice];//后台通知数据
        base.hidden = YES;
         [self.MT_tableView reloadData];
        
    });
    
}
-(void)createUI{
    _MT_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-68) style:UITableViewStylePlain];
    _MT_tableView.backgroundColor =MAINCOLOR;
    _MT_tableView.dataSource = self;
    _MT_tableView.delegate   = self;
    _MT_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.MT_tableView];
}
#pragma mark - noticetableviewcelldelegate
-(void)NoticeTableViewCell:(NoticeTableViewCell*)cell tapGestureRecogenize:(UIGestureRecognizer *)gesture{
    NSInteger inter = cell.tag ;
    NSString *urlStr = [NSString stringWithFormat:@"%@",self.Marr[inter][@"LINK"]];
    AboutLaojingVC *about = [[AboutLaojingVC alloc] init];
    about.title = @"消息详情";
    about.urlStr =urlStr;
    [self.navigationController pushViewController:about animated:YES];
}

#pragma UITableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.Marr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row     = indexPath.row;
   NSString *coverStr = [NSString stringWithFormat:@"%@",self.Marr[row][@"COVER"]];
    if (![coverStr isEmptyString]) {
    return 255;
    }

    return 45+self.textHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;//设置尾视图高度为0.01
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 存储历史记录title,@"TITLE",message,@"MESSAGE",cover,@"COVER",link,@"LINK",time,@"TIME",group,@"GROUP", nil];
    NSInteger row     = indexPath.row;
    static NSString *cellIdent      = @"NoticeTableViewCell";
    static NSString *cellIdentifier = @"NoticeCell";
    NSString *coverStr = [NSString stringWithFormat:@"%@",self.Marr[row][@"COVER"]];
    if (![coverStr isEmptyString]) {
        //存在图片
        NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];

        if (cell == nil)
        {
            cell = [[NoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        }
        cell.delegate = self;
        cell.tag = row;
        cell.titleLab.text = self.Marr[row][@"TITLE"];
        [cell.PictureIMG sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.Marr[row][@"COVER"]]] placeholderImage:[UIImage imageNamed:@"holder_cry"]];
        cell.detailLab.text = @"立即查看";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kClearColor;
        //时间戳转化时间
        NSString *timeStamp2 =self.Marr[row][@"TIME"];
        long long int date1 = (long long int)[timeStamp2 intValue];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [formatter stringFromDate:date2];
        cell.timeLab.text = dateString;
        
        NSString *textString =self.Marr[row][@"MESSAGE"];
        CGSize maxTextSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, CGFLOAT_MAX);
        CGSize textSize = [textString sizeWithFont:Font(17) maxSize:maxTextSize];
        CGFloat textViewH = textSize.height;
        cell.textH = textViewH;
        self.textHeight = textViewH;
        cell.detailLab.text = textString;
        return cell;
    }
        NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[NoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kClearColor;
        //时间戳转化时间
        NSString *timeStamp2 =self.Marr[row][@"TIME"];
        long long int date1 = (long long int)[timeStamp2 intValue];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [formatter stringFromDate:date2];
        cell.timeLab.text = dateString;
        
        NSString *textString =self.Marr[row][@"MESSAGE"];
        CGSize maxTextSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, CGFLOAT_MAX);
        CGSize textSize = [textString sizeWithFont:Font(17) maxSize:maxTextSize];
        CGFloat textViewH = textSize.height;
        cell.textH = textViewH;
        self.textHeight = textViewH;
        cell.detailLab.text = textString;
 

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
