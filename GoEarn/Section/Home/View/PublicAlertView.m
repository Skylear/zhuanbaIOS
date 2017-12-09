//
//  PublicAlertView.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/18.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "PublicAlertView.h"
#import "UILabel+YBAttributeTextTapAction.h"

@interface PublicAlertView ()<YBAttributeTapActionDelegate>

@property(nonatomic,strong)UIView  * aletView;

@property(nonatomic,strong)UIButton  * sureBtn;

@property(nonatomic,strong)UIButton  * cancleBtn;

@property(nonatomic,strong)UILabel  * titleLabel;

@property(nonatomic,strong)UILabel  * messageLable;

@property(nonatomic,strong)UIImageView  * tipimage;

@property (nonatomic,strong)UIButton  * checkBtn;

@property(nonatomic,strong)UIButton  * agreeBtn;


@property(nonatomic,assign)id<PublicAlertViewDelegate>delegate;

@end

@implementation PublicAlertView

-(instancetype)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id<PublicAlertViewDelegate>)delegate cancelButtonTitle:(NSString*)canclestring otherButtonTitle:(NSString*)otherstring withMsFont:(UIFont*)msFont withTitleFont:(UIFont*)tFont
{
    if (self =[super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.delegate = delegate;
        
        UIImageView *tipImg = [[UIImageView alloc]init];
        tipImg.image = [UIImage imageNamed:@"hint_pup_ico_one"];
        [tipImg sizeToFit];
        
        tipImg.frame =CGRectMake((SCREEN_WIDTH - 60 -tipImg.width)/2, -tipImg.height/2-10, tipImg.width,tipImg.height);
        
        self.aletView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, tipImg.boundsHeight/2 + 170*SCREEN_POINT)];
        self.aletView.center = self.center;
        self.aletView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.aletView];
        
        [self.aletView addSubview:tipImg];
        
        self.aletView.layer.cornerRadius = 11*SCREEN_POINT;
        
        //self.aletView.clipsToBounds = YES;
        
        self.tipimage = tipImg;
        
        //选择
        self.checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.checkBtn.hidden = YES;
        [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"pup_draw_red"] forState:UIControlStateSelected];
        [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"pup_draw"] forState:UIControlStateNormal];
        [self.checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.aletView addSubview:self.checkBtn];
        //确定
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sureBtn setFrame:CGRectMake(self.aletView.centerX, self.aletView.maxY -45*SCREEN_POINT, self.aletView.boundsWidth/2, 45*SCREEN_POINT)];
        [self.sureBtn setBackgroundColor:UIColorFromRGB(0xff4c61)];
        self.sureBtn.tag = 1;
        [self.sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.aletView addSubview:self.sureBtn];
        //取消
        self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleBtn.hidden = YES;
        self.cancleBtn.tag = 2;
        [self.cancleBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [self.cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.aletView addSubview:self.cancleBtn];
        
        //标题
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = tFont ==nil?Font(17):tFont;
        _titleFont = self.titleLabel.font;
        self.titleLabel.textColor = UIColorFromRGB(0x444444);
        self.titleLabel.hidden = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.aletView addSubview:self.titleLabel];
        
        //内容
        self.messageLable = [[UILabel alloc]init];
        self.messageLable.font = msFont ==nil?Font(17):msFont;
        _messageFont = self.messageLable.font;
        self.messageLable.numberOfLines = 0;
        self.messageLable.textColor = UIColorFromRGB(0x333333);
        self.messageLable.textAlignment = NSTextAlignmentCenter;
        [self.aletView addSubview:self.messageLable];
        
        
        self.cancleString = canclestring;
        self.sureString = otherstring;
        self.titleString = title;
        self.messageString = message;
    }
    return self;
}
-(void)show
{
    [KEYWINDOW addSubview:self];
}
-(void)hiden
{
    [self removeFromSuperview];
}
-(void)setCancleString:(NSString *)cancleString
{
    _cancleString = cancleString;
    if (cancleString&&![cancleString isEqualToString:@""]) {
        self.cancleBtn.hidden = NO;
        [self.cancleBtn setTitle:cancleString forState:UIControlStateNormal];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.aletView).offset(0);
            make.right.equalTo(self.aletView.mas_centerX).offset(0);
            make.bottom.equalTo(self.aletView);
            make.height.mas_equalTo(45*SCREEN_POINT);
        }];
    }
}
-(void)setSureString:(NSString *)sureString
{
    _sureString = sureString;
    self.sureBtn.hidden = NO;
    [self.sureBtn setTitle:sureString forState:UIControlStateNormal];
    if (_cancleString&&![_cancleString isEqualToString:@""])
    {
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.aletView.boundsHeight - 45*SCREEN_POINT-1, self.aletView.boundsWidth, 1)];
        
        lineLabel.backgroundColor = UIColorFromRGB(0xe1e1e6);
        
        [self.aletView addSubview:lineLabel];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.sureBtn.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(10*SCREEN_POINT, 10*SCREEN_POINT)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.sureBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        self.sureBtn.layer.mask = maskLayer;

        
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.aletView.mas_centerX);
            make.right.equalTo(self.aletView);
            make.bottom.equalTo(self.aletView);
            make.height.mas_equalTo(45*SCREEN_POINT);
        }];
        
    }else
    {
        self.sureBtn.layer.cornerRadius = 5;
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.aletView).offset(25*SCREEN_POINT);
            make.right.equalTo(self.aletView).offset(-25*SCREEN_POINT);
            make.bottom.equalTo(self.aletView).offset(-25*SCREEN_POINT);
            make.height.mas_equalTo(40*SCREEN_POINT);
        }];

    }
}
-(void)setMessageString:(NSString *)messageString
{
    _messageString = messageString;

        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:messageString];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:8];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [messageString length])];
        [_messageLable setAttributedText:attributedString1];
    
    CGSize size = [messageString sizeWithFont:self.messageFont maxSize:CGSizeMake(self.aletView.width -20, 200)];
    
    if (_titleString&&![_titleString isEqualToString:@""]) {
        [_messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.aletView).offset(self.aletView.boundsWidth/2-(size.width+40)/2);
            
            make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
            
            make.size.mas_equalTo(CGSizeMake(size.width+40, size.height*SCREEN_POINT+20*SCREEN_POINT));
        }];

    }else
    {
        _messageLable.textAlignment = NSTextAlignmentCenter;
        [_messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.aletView).offset(self.aletView.boundsWidth/2-(size.width+40)/2);
            
            make.top.equalTo(self.tipimage.mas_bottom).offset((self.aletView.boundsHeight -self.tipimage.boundsHeight-45*SCREEN_POINT-size.height-20*SCREEN_POINT)/2 +(self.tipimage.boundsHeight-20*SCREEN_POINT)/4);
            
            make.size.mas_equalTo(CGSizeMake(size.width+40, size.height+20*SCREEN_POINT));
        }];

    }
}
-(void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    if (titleString &&![titleString isEqualToString:@""]) {
        self.titleLabel.hidden = NO;
        self.titleLabel.text =titleString;
        
        CGSize size = [titleString sizeWithFont:_titleFont maxSize:CGSizeMake(300, 150)];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.aletView).offset(self.aletView.boundsWidth/2-size.width/2);
            
            make.top.equalTo(self.tipimage.mas_bottom).offset((self.aletView.boundsHeight -self.tipimage.boundsHeight-45*SCREEN_POINT-size.height-20*SCREEN_POINT)/2);
            
            make.size.mas_equalTo(CGSizeMake(size.width, size.height));
        }];
    }
}
//显示用户选项
- (void) showUserChoiseBtn
{
    self.checkBtn.hidden = NO;
    [self.checkBtn sizeToFit];
    _messageLable.textColor = UIColorFromRGB(0x999999);
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_messageLable).offset(-_checkBtn.boundsHeight-5);
        make.centerY.equalTo(_messageLable).offset(-4);
    }];
}
// 设置去绑定按钮是否可点击
- (void)setIsNotAgree:(BOOL)isNotAgree
{
    if (isNotAgree ==NO) {
        [_sureBtn setBackgroundColor:UIColorFromRGB(0xff4c61)];
        _sureBtn.userInteractionEnabled = YES;
    }else
    {
        [_sureBtn setBackgroundColor:UIColorFromRGB(0xb2b2b2)];
        _sureBtn.userInteractionEnabled = NO;
    }
}

