//
//  FYHomeBusinessView.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/12.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "FYHomeBusinessView.h"


@implementation BussinessModel


@end



static int btnCount = 1;
@interface FYHomeBusinessView ()

//商家
@property(nonatomic,strong)NSMutableArray  * bussinessArr;
//商家图片
@property(nonatomic,strong)NSString  * bussinessUrl;

@property(nonatomic,strong)NSString  * moneyString;

@property(nonatomic,strong)UIButton  * closeBtn;
//存储自己添加上去的
@property(nonatomic,strong)NSMutableArray  * myTipArr;
@property(nonatomic,strong) UIView *myOwnTipView;

@property(nonatomic,strong)NSMutableArray  * nameIDArr;
@end

@implementation FYHomeBusinessView
-(instancetype)initWithFrame:(CGRect)frame withUrl:(NSString*)urlString withArr:(NSArray*)arr withMoney:(NSString *)money
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.bussinessArr =[NSMutableArray array];
        self.nameIDArr = [NSMutableArray array];
        for (int i=0; i<arr.count; i++)
        {
            BussinessModel *model = [[BussinessModel alloc]init];
            model.nameString = arr[i];
            model.nameID = [NSString stringWithFormat:@"%d",i+1];
           //[self.nameIDArr addObject:[NSString stringWithFormat:@"%d",i+1]];
            [self.bussinessArr addObject:model];
            
        }
        
        self.bussinessUrl = urlString;
        self.moneyString = money;
        
        [self creatUI];
        
        self.myTipArr = [NSMutableArray array];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
    }
    return self;
}
-(void)creatUI
{
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 5;
    whiteView.clipsToBounds = YES;
    [self addSubview:whiteView];

    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.left.equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, SCREEN_HEIGHT -200));
    }];
    
    //标题
    UIImageView *bussinessImg = [[UIImageView alloc]init];
    bussinessImg.backgroundColor = UIColorFromRGB(0xfffbf2);
    [bussinessImg sd_setImageWithURL:[NSURL URLWithString:self.bussinessUrl] placeholderImage:placeholder_banner ];
    [whiteView addSubview:bussinessImg];
    
    [bussinessImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView).offset(25);
        make.left.equalTo(whiteView).offset(26);
        make.height.mas_equalTo(60*SCREEN_POINT);
        make.width.equalTo(whiteView.mas_width).offset(-52);
    }];
    
    //提示
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = [NSString stringWithFormat:@"选取核心记忆词验证  + %@ 元",self.moneyString];
    [whiteView addSubview:tipLabel];
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:tipLabel.text];
    [attribute addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x555555),NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:16],NSFontAttributeName, nil] range:NSMakeRange(0, 10)];
    [attribute addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x808080),NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:11],NSFontAttributeName, nil] range:NSMakeRange(10, 2)];
    [attribute addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xff4c61),NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] range:NSMakeRange(13, tipLabel.text.length -15)];
    [attribute addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x808080),NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:11],NSFontAttributeName, nil] range:NSMakeRange(tipLabel.text.length -1, 1)];
    tipLabel.attributedText = attribute;
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bussinessImg);
        make.top.equalTo(bussinessImg.mas_bottom).offset(10);
        make.width.equalTo(bussinessImg);
        make.height.mas_equalTo(30*SCREEN_POINT);
    }];
    
    //自己选择的字框
    UIView *myTipView = [[UIView alloc]init];
    myTipView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self addSubview:myTipView];
    [myTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(10);
        make.left.equalTo(bussinessImg);
        make.width.equalTo(bussinessImg);
        make.height.mas_equalTo(50*SCREEN_POINT);
    }];
    self.myOwnTipView = myTipView;
    
    //文字
    for (int i= 0; i<self.bussinessArr.count; i++) {
        int Long_X = i%3;
        int Long_Y = i/3;
        BussinessModel *model = self.bussinessArr[i];
        UIButton * buttonCharacBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonCharacBtn setBackgroundImage:[UIImage imageNamed:@"kanji_box"] forState:UIControlStateNormal];
        [buttonCharacBtn setTitle:model.nameString forState:UIControlStateNormal];
        buttonCharacBtn.tag = 1000+i;
        buttonCharacBtn.titleLabel.font = [UIFont boldSystemFontOfSize:23];
        [buttonCharacBtn setBackgroundImage:[UIImage imageNamed:@"kanji_box_opt"] forState:UIControlStateSelected];
        [buttonCharacBtn addTarget:self action:@selector(buttonCharacBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonCharacBtn setTitleColor:UIColorFromRGB(0x9b9b9b) forState:UIControlStateNormal];
        [buttonCharacBtn setTitleColor:UIColorFromRGB(0xffa710) forState:UIControlStateSelected];
        [self addSubview:buttonCharacBtn];
        
        [buttonCharacBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(myTipView).offset((45 +7)*SCREEN_POINT*Long_X);
            make.top.equalTo(myTipView.mas_bottom).offset(15+(45 +7)*SCREEN_POINT*Long_Y);
            make.size.mas_equalTo(CGSizeMake(45*SCREEN_POINT, 45*SCREEN_POINT));
            
        }];
    }
    
    //晴空
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.layer.cornerRadius = 3;
    clearBtn.clipsToBounds = YES;
    clearBtn.layer.borderColor = UIColorFromRGB(0xacacac).CGColor;
    clearBtn.titleLabel.font = Font(15);
    clearBtn.layer.borderWidth = 0.5f,
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearClick:) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [self addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myTipView.mas_bottom).offset(15);
        make.right.equalTo(myTipView);
        make.left.equalTo(myTipView).offset((45 +7)*3*SCREEN_POINT);
        make.height.mas_equalTo(45*SCREEN_POINT);
        
    }];
    
    
    //提交
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.layer.cornerRadius = 3;
    commitBtn.clipsToBounds = YES;
    commitBtn.layer.borderColor = UIColorFromRGB(0xff4c61).CGColor;
    commitBtn.titleLabel.font = Font(15);
    commitBtn.titleLabel.numberOfLines = 2;
    commitBtn.layer.borderWidth = 0.5f,
    [commitBtn setTitle:@"提交\n任务" forState:UIControlStateNormal];
    [commitBtn setTitleColor:UIColorFromRGB(0xff4c61) forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clearBtn.mas_bottom).offset(7*SCREEN_POINT);
        make.right.equalTo(myTipView);
        make.left.equalTo(clearBtn);
        make.height.mas_equalTo(97*SCREEN_POINT);
        
    }];

    
    //关闭
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"checkin_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn sizeToFit];
    [self addSubview:self.closeBtn];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView.mas_centerX).offset(-self.closeBtn.boundsHeight/2);
        make.top.equalTo(whiteView.mas_bottom).offset(22 +self.closeBtn.boundsHeight/2);
    }];
    
}
-(void)buttonCharacBtnClick:(UIButton*)sender
{
    DLog(@"-----%@%d",sender.titleLabel.text,btnCount);
    BussinessModel *selectedModel = self.bussinessArr[sender.tag -1000];
    
   // int position = [self isaleardyExist:self.myTipArr withModel:selectedModel];
    
    if (self.myTipArr.count>=5&&![self.nameIDArr containsObject:selectedModel.nameID]) {
        [MBProgressHUD showMessage:@"最大个数是5个"];
        return;
    }
    //上方已经包含当前选中的按钮
    if ([self.nameIDArr containsObject:selectedModel.nameID])
    {
        NSInteger interger = [self.nameIDArr indexOfObject:selectedModel.nameID] +1;
        UIButton *selectedBtn = (UIButton*)[self.myOwnTipView viewWithTag:interger];
        [selectedBtn removeFromSuperview];
        
        for (UIView *btnView in self.myOwnTipView.subviews)
        {
            if ([btnView isKindOfClass:[UIButton class]]) {
                btnView.tag = btnCount;
                [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.myOwnTipView).offset(6 +(38*SCREEN_POINT+6*SCREEN_POINT)*(btnCount -1));
                }];
                btnCount ++;
            }
        }
        [self.myTipArr removeObjectAtIndex:interger-1];
        [self.nameIDArr removeObjectAtIndex:interger-1];
        sender.selected = NO;

        
    }else
    {
        sender.selected = YES;
        UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tipBtn setBackgroundImage:[UIImage imageNamed:@"kanji_box_opt"] forState:UIControlStateSelected];
        [tipBtn setTitleColor:UIColorFromRGB(0xffa710) forState:UIControlStateSelected];
        tipBtn.selected = YES;
        [tipBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
        [tipBtn addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.myOwnTipView addSubview:tipBtn];
        
        [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myOwnTipView).offset(6 +(38*SCREEN_POINT+6*SCREEN_POINT)*self.myTipArr.count).priorityLow();
            make.top.equalTo(self.myOwnTipView).offset(self.myOwnTipView.height/2 - 38/2*SCREEN_POINT);
            make.size.mas_equalTo(CGSizeMake(38*SCREEN_POINT, 38*SCREEN_POINT));
        }];
        tipBtn.tag = self.myTipArr.count +1;
        
        [self.myTipArr addObject:selectedModel];
        [self.nameIDArr addObject:selectedModel.nameID];
        
    }
    btnCount = 1;
}
// 我之前选中的点击方法
-(void)tipBtnClick:(UIButton*)sender
{
    BussinessModel *model = self.myTipArr[sender.tag -1];
    //NSInteger interger = [self.myTipArr indexOfObject:model.nameID] +1;
    //UIButton *selectedBtn = (UIButton*)[self.myOwnTipView viewWithTag:interger];
    
    NSInteger  bottomInteger = [self isaleardyExist:self.bussinessArr withModel:model];
    UIButton *bottomSelectedBtn = [self viewWithTag:bottomInteger +1000];
    bottomSelectedBtn.selected = NO;
    [sender removeFromSuperview];
    
    [self.myTipArr removeObject:model];
    [self.nameIDArr removeObject:model.nameID];
    for (UIView *btnView in self.myOwnTipView.subviews)
    {
        if ([btnView isKindOfClass:[UIButton class]]) {
            btnView.tag = btnCount;
            [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.myOwnTipView).offset(6 +(38*SCREEN_POINT+6*SCREEN_POINT)*(btnCount -1)*SCREEN_POINT);
            }];
            btnCount ++;
        }
    }
    btnCount = 1;
}
//关闭
-(void)closeClick:(UIButton*)sender
{
   [self removeFromSuperview];
}
//清空
-(void)clearClick:(UIButton*)sender
{
    for (UIView *btnView in self.myOwnTipView.subviews)
    {
        if ([btnView isKindOfClass:[UIButton class]]) {
            [btnView removeFromSuperview];
        }
    }
   
    for (int i=0; i<9; i++) {
        UIButton *bottomSelectedBtn = [self viewWithTag:i +1000];
        bottomSelectedBtn.selected = NO;

    }
    [self.myTipArr removeAllObjects];
    [self.nameIDArr removeAllObjects];
     btnCount = 1;
}
//提交审核任务
-(void)commitBtnClick:(UIButton*)sender
{
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *keyString =@"";
    
    for (BussinessModel*model in self.myTipArr) {
        keyString = [NSString stringWithFormat:@"%@%@",keyString,model.nameString];
    }
    __weak typeof(self) weakSelf = self;
    DLog(@"self.appDelegate.missionID===%@",appDelegate.missionID);
    [[[AFNetworkRequest alloc]init] requestWithVC:nil URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,CommiteBussinessMission] parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:[LWAccountTool account].no,@"no",appDelegate.missionID,@"utno",keyString,@"words", nil] type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error)
    {
        if (error) {
            [MBProgressHUD showError:@"请求失败，请稍后再试"];
        }else
        {
            if ([responseObject[@"code"] intValue] ==0)
            {
                [MBProgressHUD showSuccess:@"提交成功"];
                if ([weakSelf.delegate respondsToSelector:@selector(FYHomeBusiness:)]) {
                    [weakSelf removeFromSuperview];
                    [weakSelf.delegate FYHomeBusiness:self];
                }
                
            }else
            {
            [[LoadingView shareInstance] showErrorMessage:responseObject[@"msg"]];
            }
        }
    }];
}

-(int)isaleardyExist:(NSMutableArray*)sourceArr withModel:(BussinessModel*)model
{
    int position = 0;
    for (int i=0; i<sourceArr.count; i++)  {
        BussinessModel *nowModel = sourceArr[i];
        
        DLog(@"当前%@%@---之前的%@%@",model.nameID,model.nameString,nowModel.nameID,nowModel.nameString);
        
        if (nowModel.nameID ==model.nameID&&[nowModel.nameString isEqualToString:model.nameString]) {
            position = i;
        }
    }

    return position;
}

@end

