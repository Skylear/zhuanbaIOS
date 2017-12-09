//
//  FeedbackVC.m
//  writeApp
//
//  Created by miaomiaokeji on 16/9/6.
//  Copyright © 2016年 ios03. All rights reserved.
//

#import "FeedbackVC.h"

#define kMaxLength   119

@interface FeedbackVC ()<UITextViewDelegate>

@property (nonatomic,strong) UIButton *btn;
@end

UIKIT_EXTERN NSString *const UITextViewDidChangeNotification;

@implementation FeedbackVC
{
    UILabel *tip;//提示
    UILabel *count;//字符个数
    UITextView *textview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAINCOLOR;
    self.title = @"意见反馈";
    UIView *TView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 190)];
    TView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:TView];
    
    
    textview = [[UITextView alloc] initWithFrame:CGRectMake(8.5, 0 , SCREEN_WIDTH-20 , 190)];
    textview.backgroundColor=[UIColor whiteColor]; //背景色
    textview.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    textview.editable = YES;        //是否允许编辑内容，默认为“YES”
    textview.delegate = self;       //设置代理方法的实现类
    textview.font=[UIFont systemFontOfSize:15]; //设置字体名字和字体大小;
    textview.returnKeyType = UIReturnKeyDefault;//return键的类型
    textview.keyboardType = UIKeyboardTypeDefault;//键盘类型
    textview.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    textview.textColor = UIColorFromRGB(0x333333);
    [self.view addSubview:textview];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 自定义文本框placeholder
    tip = [[UILabel alloc] initWithFrame:CGRectMake(10+1.5, 15, SCREEN_WIDTH, 20)];
    tip.text = @"请输入您的宝贵建议";
    tip.textColor = UIColorFromRGB(0x999999);
    tip.font = [UIFont systemFontOfSize:15];
    tip.backgroundColor = [UIColor clearColor];
    tip.enabled = NO;
    
    // 自定义文本框字数统计
    count = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, textview.frame.size.height -20, 60, 20)];
    count.text = @"0/120";
    count.textColor = UIColorFromRGB(0x999999);
    count.textAlignment = NSTextAlignmentRight;
    count.font = [UIFont systemFontOfSize:12];
    count.backgroundColor = [UIColor clearColor];
    count.enabled = NO;
    
    // 显示文本框及相关控件
    [TView addSubview:textview];
    [self.view addSubview:tip];
    [self.view addSubview:count];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(0, 0, 35, 15);
    [self.btn setTitle:@"完成" forState:UIControlStateNormal];
    [self.btn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn];

    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction:) name:UITextViewTextDidChangeNotification object:textview];
    

    
}
-(void)infoAction:(NSNotification *)sender{
    NSString *lang = [[[UITextInputMode activeInputModes] firstObject] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        //        如果输入有中文，且没有出现文字备选框就对字数统计和限制
        //        出现了备选框就暂不统计
        UITextRange *range = [textview markedTextRange];
        
        UITextPosition *position = [textview positionFromPosition:range.start offset:0];
        if (!position)
        {
            [self checkText:textview];
        }
    }
    else
    {
        [self checkText:textview];
    }

    
}

-(void)finishClick:(UIButton *)button{
    

        if (textview.text.length  ==0) {
            button.selected = YES;
            [MBProgressHUD showMessage:@"请输入意见"];
            
        }else if(textview.text.length  <5){
            button.selected = YES;
            [MBProgressHUD showMessage:@"请输入5字以上"];
        }else if (textview.text.length  >=5){
          
            [self TijiaoYijian];
        }
}

#pragma mark - UITextViewDelegate

// 限制输入文本长度
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSMutableString *copyStr = [textView.text mutableCopy];
    
    
    return YES;
}
- (void)checkText:(UITextView *)textView
{
    NSString *string = textView.text;
    
    if (string.length > kMaxLength)
    {
        textView.text = [string substringToIndex:kMaxLength];
    }
    

}

// 自定义文本框placeholder
- (void)textViewDidChange:(UITextView *)textView
{
    
    count.text = [NSString stringWithFormat:@"%ld/120", (unsigned long)textView.text.length];
    
    if (textView.text.length>0) {
        [self.btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        tip.hidden = YES;
    }else{
        
        tip.hidden = NO;
    }
}

-(void)TijiaoYijian{
    
    NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:string forKey:@"session"];
 
    [dic setValue:textview.text forKey:@"content"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,UpdateFeedbackURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
            [MBProgressHUD showMessage:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