//用户未绑定手机微信等
- (void) haveCashChoiseBtn
{
    self.checkBtn.hidden = NO;
    [self.checkBtn sizeToFit];
    
    CGSize size = [_messageString sizeWithFont:self.messageFont maxSize:CGSizeMake(self.aletView.width -20, 200)];
    [_messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.aletView).offset(self.aletView.boundsWidth/2-(size.width+40)/2);
        
        make.top.equalTo(self.tipimage.mas_bottom).offset((self.aletView.boundsHeight -self.tipimage.boundsHeight-45*SCREEN_POINT-size.height-20*SCREEN_POINT)/2 +(self.tipimage.boundsHeight-20*SCREEN_POINT)/4 -15*SCREEN_POINT);
        
        make.size.mas_equalTo(CGSizeMake(size.width+40, size.height+20*SCREEN_POINT));
    }];
    NSString *protoclString = @"点击去绑定即表示同意 捞金协议";
    UILabel *attributedStringLabel = [[UILabel alloc]init];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:protoclString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, protoclString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0, protoclString.length -4)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xff4c61) range:NSMakeRange(protoclString.length -4, 4)];
    attributedStringLabel.attributedText = attributedString;
    [self.aletView addSubview:attributedStringLabel];
    
    [attributedStringLabel sizeToFit];
    
    [attributedStringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_aletView).offset(_checkBtn.boundsHeight);
        make.top.equalTo(_messageLable.mas_bottom).offset(10);
    }];
    
    
    [attributedStringLabel yb_addAttributeTapActionWithStrings:@[@"捞金协议"] delegate:self];
    self.checkBtn.selected = YES;
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(attributedStringLabel).offset(-_checkBtn.boundsHeight-5);
        make.centerY.equalTo(attributedStringLabel).offset(_messageLable.boundsHeight);
    }];
 
}
//用户点击查看协议详情
- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    DLog(@"----用户点击协议相请");
    if ([self.delegate respondsToSelector:@selector(PublicAlertView:String:range:index:)]) {
        [self.delegate PublicAlertView:self String:string range:range index:index];
    }
    [self hiden];
}
-(void)sureBtnClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(PublicAlertView:buttonindex:)]) {
        [self.delegate PublicAlertView:self buttonindex:sender.tag];
    }
    [self hiden];
}
-(void)cancleBtnClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(PublicAlertView:buttonindex:)]) {
        [self.delegate PublicAlertView:self buttonindex:sender.tag];
    }
    [self hiden];
}
-(void)checkBtnClick:(UIButton*)sender
{
    sender.selected =!sender.selected;
    if ([self.delegate respondsToSelector:@selector(PublicAlertView:userSelecte:)]) {
        [self.delegate PublicAlertView:self userSelecte:sender.selected];
    }
    
}


@end
