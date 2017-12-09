//
//  InviteFriendVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/26.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "InviteFriendVC.h"
#import "MIAOShareView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import  "WXApi.h"
#import "WeiboSDK.h"
#import "ShareFriendModel.h"
#import "QRCodeHandler.h"


@interface InviteFriendVC ()
@property (nonatomic,strong) ShareFriendModel  * shareModel;
@end

@implementation InviteFriendVC
{
    UIView *SView;
    SSDKPlatformType type;
    UIImageView *codeIMG;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.shareModel = [[ShareFriendModel alloc] init];
   
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.frame = CGRectMake(0, 0, 40, 20);
    //[button setTitle:@"规则" forState:UIControlStateNormal];
    //[button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    //button.titleLabel.font = Font(15);
    //[button addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    SView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 450)];
    SView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:SView];
//背景图
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 375)];
    imgView.image = [UIImage imageNamed:@"share_bg"];
    imgView.userInteractionEnabled = YES;
    [SView addSubview:imgView];
    
    UILabel *PLab = [[UILabel alloc] initWithFrame:CGRectMake(0,15, SCREEN_WIDTH, 15)];
    PLab.text = @"方式 1";
    PLab.textColor = UIColorFromRGB(0x4c4c4c);
    PLab.textAlignment = NSTextAlignmentCenter;
    PLab.font = Font(14);
    PLab.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:PLab];
    
    UILabel *ULab = [[UILabel alloc] initWithFrame:CGRectMake(0, PLab.bottom+13, SCREEN_WIDTH, 15)];
    ULab.text = @"扫描下方二维码或者长按保存图片";
    ULab.textColor = UIColorFromRGB(0x666666);
    ULab.textAlignment = NSTextAlignmentCenter;
    ULab.font = Font(12);
    ULab.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ULab];
    
    UIImageView *avaterIMG = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-65)/2, ULab.bottom+40, 65, 65)];
    NSData *imgdata = UserDefaultObjectForKey(@"AVATERIMAGE");
    UIImage *IMG = [UIImage imageWithData:imgdata];
    if (IMG) {
        avaterIMG.image = IMG;
    }else if ([LWAccountTool account].avatar) {
        [avaterIMG sd_setImageWithURL:[NSURL URLWithString:[LWAccountTool account].avatar] placeholderImage:[UIImage imageNamed:@"data_default"]];
    }else{
        avaterIMG.image = [UIImage imageNamed:@"data_default"];
    }

    avaterIMG.cornerRadius = avaterIMG.height/2;
    [imgView addSubview:avaterIMG];
    
    UILabel *Glab = [[UILabel alloc] initWithFrame:CGRectMake(0, avaterIMG.bottom+10, SCREEN_WIDTH, 15)];
    Glab.text = [NSString stringWithFormat:@"ID:%@",[LWAccountTool account].no];
    Glab.textAlignment = NSTextAlignmentCenter;
    Glab.textColor = UIColorFromRGB(0x4c4c4c);
    Glab.font = Font(13);
    [imgView addSubview:Glab];
