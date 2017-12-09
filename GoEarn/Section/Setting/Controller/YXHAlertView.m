//
//  YXHAlertView.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/12/26.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "YXHAlertView.h"
#import "ProTool.h"

@interface YXHAlertView ()<UIWebViewDelegate>

@property(nonatomic,strong)UIView  * aletView;

@property(nonatomic,strong)UIButton  * sureBtn;

@property(nonatomic,strong)UIButton  * cancleBtn;

@property(nonatomic,strong)UILabel  * titleLabel;

@property (nonatomic,strong)UIButton  * checkBtn;

@property(nonatomic,strong)UIButton  * agreeBtn;

@property (nonatomic,strong) UIWebView  * webView;

@property (nonatomic,assign) id<YXHAlertViewDelegate>delegate;
@end

@implementation YXHAlertView
-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<YXHAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)canclestring otherButtonTitle:(NSString *)otherstring withMsFont:(UIFont *)msFont withTitleFont:(UIFont *)tFont{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.delegate = delegate;
        
        self.aletView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 340*SCREEN_POINT)];
        self.aletView.center = self.center;
        self.aletView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.aletView];
        
        self.aletView.layer.cornerRadius = 11*SCREEN_POINT;
        
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
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 40, self.aletView.width, self.aletView.height-45*SCREEN_POINT-40)];
        _webView.opaque = NO;
        _webView.backgroundColor = kClearColor;
        [_webView setScalesPageToFit:YES];
        _webView.delegate = self;
        [self.aletView addSubview:self.webView];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"USER_AGREEMENT" forKey:@"name"];
        NSString *signTimestring = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        NSString *signString = [NSString generateFradomCharacter];
        [dic setObject:signTimestring forKey:@"signTime"];
        [dic setObject:signString forKey:@"signStr"];
        
        NSString *sign       = [ProTool encoingWithDic:dic Withcharacter:signString];
        
        NSString *namestring = @"USER_AGREEMENT";
        
        NSString *sigurl = [NSString stringWithFormat:@"name=%@&sign=%@&signStr=%@&signTime=%@",namestring,sign,signString,signTimestring];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",KBASE_URL,GetContentUrl,sigurl]]]];
        self.cancleString = canclestring;
        self.sureString = otherstring;
        self.titleString = title;
        
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
-(void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    if (titleString &&![titleString isEqualToString:@""]) {
        self.titleLabel.hidden = NO;
        self.titleLabel.text =titleString;
       /* UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, self.aletView.boundsWidth, 1)];
        lineLabel.backgroundColor = UIColorFromRGB(0xe1e1e6);
        
        [self.aletView addSubview:lineLabel];*/
        
        CGSize size = [titleString sizeWithFont:_titleFont maxSize:CGSizeMake(300, 150)];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.aletView).offset(self.aletView.boundsWidth/2-size.width/2);
            
            make.top.equalTo(self.aletView.mas_top).offset(12);
            
            make.size.mas_equalTo(CGSizeMake(size.width, size.height));
            
        }];
        
    }
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView

{
    
    // finished loading, hide the activity indicator in the status bar
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

@end
