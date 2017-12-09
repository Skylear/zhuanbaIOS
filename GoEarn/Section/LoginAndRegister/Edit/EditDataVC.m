//
//  EditDataVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/8.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "EditDataVC.h"
#import "CustomTextField.h"
#import "ChooseSexVC.h"
#import "LPActionSheet.h"


#define AvaterW    80
#define kMaxLength   0

@interface EditDataVC ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) NSString  * textValue;
@end

@implementation EditDataVC
{
    UIButton *NextBtn;
    CustomTextField *NameTF;
    UIImageView *avaterIMG;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    [self createUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:NameTF];
    
    // Do any additional setup after loading the view.
}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    self.textValue = textField.text;
    NSString *toBeString = textField.text;
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    
    if ([current.primaryLanguage isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
       
            if (toBeString.length > kMaxLength) {
//                textField.text = [toBeString substringToIndex:kMaxLength];
                NextBtn.backgroundColor = UIColorFromRGB(0xFF4c61);
                [NextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                NextBtn.enabled = YES;

            }else{
                NextBtn.backgroundColor = UIColorFromRGB(0xE4E4E4);
                [NextBtn setTitleColor:UIColorFromRGB(0xb9b9bb) forState:UIControlStateNormal];
                NextBtn.enabled = NO;
            }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
//        if (toBeString.length > kMaxLength) {
//            textField.text = [toBeString substringToIndex:kMaxLength];
//        }  
    }
}

-(void)createUI{
    avaterIMG = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-AvaterW)/2, 85+64, AvaterW, AvaterW)];
    avaterIMG.image = [UIImage imageNamed:@"huhiu"];
    avaterIMG.cornerRadius =AvaterW/2;
    avaterIMG.userInteractionEnabled = YES;
    [self.view addSubview:avaterIMG];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick)];
    [avaterIMG addGestureRecognizer:tap];
    
    UIButton *PhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    PhotoBtn.frame = CGRectMake(avaterIMG.left+55, avaterIMG.top+55, 25, 25);
    PhotoBtn.cornerRadius = 25/2;
    [PhotoBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    [PhotoBtn addTarget:self action:@selector(photoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:PhotoBtn];
    
    NameTF = [[CustomTextField alloc] initWithFrame:CGRectMake(36,avaterIMG.bottom+15, SCREEN_WIDTH-72, 60) font:16];
    NameTF.Placeholder = @"昵称";
    NameTF.delegate = self;
    [self.view addSubview:NameTF];
    
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.frame = CGRectMake(36, NameTF.bottom, SCREEN_WIDTH-72, 28);
    detailLab.text = @"2-20个字符。支持中英文、数字、减号、下划线";
    detailLab.font = Font(10);
    detailLab.textColor = UIColorFromRGB(0x4c4c4c);
    [self.view addSubview:detailLab];
    
    NextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NextBtn.frame= CGRectMake(36, NameTF.bottom+85, SCREEN_WIDTH-72, 45);
    [NextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    NextBtn.backgroundColor = UIColorFromRGB(0xE4E4E4);
    [NextBtn setTitleColor:UIColorFromRGB(0xb9b9bb) forState:UIControlStateNormal];
    NextBtn.cornerRadius = 3;
    NextBtn.enabled = NO;
    NextBtn.titleLabel.font = Font(16);
    [NextBtn addTarget:self action:@selector(NextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:NextBtn];
    
}

-(void)photoClick{
    [LPActionSheet showActionSheetWithTitle:@"选择图片来源" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"相机"] isShow:YES handler:^(LPActionSheet *actionSheet, NSInteger index) {
        
        if (index==1) {
            [self PhotoAlbum];
        }else if(index==2){
            [self PhotoPicture];
        }
    }];

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
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"您没有摄像头" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
#pragma mark - imagePickerdelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    self.avaterImage = image;
    if (self.avaterImage) {
        avaterIMG.image = self.avaterImage;
    }else{
        
    }

    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}
-(void)NextClick{
    [MBProgressHUD showMessage:@"正在上传头像!"];
    [self GetUserUpdateInforRequest];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *mutableStr = [textField.text mutableCopy];
    [mutableStr replaceCharactersInRange:range withString:string];
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length>0) {
    NextBtn.backgroundColor = UIColorFromRGB(0xFF4c61);
    [NextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NextBtn.enabled = YES;
        return YES;
    }else{
        NextBtn.backgroundColor = UIColorFromRGB(0xE4E4E4);
        [NextBtn setTitleColor:UIColorFromRGB(0xb9b9bb) forState:UIControlStateNormal];
        NextBtn.enabled = NO;
        return YES;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NextBtn.backgroundColor = UIColorFromRGB(0xE4E4E4);
    [NextBtn setTitleColor:UIColorFromRGB(0xb9b9bb) forState:UIControlStateNormal];
    NextBtn.enabled = NO;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    reason = UITextFieldDidEndEditingReasonCommitted;
    self.textValue = textField.text;
}


-(void)GetUserUpdateInforRequest{
    NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:string forKey:@"session"];
    [dic setValue:self.avaterImage forKey:@"avatar"];
    [dic setValue:self.textValue forKey:@"nickname"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetUserUpdateURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {

            ChooseSexVC *choose = [[ChooseSexVC alloc] init];
            choose.title = @"编辑资料";
            [self.navigationController pushViewController:choose animated:YES];
            
        }else
        {
            [MBProgressHUD showMessage:@"设置失败!"];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:NameTF];
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
