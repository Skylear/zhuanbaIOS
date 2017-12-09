//
//  AssertTableViewCell.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/9.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "AssertTableViewCell.h"


@implementation AssertTableViewCell

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
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.earnLab];
    [self.contentView addSubview:self.lineView];
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = UIColorFromRGB(0x333333);
        _titleLab.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLab;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.textColor = UIColorFromRGB(0x999999);
        _timeLab.font = Font(12);
    }
    return _timeLab;
}
-(UILabel *)earnLab{
    if (!_earnLab) {
        _earnLab = [UILabel new];
        _earnLab.textColor = UIColorFromRGB(0x333333);
        _earnLab.font = [UIFont boldSystemFontOfSize:16];
        _earnLab.textAlignment = NSTextAlignmentRight;
    }
    return _earnLab;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorFromRGB(0xe1e6e6);
    }
    return _lineView;
}
-(void)layoutSubviews{
    _titleLab.frame = CGRectMake(12,13, SCREEN_WIDTH*3/4, 16);
    _timeLab.frame = CGRectMake(12, _titleLab.bottom+15, SCREEN_WIDTH/2, 12);
    _earnLab.frame = CGRectMake(SCREEN_WIDTH-80, 0, 70, self.height);
    _lineView.frame = CGRectMake(0, self.height-0.5, SCREEN_WIDTH, 0.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
