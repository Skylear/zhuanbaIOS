//
//  FYHomeAppCell.m
//  GoEarn
//
//  Created by Beyondream on 2016/10/10.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "FYHomeAppCell.h"

@implementation FYHomeAppCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(CGFloat)cellWithTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath model:(HomeAppModel *)model isBusiness:(BOOL)isBusiness{
    if (isBusiness) {
        if (indexPath.section ==0) {
            return 90;
        }else
        {
            return [@"用户要求 年龄：20-60岁，并且在银行有良好的诚信记录，用户要求 年龄：20-60岁，并且在银行有良好的诚信记录" sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH -20, MAXFLOAT)].height+20;
        }
    }else
    {
        if (indexPath.section ==0) {
            return 90;
        }else if (indexPath.section ==1)
        {
            return [@"用户要求 年龄：20-60岁，并且在银行有良好的诚信记录，用户要求 年龄：20-60岁，并且在银行有良好的诚信记录" sizeWithFont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(SCREEN_WIDTH -68, MAXFLOAT)].height+20;
        }else
        {
            CGFloat titleHeigh = [@"第一步" sizeWithFont:[UIFont boldSystemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH/2, MAXFLOAT)].height +40;
            if (indexPath.row ==0) {
                return [@"通过扫描下方二维码 - 下载APP，苹果手机扫描二维码后需要在Safari 中打开下载" sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH -68, MAXFLOAT)].height+20 +titleHeigh +10 +50;
            }else if (indexPath.row ==1)
            {
                return [@"下载完成后进行安装，完成注册后的截图" sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH -68, MAXFLOAT)].height+20 +20;
                
            }else if (indexPath.row ==2)
            {
                return [@"APP体验，试玩3分钟后，从这里" sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH -68, MAXFLOAT)].height+20 +20 +60;
            }else
            {
                return [@"提交任务，上传规定截图+资料，等待审核，发放佣金。" sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH -68, MAXFLOAT)].height+20 +20 ;
            }
        }
    }
}
+(instancetype)cellWithTableView:(UITableView *)tableView model:(HomeAppModel *)model WithIndexPath:(NSIndexPath *)indexPath isBusiness:(BOOL)isBusiness

