
//
//  PersonalDataVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/9.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "PersonalDataVC.h"
#import "PersonTableViewCell.h"
#import "LPActionSheet.h"
#import "UserNameVC.h"
#import "LTPickerView/LTPickerView.h"
#import "PickerView.h"
#import "ConpendVC.h"
#import <AdSupport/AdSupport.h>
#import "BindingWeChatVC.h"
#import "ChooseSexVC.h"
#import "ProTool.h"
#define avaterimg_w  80

@interface PersonalDataVC ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) NSMutableDictionary  * titleDic;
@property (nonatomic,strong) NSString  * nameStr;
@property (nonatomic,strong) NSString  * LocationStr;
@property (nonatomic,strong) NSString  * SexString;
@property (nonatomic,strong) UIView    * headerView;//头部视图
@property (nonatomic,strong) NSString  * pictureDataString;
@property (nonatomic,assign) BOOL  isbing;//是否绑定
@property (nonatomic,strong) UITableView  * MT_tableView;

@end

@implementation PersonalDataVC
{
    UIImageView *avaterIMG;
}
-(NSMutableDictionary *)titleDic{
    if (!_titleDic) {
        _titleDic = [NSMutableDictionary dictionary];
    }
    return _titleDic;
}

-(UIView *)headerView{
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    avaterIMG = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-avaterimg_w)/2, 15, avaterimg_w, avaterimg_w)];
    
    NSData *imgdata = UserDefaultObjectForKey(@"AVATERIMAGE");
    UIImage *IMG = [UIImage imageWithData:imgdata];
    if (IMG) {
        avaterIMG.image = IMG;
    }else if ([LWAccountTool account].avatar) {
        [avaterIMG sd_setImageWithURL:[NSURL URLWithString:[LWAccountTool account].avatar] placeholderImage:[UIImage imageNamed:@"data_default"]];
    }else {
        avaterIMG.image = [UIImage imageNamed:@"data_default"];
    }
    avaterIMG.cornerRadius = avaterimg_w/2;
    avaterIMG.userInteractionEnabled = YES;
    [_headerView addSubview:avaterIMG];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picbtnClick)];
    [avaterIMG addGestureRecognizer:tap];
    
    UIButton *PicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    PicBtn.frame = CGRectMake(avaterIMG.right-24, avaterIMG.bottom-24, 24, 24);
    PicBtn.layer.cornerRadius = PicBtn.height/2;
    [PicBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    [PicBtn addTarget:self action:@selector(picbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:PicBtn];
    
    return _headerView;
}
-(void)picbtnClick{
    [LPActionSheet showActionSheetWithTitle:@"选择图片来源" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"相机"] isShow:YES handler:^(LPActionSheet *actionSheet, NSInteger index) {
        
        if (index==1) {
            [self PhotoAlbum];
        }else if(index==2){
            [self PhotoPicture];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = MAINCOLOR;
    self.isbing = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSDictionary *dic = @{@"0":@[@"昵称",@"性别",@"生日",@"所属行业",@"所属城市"],@"1":@[@"绑定手机",@"绑定微信",@"绑定设备"]};
    [self.titleDic addEntriesFromDictionary:dic];
    
    
    [self createUI];
    //用户协议
    if (self.agreeStr.length>0) {
        [self GetUserProtocalUpdate];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotice) name:@"FRESHCENTERDATE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"NOTICERELOAD" object:nil];
    
}
-(void)getNotice{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.MT_tableView reloadData];
    });
}

-(void)reload:(NSNotification *)notice{
    [self secrectGerUserInfomation];//数据刷新
}

//刷新数据
-(void)secrectGerUserInfomation
{
    //保存用户编码与表示修改密码备用
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:UserDefaultObjectForKey(@"LWASESSION") forKey:@"session"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetUserInfoData] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        if (responseObject[@"data"]) {
            DLog(@"-----0000%@",responseObject[@"nickname"]);
            // 存储用户信息
            LWAccount *account = [LWAccount mj_objectWithKeyValues:responseObject[@"data"]];
            [LWAccountTool saveAccount:account];
            
            [self.MT_tableView reloadData];
        }
    }];
}



