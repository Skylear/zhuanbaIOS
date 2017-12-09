//
//  QRCodeAlertView.m
//  writeApp
//
//  Created by Beyondream on 16/9/12.
//  Copyright © 2016年 ios03. All rights reserved.
//

#import "QRCodeAlertView.h"
#import "QRCodeGenerator.h"
@implementation QRCodeAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self creatUI];
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)]];

    }
    return self;
}
-(void)tapGesture:(UIGestureRecognizer*)gesture
{
    [self removeFromSuperview];
}
-(void)longTapGesture:(UIGestureRecognizer *)recognizer
{
    UIImageView *codeImgView = (UIImageView*)recognizer.view;
    if(recognizer.state != UIGestureRecognizerStateEnded){
        
        DLog(@"not UIGestureRecognizerStateEnded");
        
    }else {
        UIImageWriteToSavedPhotosAlbum(codeImgView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}
//保存反馈
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(alertView:message:)]) {
        [self.delegate alertView:self message:message];
    }
    DLog(@"message is %@",message);
}
-(void)creatUI
{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(20, (SCREEN_HEIGHT -64)/2 -200*SCREEN_POINT+54, SCREEN_WIDTH -40, 400*SCREEN_POINT)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 10*SCREEN_POINT;
    whiteView.clipsToBounds = YES;
    [self addSubview:whiteView];

    //头像
    
    self.headimg = [[UIImageView alloc]initWithFrame:CGRectMake(20*SCREEN_POINT, 18*SCREEN_POINT, 50*SCREEN_POINT, 50*SCREEN_POINT)];
    self.headimg.layer.cornerRadius = 25*SCREEN_POINT;
    self.headimg.layer.masksToBounds = YES;
    self.headimg.layer.borderWidth = 0.5;
    self.headimg.layer.borderColor = UIColorFromRGB(0xe1e6e6).CGColor;
    self.headimg.image = [UIImage imageNamed:@"2013011.jpg"];
    [whiteView addSubview:self.headimg];
    
    
    //姓名
    NSString *numberBtnString =[NSString stringWithFormat:@"花瓣"];
    CGFloat labelWidth = [numberBtnString sizeWithFont:Font(17) maxSize:CGSizeMake(CGFLOAT_MAX, 30)].width;
    
    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameBtn setFrame:CGRectMake(self.headimg.maxX +5,self.headimg.centerY -15, labelWidth +10, 30)];
   
    [nameBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    nameBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];

    [nameBtn setTitle:numberBtnString forState:UIControlStateNormal];

    nameBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:nameBtn];
    
    
    //线
    UILabel *linelabel = [[UILabel alloc]initWithFrame:CGRectMake(whiteView.minX,self.headimg.maxY +16,whiteView.boundsWidth -40, 0.5)];
    linelabel.backgroundColor = UIColorFromRGB(0xe1e6e6);
    [whiteView addSubview:linelabel];
    
    
    //二维码
    UIImageView *codeView = [[UIImageView alloc]initWithFrame:CGRectMake(linelabel.minX-25, linelabel.maxY -15, linelabel.boundsWidth +50, linelabel.boundsWidth +50)];
    UIImage*tempImage=[QRCodeGenerator qrImageForString:numberBtnString imageSize:linelabel.boundsWidth Topimg:nil withColor:nil];
    codeView.image = tempImage;
    codeView.userInteractionEnabled = YES;
    [codeView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapGesture:)]];
    [whiteView addSubview:codeView];
    
    //文字说明
    
    UILabel *infoLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(codeView.minX, codeView.maxY -15, codeView.boundsWidth, 20)];
    infoLabel1.font = Font(13);
    infoLabel1.textAlignment = NSTextAlignmentCenter;
    infoLabel1.text = @"长按二维码 - 保存图片";
    infoLabel1.textColor = UIColorFromRGB(0x808080);
    [whiteView addSubview:infoLabel1];
    
    UILabel *infoLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(codeView.minX, infoLabel1.maxY+2, codeView.boundsWidth, 20)];
    infoLabel2.font = Font(13);
    infoLabel2.textAlignment = NSTextAlignmentCenter;
    infoLabel2.text = @"打开微信 - 扫一扫 - 选择图片关注";
    infoLabel2.textColor = UIColorFromRGB(0x808080);
    [whiteView addSubview:infoLabel2];
    
}
@end
