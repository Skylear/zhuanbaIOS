//
//  NoticeTableViewCell.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/9.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = YES;
        [self createUI];
    }
    return self;
}
-(void)Tap:(UIGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(NoticeTableViewCell: tapGestureRecogenize:)]) {
        [self.delegate NoticeTableViewCell:self tapGestureRecogenize:gesture];
        
    }
}
-(void)createUI{
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.titleLab];
    [self.baseView addSubview:self.PictureIMG];
    [self.baseView addSubview:self.lineView];
    [self.baseView addSubview:self.detailLab];
    [self.baseView addSubview:self.mark];
}

-(UIView *)baseView{
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.userInteractionEnabled = YES;
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
        _detailLab.userInteractionEnabled = YES;
        _detailLab.textColor = UIColorFromRGB(0x4c4c4c);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
        [_detailLab addGestureRecognizer:tap];
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
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = MAINCOLOR;
    }
    return _lineView;
}
-(UIImageView *)PictureIMG{
    if (!_PictureIMG) {
        _PictureIMG = [UIImageView new];
        _PictureIMG.image = [UIImage imageNamed:@"huhiu"];
    }
    return _PictureIMG;
}
-(void)layoutSubviews{
    _timeLab.frame = CGRectMake(12, 5,SCREEN_WIDTH-24 , 26);
    _baseView.frame = CGRectMake(12, _timeLab.bottom, SCREEN_WIDTH-24, 100+SCREEN_WIDTH*0.4);
    _titleLab.frame = CGRectMake(10, 15, _baseView.width-20, 16);
    _PictureIMG.frame = CGRectMake(10, _titleLab.bottom+15, _baseView.width-20,(_baseView.width-20)*0.44);
    _lineView.frame = CGRectMake(10, _PictureIMG.bottom+15, _baseView.width-20, 0.5);
    _detailLab.frame = CGRectMake(10, _lineView.bottom+15, _baseView.width-38.5, 15);
    _mark.frame = CGRectMake(_baseView.width-18.5, _lineView.bottom+14, 6.5,  11.5);
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
