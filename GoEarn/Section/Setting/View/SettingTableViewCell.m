//
//  SettingTableViewCell.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/9/26.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

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
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.PhoneLab];
    [self.contentView addSubview:self.mark];
    [self.contentView addSubview:self.line];
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = Font(15);
        _titleLab.textColor = UIColorFromRGB(0x545454);
    }
    return _titleLab;
}
-(UILabel *)PhoneLab{
    if (!_PhoneLab) {
        _PhoneLab = [UILabel new];
        _PhoneLab.textColor = UIColorFromRGB(0xff4c61);
        _PhoneLab.font = Font(14);
        _PhoneLab.textAlignment = NSTextAlignmentRight;
    }
    return _PhoneLab;
}
-(UIImageView *)mark{
    if (!_mark) {
        _mark = [UIImageView new];
        _mark.image = [UIImage imageNamed:@"arrows"];
    }
    return _mark;
}
-(UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = UIColorFromRGB(0xe1e6e6);
    }
    return _line;
}


-(void)layoutSubviews{
    _titleLab.frame = CGRectMake(15, 0, 100, self.height);
    _PhoneLab.frame = CGRectMake(SCREEN_WIDTH-150, 0, 125, self.height);
    _mark.frame = CGRectMake(SCREEN_WIDTH-18.5, (self.height-11.5)/2, 6.5, 11.5);
    _line.frame = CGRectMake(15, self.height-0.5, SCREEN_WIDTH-15, 0.5);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