-(void)createUI{
    _MT_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _MT_tableView.backgroundColor = MAINCOLOR;
    _MT_tableView.dataSource = self;
    _MT_tableView.delegate = self;
    _MT_tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _MT_tableView.tableHeaderView =self.headerView;
    [self.view addSubview:self.MT_tableView];
}
#pragma UITableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 5;
    }
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;//设置尾视图高度为0.01
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonTableViewCell"];
    if (cell == nil)
    {
        cell = [[PersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DLog(@"--------%@",[LWAccountTool account].sex);
    if (section==0) {
        cell.titleLab.text = self.titleDic[@"0"][row];
        if (row==0) {
            if (self.nameStr) {
                cell.showLab.text = self.nameStr;
            }else{
            cell.showLab.text = [[LWAccountTool account].nickname isEmptyString]?@"昵称":[LWAccountTool account].nickname;
            }
        }else if (row==1){
            cell.showLab.text = [[LWAccountTool account].sex isEmptyString]?@"未选择":[LWAccountTool account].sex;
           
            if (![[LWAccountTool account].sex isEmptyString]) {
                cell.userInteractionEnabled = NO;
                cell.mark.hidden = YES;
            }
        }else if (row==2){

            cell.showLab.text = [[LWAccountTool account].birthday isEmptyString]?@"未选择":[LWAccountTool account].birthday;
           
            if (![[LWAccountTool account].birthday isEmptyString]) {
                cell.userInteractionEnabled = NO;
                cell.mark.hidden = YES;
            }
        }else if (row==3){
            cell.showLab.text = [[LWAccountTool account].industry isEmptyString]?@"未选择":[LWAccountTool account].industry;

            if (![[LWAccountTool account].industry isEmptyString]) {
                cell.userInteractionEnabled = NO;
                cell.mark.hidden = YES;
            }
        }
        else if (row==4){
            //地区选择

                CGSize maxTextSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - cell.titleLab.width-26, CGFLOAT_MAX);
                CGSize textSize = [[LWAccountTool account].city sizeWithFont:Font(17) maxSize:maxTextSize];
                CGFloat textViewW = textSize.width;
                CGFloat textViewH = textSize.height;
                cell.showLab.frame = CGRectMake(SCREEN_WIDTH-textViewW-25, (45-textViewH)/2, textViewW, textViewH);
                cell.showLab.text = [[LWAccountTool account].city isEmptyString]?@"未选择":[LWAccountTool account].city;

            if (![[LWAccountTool account].city isEmptyString]) {
                cell.userInteractionEnabled = NO;
                cell.mark.hidden = YES;
            }
            
            cell.lineView.hidden = YES;
        }
        
    }else if (section==1){
        cell.titleLab.text = self.titleDic[@"1"][row];
        
        cell.showLab.textColor = UIColorFromRGB(0xff4c61);
        if (row==0) {
            cell.showLab.text = [[LWAccountTool account].phone isEmptyString]?@"未绑定":@"已绑定";
            cell.showLab.textColor =[[LWAccountTool account].phone isEmptyString]?UIColorFromRGB(0xff4c61):UIColorFromRGB(0x666666);
            if (![[LWAccountTool account].phone isEmptyString]) {
                cell.userInteractionEnabled = NO;
                cell.mark.hidden = YES;
            }

        }else if (row==1){
            cell.showLab.text =[[LWAccountTool account].openid isEmptyString]?@"未绑定":@"已绑定";
            cell.showLab.textColor =[[LWAccountTool account].openid isEmptyString]?UIColorFromRGB(0xff4c61):UIColorFromRGB(0x666666);
            if (![[LWAccountTool account].openid isEmptyString]) {
                cell.userInteractionEnabled = NO;
                cell.mark.hidden = YES;
            }
        }else if (row==2){
            cell.lineView.hidden = YES;
            cell.showLab.text =[[LWAccountTool account].device_udid isEmptyString]?@"未绑定":@"已绑定";
            cell.showLab.textColor =[[LWAccountTool account].device_udid isEmptyString]?UIColorFromRGB(0xff4c61):UIColorFromRGB(0x666666);
            if (![[LWAccountTool account].device_udid isEmptyString]) {
                cell.userInteractionEnabled = NO;
                cell.mark.hidden = YES;
            }
            DLog(@"000000----%@",[LWAccountTool account].device_udid);
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger  section = indexPath.section;
    NSInteger  row     = indexPath.row;
    
    if (section==0) {
        if (row==0) {
            UserNameVC *username = [[UserNameVC alloc] init];
            username.nameStr = @"修改昵称";
            username.changename = ^(NSString *nameStr){
                self.nameStr = nameStr;
                [self.MT_tableView reloadData];
                if (![nameStr isEmptyString]) {
                    UserDefaultSetObjectForKey(nameStr, @"NAMESTRING");
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AVATERIMAGE" object:nil];
                }
            };
            
            [self.navigationController pushViewController:username animated:YES];
            [self.MT_tableView reloadData];
        }else {
            ChooseSexVC *choose = [[ChooseSexVC alloc] init];
            [self.navigationController pushViewController:choose animated:YES];
        }
        
    }else if (section==1){
        
        if (row==0) {
            ConpendVC *conpend = [[ConpendVC alloc] init];
            conpend.title = @"绑定手机号";
            [self.navigationController pushViewController:conpend animated:YES];
        }else if (row==1){
            
            BindingWeChatVC *bingwechat = [[BindingWeChatVC alloc] init];
            bingwechat.title = @"绑定微信";
            [self.navigationController pushViewController:bingwechat animated:YES];
            
        }else if (row==2){
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            [dic setObject:[LWAccountTool account].no forKey:@"no"];
            
            AddDic(dic);
            
            NSString *namestring = dic[@"no"];
            NSString *sign       = dic[@"sign"];
            NSString *signString = dic[@"signStr"];
            NSString *signTimestring = dic[@"signTime"];
            
            NSString *noString = [NSString stringWithFormat:@"no=%@&sign=%@&signStr=%@&signTime=%@",namestring,sign,signString,signTimestring];
            
            
            NSString * getString = [NSString stringWithFormat:@"%@%@?%@",KBASE_URL,CatchDevice,noString];
            
            DLog(@"--签名----%@",getString);
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:getString]];
            
        }
    }
}
//相册
-(void)PhotoAlbum{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"相册打开失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
//相机
-(void)PhotoPicture{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"您没有摄像头" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}


#pragma mark - imagePickerdelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerEditedImage];
    }
   
    if (image) {
        avaterIMG.image = image;
        UIImage *newImg = [UIImage imageCompressForWidth:image targetWidth:300];
        NSData *imgdata = UIImageJPEGRepresentation(newImg, 1.0);
        NSString*str=[UIImage typeForImageData:imgdata ];
        NSString *_encodedImageStr = [imgdata base64EncodedStringWithOptions: 0];
        NSString*pictureDataString=[NSString stringWithFormat:@"data:%@;base64,%@",str,_encodedImageStr];
        self.pictureDataString = pictureDataString;
        UserDefaultSetObjectForKey(imgdata, @"AVATERIMAGE");
        UserDefaultSetObjectForKey(self.pictureDataString, @"PICTUREDATA");
        [self GetUserUpdateInforRequest:pictureDataString];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AVATERIMAGE" object:nil];

    }
    [self.MT_tableView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)GetUserUpdateInforRequest:(NSString *)pictureStr{
    NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:string forKey:@"session"];
    [dic setValue:pictureStr forKey:@"avatar"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetUserUpdateURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        if (responseObject ) {
            if ([responseObject[@"code"] intValue] ==0) {
                [MBProgressHUD showMessage:@"修改成功"];
            }else
            {
                [MBProgressHUD showMessage:responseObject[@"msg"]];
            }
        }else{
            [MBProgressHUD showMessage:@"修改失败"];
        }
       
    }];
}
//用户协议
-(void)GetUserProtocalUpdate{
    NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:string forKey:@"session"];
    [dic setValue:self.agreeStr forKey:@"agreement"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetUserUpdateURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        if (responseObject ) {
            if ([responseObject[@"code"] intValue] ==0) {
                [MBProgressHUD showMessage:@"同意用户协议"];
            }else
            {
                [MBProgressHUD showMessage:responseObject[@"msg"]];
            }
        }else{
            [MBProgressHUD showMessage:@"失败"];
        }
        
    }];


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