{
    NSString *tsID =[NSString stringWithFormat:@"%@%ld%ld",@"cellid",indexPath.section,indexPath.row];
    FYHomeAppCell *cell = [tableView dequeueReusableCellWithIdentifier:tsID];
    if(cell == nil)
    {
        cell= [[FYHomeAppCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tsID model:model WithIndexPath:indexPath isBusiness:isBusiness];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(HomeAppModel *)model WithIndexPath:(NSIndexPath *)indexPath isBusiness:(BOOL)isBusiness
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        if (isBusiness ==YES) {
            if (indexPath.section ==0) {
                [self creatSectionOne:model];
            }
            else
            {
                [self creatSectionTwoBusiness:model];
            }
        }  else
        {
            if (indexPath.section ==0) {
                [self creatSectionOne:model];
            }else if (indexPath.section ==1)
            {
                [self creatSectionTwo:model];
            }else
            {
                [self creatSectionOther:model WithIndexPath:indexPath];
            }
 
        }
    }
    return self;
}

-(void)creatSectionTwoBusiness:(HomeAppModel*)model
{
    UILabel *infoLabel = [UILabel labelWithTitle:@"用户要求 年龄：20-60岁，并且在银行有良好的诚信记录，用户要求 年龄：20-60岁，并且在银行有良好的诚信记录" color:UIColorFromRGB(0x444444) font:Font(14)];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    [infoLabel sizeToFit];
}

-(void)creatSectionOne:(HomeAppModel*)model{
    NSArray *arr = @[@"任务总数：",@"任务限制：",@"审核时间："];
    NSArray *infoArr =@[@"100次",@"每人一次",@"完成即发佣金"];
    for (int i=0; i<3; i++)
    {
        UILabel *label = [[UILabel alloc]init];
        label.font  = Font(14);
        label.text = [NSString stringWithFormat:@"%@%@",arr[i],infoArr[i]];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
        
        [AttributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x8c8c8c),NSForegroundColorAttributeName, nil] range:NSMakeRange(0, 5)];

        [AttributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x444444),NSForegroundColorAttributeName, nil] range:NSMakeRange(6, label.text.length -6)];
        
        label.attributedText = AttributedStr;
        
        [self.contentView addSubview:label];
        
        CGSize size = [label.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH -15, 30)];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset((size.height +5)*i+15);
            make.size.mas_equalTo(size);
        }];
        
        
    }
}
-(void)creatSectionTwo:(HomeAppModel*)model{
    UILabel *label = [[UILabel alloc]init];
    label.font  = Font(18);
    label.text = @"用户要求 年龄：20-60岁，并且在银行有良好的诚信记录，用户要求 年龄：20-60岁，并且在银行有良好的诚信记录";
    label.numberOfLines = 0;
    label.textColor = UIColorFromRGB(0x444444);
    [self.contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(34);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH -68);
    }];
    [label sizeToFit];
}
-(void)creatSectionOther:(HomeAppModel*)model WithIndexPath:(NSIndexPath *)indexPath
{
    //前 号码
    UILabel *numberLabel = [[UILabel alloc]init];
    numberLabel.font = Font(10);
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row +1];
    numberLabel.textColor = UIColorFromRGB(0x666666);
    numberLabel.layer.cornerRadius = 8;
    numberLabel.clipsToBounds = YES;
    numberLabel.layer.borderWidth = 1;
    numberLabel.layer.borderColor = UIColorFromRGB(0xe8eced).CGColor;
    [self.contentView addSubview:numberLabel];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        if (indexPath.row ==0) {
            make.top.equalTo(self.contentView).offset(15);
        }else
        {
            make.top.equalTo(self.contentView).offset(0);
        }
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    //竖线
    if (indexPath.row<3) {
        UIView *shuView = [[UIView alloc]init];
        shuView.backgroundColor = UIColorFromRGB(0xe8eced);
        [self.contentView addSubview:shuView];
        
        [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(numberLabel.mas_bottom);
            make.left.equalTo(numberLabel.mas_centerX);
            make.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(0.5);
        }];
    }
    NSArray *tipArr = @[@"第一步",@"第二步",@"第三步",@"第四步",];
    //步骤
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.font = [UIFont boldSystemFontOfSize:15];
    tipLabel.textColor = UIColorFromRGB(0x444444);
    tipLabel.text = tipArr[indexPath.row];
    [self.contentView addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberLabel);
        make.left.equalTo(numberLabel.mas_right).offset(6);
    }];
    [tipLabel sizeToFit];
    
    
    NSArray *infoArr = @[@"通过扫描下方二维码 - 下载APP，苹果手机扫描二维码后需要在Safari 中打开下载",
                         @"下载完成后进行安装，完成注册后的截图",
                         @"APP体验，试玩3分钟后，从这里",
                         @"提交任务，上传规定截图+资料，等待审核，发放佣金。"];
    //文字说明
    UILabel *infoTXT = [UILabel labelWithTitle:infoArr[indexPath.row] color:UIColorFromRGB(0x444444) font:[UIFont systemFontOfSize:14] alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:infoTXT];
    
    [infoTXT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLabel);
        make.top.equalTo(tipLabel.mas_bottom).offset(6);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:infoTXT.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [infoTXT.text length])];
    [infoTXT setAttributedText:attributedString];
    
    [infoTXT sizeToFit];
    
    if (indexPath.row ==0) {
        UIImageView *qrView = [[UIImageView alloc]init];
        qrView.image = [UIImage imageNamed:@"2013011.jpg"];
        [self.contentView addSubview:qrView];
        
        self.imgView = qrView;
        
        [qrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infoTXT.mas_bottom).offset(15);
            make.left.equalTo(infoTXT);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }if (indexPath.row ==2) {
        UIButton *openApp = [UIButton buttonWithType:UIButtonTypeCustom];
        openApp.layer.cornerRadius = 3.0f;
        openApp.clipsToBounds = YES;
        openApp.layer.borderWidth = 1.0f;
        openApp.layer.borderColor = UIColorFromRGB(0xff4c61).CGColor;
        [openApp setTitleColor: UIColorFromRGB(0xff4c61) forState:UIControlStateNormal];
        [openApp setTitle:@"打开APP" forState:UIControlStateNormal];
        [self.contentView addSubview:openApp];
        
        [openApp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(infoTXT);
            make.top.equalTo(infoTXT.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH -68, 40));
        }];
        
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
