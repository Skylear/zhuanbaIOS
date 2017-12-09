//
//  SystemTableViewCell.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/9.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "SystemTableViewCell.h"

@implementation SystemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.titleLab];
    [self.baseView addSubview:self.detailLab];
    [self.baseView addSubview:self.mark];
}

-(UIView *)baseView{
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = [UIColor whiteColor];
        _baseView.cornerRadius = 5;
    }
    return _baseView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont boldSystemFontOfSize:16];
        _titleLab.textColor = UIColorFromRGB(0x333333);
    }
    return _titleLab;
}
-(UILabel *)detailLab{
    if (!_detailLab) {
        _detailLab = [UILabel new];
        _detailLab.font = Font(13);
        _detailLab.textColor = UIColorFromRGB(0x666666);
    }
    return _detailLab;
}
-(UIImageView *)mark{
    if (!_mark) {
        _mark = [UIImageView new];
        _mark.image = [UIImage imageNamed:@"arrows"];
    }
    return _mark;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.backgroundColor = kClearColor;
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font = Font(11);
        _timeLab.textColor = UIColorFromRGB(0x808080);
    }
    return _timeLab;
}

-(void)layoutSubviews{
    _baseView.frame = CGRectMake(12, 31, SCREEN_WIDTH-24, 72);
    _timeLab.frame = CGRectMake(12, 5,SCREEN_WIDTH-24 , 26);
    _titleLab.frame = CGRectMake(10, 15, _baseView.width-20, 16);
    _detailLab.frame = CGRectMake(10, _titleLab.bottom+15, _baseView.width-38.5, 13);
    _mark.frame = CGRectMake(_baseView.width-18.5, _titleLab.bottom+14, 6.5,  11.5);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
