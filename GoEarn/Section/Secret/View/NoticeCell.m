//
//  NoticeCell.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/9.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell

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
//    [self.baseView addSubview:self.titleLab];
    [self.baseView addSubview:self.detailLab];

}
//底层view
-(UIView *)baseView{
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = [UIColor whiteColor];
        _baseView.cornerRadius = 5;
    }
    return _baseView;
}
//标题
//-(UILabel *)titleLab{
//    if (!_titleLab) {
//        _titleLab = [UILabel new];
//        _titleLab.font = [UIFont boldSystemFontOfSize:16];
//        _titleLab.textColor = UIColorFromRGB(0x333333);
//    }
//    return _titleLab;
//}
//说明
-(UILabel *)detailLab{
    if (!_detailLab) {
        _detailLab = [UILabel new];
        _detailLab.font = Font(15);
        _detailLab.numberOfLines = 0;
        _detailLab.textColor = UIColorFromRGB(0x666666);
    }
    return _detailLab;
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
-(void)setTextH:(CGFloat)textH{
    _textH = textH;
}

-(void)layoutSubviews{
    _baseView.frame = CGRectMake(12, 27, SCREEN_WIDTH-24, 15+_textH);
    _timeLab.frame = CGRectMake(12, 5,SCREEN_WIDTH-24 , 20);
//    _titleLab.frame = CGRectMake(10, 15, _baseView.width-20, 16);
    _detailLab.frame = CGRectMake(10, 5, _baseView.width-20, _textH);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
