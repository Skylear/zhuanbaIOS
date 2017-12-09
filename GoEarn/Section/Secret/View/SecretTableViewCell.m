//
//  SecretTableViewCell.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/9/24.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "SecretTableViewCell.h"



@implementation SecretTableViewCell

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

-(void)createUI{
    [self.contentView addSubview:self.avaterIMG];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.detailLab];
    [self.contentView addSubview:self.mark];
    [self.contentView addSubview:self.bage];
    
}
-(GRBadgeButton *)bage{
    if (!_bage) {
        _bage = [GRBadgeButton new];
    }
    return _bage;
}

-(UIImageView *)avaterIMG{
    if (!_avaterIMG) {
        _avaterIMG = [[UIImageView alloc] init];
    }
    return _avaterIMG;
    
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = UIColorFromRGB(0x333333);
        _titleLab.font =[UIFont boldSystemFontOfSize:16];
        _titleLab.userInteractionEnabled = YES;
    }
    return _titleLab;
}

-(UILabel *)detailLab{
    if (!_detailLab) {
        _detailLab = [[UILabel alloc] init];
        _detailLab.textColor = UIColorFromRGB(0x999999);
        _detailLab.font = Font(12);
        _detailLab.userInteractionEnabled = YES;
    }
    return _detailLab;
    
}
-(UIImageView *)mark{
    if (!_mark) {
        _mark = [[UIImageView alloc] init];
        _mark.image = [UIImage imageNamed:@"arrows"];
    }
    return _mark;
}
-(void)layoutSubviews{
    _avaterIMG.frame = CGRectMake(12, 12, (self.height-24), (self.height-24));
    _avaterIMG.cornerRadius = (self.height-24)/2;
    _titleLab.frame = CGRectMake(_avaterIMG.right+10, 17, 100, 15);
    _detailLab.frame = CGRectMake(_avaterIMG.right+10, _titleLab.bottom+15, 200, 10);
    _mark.frame = CGRectMake(SCREEN_WIDTH-16.5, (self.height-11.5)/2, 6.5, 11.5);
//    _bage.frame = CGRectMake(_avaterIMG.right-10, _avaterIMG.top, 17, 17);
    _bage.center = CGPointMake(_avaterIMG.right-5, _avaterIMG.top+5);//角标
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