//二维码
    codeIMG = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-155)/2, Glab.bottom+15, 155, 155)];
    codeIMG.backgroundColor = MAINCOLOR;
    codeIMG.userInteractionEnabled = YES;
    [imgView addSubview:codeIMG];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    longPress.minimumPressDuration = 1.0;
    [codeIMG addGestureRecognizer:longPress];
    

    UILabel *ALab = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom+20, SCREEN_WIDTH, 15)];
    ALab.text = @"长按识别二维码";
    ALab.textColor = UIColorFromRGB(0x666666);
    ALab.textAlignment = NSTextAlignmentCenter;
    ALab.font = Font(13);
    ALab.backgroundColor = [UIColor whiteColor];
    [SView addSubview:ALab];

    UILabel *KLab = [[UILabel alloc] initWithFrame:CGRectMake(0, ALab.bottom+10, SCREEN_WIDTH, 15)];
    KLab.text = @"下载捞金APP-赚钱如此简单";
    KLab.textColor = UIColorFromRGB(0x666666);
    KLab.textAlignment = NSTextAlignmentCenter;
    KLab.font = Font(13);
    KLab.backgroundColor = [UIColor whiteColor];
    [SView addSubview:KLab];
    
    UIView *Fview = [[UIView alloc] initWithFrame:CGRectMake(0, imgView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-imgView.height)];
    Fview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:Fview];
    
    UILabel *WLab = [[UILabel alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-180, SCREEN_WIDTH, 15)];
    WLab.text = @"方式 2";
    WLab.textColor = UIColorFromRGB(0x4c4c4c);
    WLab.textAlignment = NSTextAlignmentCenter;
    WLab.font = Font(14);
    WLab.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WLab];
    
    UILabel *OLab = [[UILabel alloc] initWithFrame:CGRectMake(0,WLab.bottom+13, SCREEN_WIDTH, 10)];
    OLab.text = @"点击下方按钮,邀请好友加入";
    OLab.textColor = UIColorFromRGB(0x666666);
    OLab.textAlignment = NSTextAlignmentCenter;
    OLab.font = Font(12);
    OLab.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:OLab];
    
    UIButton *immeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    immeBtn.frame = CGRectMake((SCREEN_WIDTH-250)/2, OLab.bottom+17, 250 , 45);
    [immeBtn setTitle:@"立即邀请好友" forState:UIControlStateNormal];
    [immeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    immeBtn.titleLabel.font = Font(16);
    immeBtn.backgroundColor = UIColorFromRGB(0xff4c61);
    immeBtn.layer.cornerRadius = 3;
    [immeBtn addTarget:self action:@selector(immeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:immeBtn];
    
    [self GetInviteFriendRequest];
}

-(void)ruleClick{

}
-(void)immeClick{
    MIAOShareView * share = [MIAOShareView creatXib];

    [share setGetTouch:^(NSInteger BTNTag) {
        [self getTag:BTNTag];
}];
    [share show];
}
-(void)getTag:(NSInteger)tag
{
    if (tag==6) {
        //复制链接
        [self copyLianjia];
    }else{
    type =  SSDKPlatformTypeUnknown;
    switch (tag) {
        case 1:
            type = SSDKPlatformSubTypeWechatSession;
            break;
        case 2:
            type = SSDKPlatformSubTypeWechatTimeline;
            break;
        case 3:
            type = SSDKPlatformTypeSinaWeibo ;
            break;
        case 4:
            type = SSDKPlatformSubTypeQQFriend;
            break;
        case 5:
            type = SSDKPlatformSubTypeQZone;
            break;
        case 6:

            break;

        default:
            break;
    }

    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];

    NSURL *url = [NSURL URLWithString:self.shareModel.shareUrl];

        GRLog(@"-------%@",url);
//    [shareParams SSDKSetupShareParamsByText:self.tongjiModel.desc
//                                     images:self.tongjiModel.img
//                                        url:url
//                                      title:self.tongjiModel.title
//                                       type: SSDKContentTypeAuto ];

        [shareParams SSDKSetupShareParamsByText:self.shareModel.desc
                                         images:self.shareModel.img
                                            url:url
                                          title:self.shareModel.title
                                           type: SSDKContentTypeAuto ];
    //进行分享
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {

         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [MBProgressHUD showMessage:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {  //判断是否有微信
                 if ([WXApi isWXAppInstalled]||[QQApiInterface isQQInstalled]) {


                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                         message:[NSString stringWithFormat:@"%@", error]
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                 }
                 else{

                     if (tag==1||tag==2) {
                         [MBProgressHUD showMessage:@"未安装微信,无法分享"];
                     }else if (tag==4||tag==5){

                         [MBProgressHUD showMessage:@"未安装QQ,无法分享"];
                     }
                 }
                 break;
             }
             case SSDKResponseStateCancel:
             {

                 [MBProgressHUD showMessage:@"分享取消"];
                 break;

             }
             default:
                 break;
         }
     }];
}
}
//长按
-(void)longPress{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存到手机相册?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //保存当前view到手机相册
        UIGraphicsBeginImageContextWithOptions(SView.frame.size, YES, 0.0);
//    UIGraphicsBeginImageContext(SView.frame.size);
    [SView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *ViewIMg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imgData = UIImagePNGRepresentation(ViewIMg);
        UIImage *img = [UIImage imageWithData:imgData];
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    [MBProgressHUD showMessage:@"名片保存成功!"];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)copyLianjia{
    
    if ([self.shareModel.shareUrl isEqualToString:@"" ]) {
        [MBProgressHUD showMessage:@"复制链接失败!"];
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.shareModel.shareUrl;
        if (pasteboard.string) {
           [MBProgressHUD showMessage:@"复制链接成功!"];
        }else{
           [MBProgressHUD showMessage:@"复制链接失败!"];
        }
        
    }
}

-(void)GetInviteFriendRequest{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];

    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,InviteFriendURL] parameters:dic type:NetworkRequestTypeGet resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
            self.shareModel = [ShareFriendModel mj_objectWithKeyValues:responseObject[@"data"]];
            codeIMG.image = [QRCodeHandler createQRCodeForString:self.shareModel.shareUrl withImageViewSize:codeIMG.size];
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
