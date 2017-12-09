//
//  PersonTableViewCell.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/9.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell

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
    [self.contentView addSubview:self.avaterPic];
    [self.contentView addSubview:self.showLab];
    [self.contentView addSubview:self.mark];
    [self.contentView addSubview:self.lineView];
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = UIColorFromRGB(0x333333);
        _titleLab.font = Font(16);
    }
    return _titleLab;
}
-(UIImageView *)avaterPic{
    if (!_avaterPic) {
        _avaterPic = [UIImageView new];
    }
    return _avaterPic;
}
-(UILabel *)showLab{
    if (!_showLab) {
        _showLab = [UILabel new];
        _showLab.textAlignment = NSTextAlignmentRight;
        _showLab.textColor = UIColorFromRGB(0x999999);
    }
    return _showLab;
}
-(UIImageView *)mark{
    if (!_mark) {
        _mark = [UIImageView new];
        _mark.image = [UIImage imageNamed:@"arrows"];
    }
    return _mark;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorFromRGB(0xe1e6e6);
    }
    return _lineView;
}
-(void)layoutSubviews{
    _titleLab.frame = CGRectMake(12, 0, 100, self.height);
    _avaterPic.frame = CGRectMake(SCREEN_WIDTH-self.height-8.5, 10, self.height-20, self.height-20);
    _avaterPic.cornerRadius = (self.height-20)/2;
    _showLab.frame = CGRectMake(SCREEN_WIDTH/2-23.5, 0, SCREEN_WIDTH/2, self.height);
    _mark.frame = CGRectMake(SCREEN_WIDTH-18.5, (self.height-11.5)/2, 6.5,  11.5);
    _lineView.frame = CGRectMake(12, self.height-0.5, SCREEN_WIDTH-12, 0.5);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
