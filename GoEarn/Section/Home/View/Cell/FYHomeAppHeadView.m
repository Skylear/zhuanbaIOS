//
//  FYHomeAppHeadView.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/11.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "FYHomeAppHeadView.h"


@implementation FYHomeAppHeadView

+(instancetype)headViewWithTableView:(UITableView*)tableView WithSection:(NSInteger)section model:(HomeAppModel *)model isBusiness:(BOOL)isBusiness
{
    //NSString *indentifer = [NSString stringWithFormat:@"%@%ld",@"tabIndentifer",section];
    static NSString *indentifer = @"tabIndentifer";
    FYHomeAppHeadView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:indentifer];
    if (!head) {
        head = [[FYHomeAppHeadView alloc]initWithReuseIdentifier:indentifer WithSection:section model:model isBusiness:isBusiness];
    }
    return head;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithSection:(NSInteger)section model:(HomeAppModel *)model isBusiness:(BOOL)isBusiness

{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView= [[UILabel alloc]init];
        lineView.backgroundColor = UIColorFromRGB(0xe1e6e6);
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.right.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
            make.height.mas_equalTo(0.5);
        }];
        
        if (isBusiness ==YES) {
            if (section ==0) {
                [self creatSectionOne:model WithSection:0];
            }
        }else
        {
            if (section ==0) {
                [self creatSectionOne:model WithSection:0];
            }else
            {
                [self creatSectionOther:model WithSection:section];
            }
        }
        
        
    }
    return  self;
}
-(void)creatSectionOne:(HomeAppModel*)model WithSection:(NSInteger)section
{
    UILabel *headTitleLabel = [[UILabel alloc]init];
    headTitleLabel.font = [UIFont boldSystemFontOfSize:17];
    headTitleLabel.text = @"秒推APP下载 【官方】";
    headTitleLabel.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:headTitleLabel];
  
    CGSize size =  [headTitleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:17] maxSize:CGSizeMake(SCREEN_WIDTH, 80)];
    [headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(size.height);
    }];
    //多少钱
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.text = @"20 元";
    [self.contentView addSubview:moneyLabel];

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:moneyLabel.text];
    
    [AttributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:25],NSFontAttributeName,UIColorFromRGB(0xff4c61),NSForegroundColorAttributeName, nil] range:NSMakeRange(0, moneyLabel.text.length -1)];
    
    [AttributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,UIColorFromRGB(0x666666),NSForegroundColorAttributeName, nil] range:NSMakeRange(moneyLabel.text.length -1, 1)];
    
    moneyLabel.attributedText = AttributedStr;
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headTitleLabel).offset(0);
        make.top.equalTo(headTitleLabel.mas_bottom).offset(8);
    }];
    [moneyLabel sizeToFit];
    
    //中间竖线
    UIView *shuView = [[UIView alloc]init];
    shuView.backgroundColor = UIColorFromRGB(0x545454);
    [self.contentView addSubview:shuView];
    
    [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(moneyLabel.mas_bottom).offset(-5);
        make.left.equalTo(moneyLabel.mas_right).offset(10);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(10);
    }];
    //剩余
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.font = Font(11);
    leftLabel.textColor = UIColorFromRGB(0x666666);
    leftLabel.text = @"剩余17次";
    [self.contentView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shuView.mas_centerY);
        make.left.equalTo(shuView.mas_right).offset(10);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(80);
    }];
    
    //剩余
    UILabel *timeOutLabel = [[UILabel alloc]init];
    timeOutLabel.font = Font(11);
    timeOutLabel.textColor = UIColorFromRGB(0x808080);
    timeOutLabel.text = @"10-28截止";
    timeOutLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeOutLabel];
    
    [timeOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_right).offset(-80);
        make.top.equalTo(leftLabel.mas_top).offset(0);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(10);
    }];

    
}
-(void)creatSectionOther:(HomeAppModel*)model WithSection:(NSInteger)section
{
    UIView *diotView = [[UIView alloc]init];
    diotView.backgroundColor = UIColorFromRGB(0xff4c61);
    diotView.layer.cornerRadius = 3;
    diotView.layer.masksToBounds = YES;
    [self.contentView addSubview:diotView];
    
    [diotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    UILabel *headLabel = [[UILabel alloc]init];
    headLabel.textColor = UIColorFromRGB(0x808080);
    headLabel.font = Font(15);
    headLabel.text = section ==1?@"任务介绍":@"任务步骤";
    [self.contentView addSubview:headLabel];
    
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(diotView.mas_right).offset(8);
        make.centerY.equalTo(self.contentView);
    }];
    [headLabel sizeToFit];
    
}
@end
