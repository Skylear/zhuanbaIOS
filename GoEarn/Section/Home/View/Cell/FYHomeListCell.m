//
//  FYHomeListCell.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/30.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "FYHomeListCell.h"

@implementation FYHomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView model:(HomeListCellModel *)model cellType:(NSInteger)cellType withIndexPath:(NSIndexPath*)indexPath
{
    NSString *tsID  = [NSString stringWithFormat:@"%@%ld",@"FYCellIndentifer",indexPath.row];
    FYHomeListCell *cell =  [[FYHomeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tsID model:model cellType:cellType];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(HomeListCellModel *)model cellType:(NSInteger)cellType
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        //图片
        self.headImg =  [[UIImageView alloc]init];
        [self.contentView addSubview:self.headImg];
        
        //标题
        self.headLabel = [[UILabel alloc]init];
        self.headLabel.font = [UIFont boldSystemFontOfSize:16];
        self.headLabel.textColor = UIColorFromRGB(0x333333);
        [self.contentView addSubview:self.headLabel];
        
        //多少钱
        
        self.moneyLabel = [[UILabel alloc]init];
        self.moneyLabel.font = Font(11);
        self.moneyLabel.textColor = UIColorFromRGB(0x666666);
        [self.contentView addSubview:self.moneyLabel];
        
        
        //线
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = UIColorFromRGB(0xe1e1e6);
        [self.contentView addSubview:lineView];
        
        //剩余
        self.leftLabel = [[UILabel alloc]init];
        self.leftLabel.font = Font(11);
        self.leftLabel.textColor = UIColorFromRGB(0x666666);
        [self.contentView addSubview:self.leftLabel];

        //剩余
        self.timeOutLabel = [[TimeLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -95, 80 -22, 80, 10) withAlign:NSTextAlignmentRight fromList:YES];
        self.timeOutLabel.font = Font(11);
        self.timeOutLabel.textColor = UIColorFromRGB(0x808080);
        [self.contentView addSubview:self.timeOutLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        switch (cellType) {
            case 1:
                [self creatUIWithNoraml:model];
                break;
            case 3:
                [self creatUIWithApp:model];
                break;
            case 2:
                [self creatUIWithArtical:model];
                break;
            case 4:
                [self creatUIWithApp:model];
                break;
            case 5:
                [self creatUIWithBussiness:model];
                
            default:
                break;
        }
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.top.equalTo(self.contentView).offset(12);
            make.bottom.equalTo(self.contentView).offset(-12);
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }];
        
        //中间竖线
        UIView *shuView = [[UIView alloc]init];
        shuView.backgroundColor = UIColorFromRGB(0x545454);
        [self.contentView addSubview:shuView];
        
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headLabel.mas_left).offset(0);
            make.bottom.equalTo(self.headImg).offset(-0.5);
            make.height.mas_equalTo(10);
        }];
        
        [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.moneyLabel.mas_right).offset(10);
            make.bottom.equalTo(self.headImg);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(10);
        }];
        
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shuView).offset(10);
            make.bottom.equalTo(self.headImg);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(10);
        }];
        
        [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.mas_right).offset(10);
            make.top.equalTo(self.headImg).offset(0);
            make.right.equalTo(self.contentView).offset(15);
            make.height.mas_equalTo(20);
        }];

        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
            make.height.mas_equalTo(0.5);
        }];
        
        
       
    }
    return self;
}
//商家
-(void)creatUIWithBussiness:(HomeListCellModel*)model
{
    self.headImg.layer.cornerRadius = 7;
    self.headImg.layer.masksToBounds = YES;
    [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg).offset(-3);
    }];

    self.headLabel.text = model.title;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:placeholder_list];
    [self setMoneyString:model.money];
    if ([model.status intValue] ==0) {
        self.timeOutLabel.text = [NSString stringWithFormat:@"%@%@",model.end_time,@"截止"];
    }else
    {
        NSDictionary *dateDic = [NSString dictionaryWithDateString:model.countdown];
        self.timeOutLabel.textColor =UIColorFromRGB(0xff4c61);
        self.timeOutLabel.text = [NSString stringWithFormat:@"进行中%02ld:%02ld",(long)[dateDic[@"min"] intValue],(long)[dateDic[@"sec"] intValue]];
        self.timeOutLabel.second = [dateDic[@"sec"] intValue];
        self.timeOutLabel.hour = [dateDic[@"hou"] intValue];
        self.timeOutLabel.minute = [dateDic[@"min"] intValue];
        self.timeOutLabel.timeString = @"进行中";
        self.timeOutLabel.timerBegain = YES;
    }
    self.leftLabel.text = [NSString stringWithFormat:@"%@%@%@",@"剩余",model.count,@"次"];
}
//App 特工
-(void)creatUIWithApp:(HomeListCellModel*)model
{
    self.headImg.layer.cornerRadius = 7;
    self.headImg.layer.masksToBounds = YES;
    //中间竖线
    UIView *shuView = [[UIView alloc]init];
    shuView.backgroundColor = UIColorFromRGB(0x545454);
    [self.contentView addSubview:shuView];
    
    [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImg.mas_right).offset(10);
        make.top.equalTo(self.headImg).offset(-15);
        make.right.equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headLabel.mas_left).offset(0);
        make.top.equalTo(self.headLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
    }];
    
    [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.mas_right).offset(10);
        make.top.equalTo(self.moneyLabel.mas_top).offset(3.5);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(10);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuView).offset(10);
        make.top.equalTo(self.moneyLabel.mas_top).offset(3.5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(10);
    }];
    
    self.timeOutLabel.textAlignment = NSTextAlignmentRight;
    [self.timeOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_right).offset(-90);
        make.top.equalTo(self.moneyLabel.mas_top).offset(0);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(15);
    }];
    
    self.headLabel.text = model.title;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:placeholder_list];
    [self setMoneyString:model.money];
    if ([model.status intValue] ==0) {
        self.timeOutLabel.text = [NSString stringWithFormat:@"%@%@",model.end_time,@"截止"];
    }else
    {
        NSDictionary *dateDic = [NSString dictionaryWithDateString:model.countdown];
        self.timeOutLabel.textColor =UIColorFromRGB(0xff4c61);
        self.timeOutLabel.text = [NSString stringWithFormat:@"进行中%02ld:%02ld",(long)[dateDic[@"min"] intValue],(long)[dateDic[@"sec"] intValue]];
        self.timeOutLabel.second = [dateDic[@"sec"] intValue];
        self.timeOutLabel.hour = [dateDic[@"hou"] intValue];
        self.timeOutLabel.minute = [dateDic[@"min"] intValue];
        self.timeOutLabel.timeString = @"进行中";
        self.timeOutLabel.timerBegain = YES;
    }
    self.leftLabel.text = [NSString stringWithFormat:@"%@%@%@",@"剩余",model.count,@"次"];
}
//文章
-(void)creatUIWithArtical:(HomeListCellModel*)model
{
    self.headImg.layer.cornerRadius = 7;
    self.headImg.layer.masksToBounds = YES;
    //中间竖线
    UIView *shuView = [[UIView alloc]init];
    shuView.backgroundColor = UIColorFromRGB(0x545454);
    [self.contentView addSubview:shuView];
    [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg).offset(-3);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headLabel.mas_left).offset(0);
        make.bottom.equalTo(self.headImg).offset(-0.5);
        make.height.mas_equalTo(10);
    }];
    
    [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.mas_right).offset(10);
        make.top.equalTo(self.moneyLabel).offset(0.5);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(10);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuView).offset(10);
        make.bottom.equalTo(self.headImg);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(10);
    }];
    
    self.timeOutLabel.textAlignment = NSTextAlignmentRight;
    [self.timeOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_right).offset(-80);
        make.top.equalTo(self.moneyLabel.mas_top).offset(0);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(15);
    }];

  
}
//公众号
-(void)creatUIWithNoraml:(HomeListCellModel*)model
{
    self.headImg.layer.cornerRadius = 27.5;
    self.headImg.layer.masksToBounds = YES;
    [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg).offset(-3);
    }];
    self.headLabel.text = model.title;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:placeholder_list];
    [self setMoneyString:model.money];
    if ([model.status intValue] ==0) {
       self.timeOutLabel.text = [NSString stringWithFormat:@"%@%@",model.end_time,@"截止"];
    }else
    {
        NSDictionary *dateDic = [NSString dictionaryWithDateString:model.countdown];
        self.timeOutLabel.textColor =UIColorFromRGB(0xff4c61);
        self.timeOutLabel.text = [NSString stringWithFormat:@"进行中%02ld:%02ld",(long)[dateDic[@"min"] intValue],(long)[dateDic[@"sec"] intValue]];
        self.timeOutLabel.second = [dateDic[@"sec"] intValue];
        self.timeOutLabel.hour = [dateDic[@"hou"] intValue];
        self.timeOutLabel.minute = [dateDic[@"min"] intValue];
        self.timeOutLabel.timeString = @"进行中";
        self.timeOutLabel.timerBegain = YES;
    }
    self.leftLabel.text = [NSString stringWithFormat:@"%@%@%@",@"剩余",model.count,@"次"];
    
}
//钱的内容
-(void)setMoneyString:(NSString *)moneyString
{
    NSString *text =[NSString stringWithFormat:@"%@%@",moneyString,@" 元"];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    [AttributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName,UIColorFromRGB(0xff4c61),NSForegroundColorAttributeName, nil] range:NSMakeRange(0, text.length -2)];
    
    [AttributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11],NSFontAttributeName,UIColorFromRGB(0x666666),NSForegroundColorAttributeName, nil] range:NSMakeRange(text.length -2, 2)];
    
    _moneyLabel.attributedText = AttributedStr;
    [_moneyLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
