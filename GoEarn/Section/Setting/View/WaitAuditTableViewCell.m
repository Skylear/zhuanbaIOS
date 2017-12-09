//
//  WaitAuditTableViewCell.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/14.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "WaitAuditTableViewCell.h"

@implementation WaitAuditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

-(void)createUI{
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.avater];
    [self.baseView addSubview:self.titleLab];
    [self.baseView addSubview:self.moneyLab];
    [self.baseView addSubview:self.shenyuLab];
    [self.baseView addSubview:self.auditLab];
    [self.baseView addSubview:self.line];
}

-(UIView *)baseView{
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = [UIColor whiteColor];
    }
    return _baseView;
}

-(UIImageView *)avater{
    if (!_avater) {
        _avater = [UIImageView new];
        _avater.image = [UIImage imageNamed:@"huhiu"];
    }
    return _avater;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = UIColorFromRGB(0x333333);
        _titleLab.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLab;
}

-(UILabel *)moneyLab{

    if (!_moneyLab) {
        _moneyLab = [UILabel new];
        _moneyLab.textColor = UIColorFromRGB(0x333333);
        _moneyLab.font = Font(15);
    }
    return _moneyLab;
}

-(UILabel *)shenyuLab{
    if (!_shenyuLab) {
        _shenyuLab = [UILabel new];
        _shenyuLab.textColor = UIColorFromRGB(0x666666);
        _shenyuLab.font = Font(13);
    }
    return _shenyuLab;
}

-(UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = UIColorFromRGB(0x333333);
    }
    return _line;
}
-(UILabel *)auditLab{
    if (!_auditLab) {
        _auditLab = [UILabel new];
        _auditLab.textColor = UIColorFromRGB(0xff4c61);
        _auditLab.font = Font(15);
    }
    return _auditLab;
}

-(void)layoutSubviews{
    self.baseView.frame = CGRectMake(0, 10, SCREEN_WIDTH, 80);
    self.avater.frame = CGRectMake(12, 12, self.baseView.height-24, self.baseView.height-24);
    self.titleLab.frame = CGRectMake(self.avater.right+15, self.avater.top+5, SCREEN_WIDTH/2-40, 15);
    self.moneyLab.frame = CGRectMake(self.avater.right+15, self.titleLab.bottom+15, 40, 15);
    self.line.frame = CGRectMake(self.moneyLab.right+5, self.titleLab.bottom+15, 0.5, 15);
    self.shenyuLab.frame = CGRectMake(self.line.right+5, self.titleLab.bottom+15, 60, 15);
    self.auditLab.frame = CGRectMake(SCREEN_WIDTH-62, self.titleLab.bottom+15, 50, 15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
