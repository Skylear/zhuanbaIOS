//
//  Enght_Cell.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/12/20.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "Enght_Cell.h"

@implementation Enght_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self UI];
    }
    return self;
}

-(void)UI{
    [self.contentView addSubview:self.avaterIMG];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.IDLab];
    [self.contentView addSubview:self.MoneyLab];
    [self.contentView addSubview:self.LINE];
}

-(UIImageView *)avaterIMG{
    if (!_avaterIMG) {
        _avaterIMG = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avaterIMG.cornerRadius = 20;
    }
    return _avaterIMG;
}


-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = Font(15);
        _titleLab.textColor = UIColorFromRGB(0x333333);
    }
    return _titleLab;
}

-(UILabel *)IDLab{
    if (!_IDLab) {
        _IDLab = [[UILabel alloc] init];
        _IDLab.font = Font(12);
        _IDLab.textColor = UIColorFromRGB(0x999999);
    }
    return _IDLab;
}
-(UILabel *)MoneyLab{
    if (!_MoneyLab) {
        _MoneyLab = [[UILabel alloc] init];
        _MoneyLab.font = Font(18);
        _MoneyLab.textAlignment = NSTextAlignmentRight;
        _MoneyLab.textColor = UIColorFromRGB(0xff4c61);
    }
    return _MoneyLab;
}
-(UIView *)LINE{
    if (!_LINE) {
        _LINE = [[UIView alloc] init];
        _LINE.backgroundColor = UIColorFromRGB(0xe1e6e6);
    }
    return _LINE;
}



-(void)layoutSubviews{
    self.avaterIMG.frame  = CGRectMake(12, 10, self.height-20, self.height-20);
    self.titleLab.frame   = CGRectMake(self.avaterIMG.right+10, self.avaterIMG.top+2, 150, 20);
    self.IDLab.frame      = CGRectMake(self.avaterIMG.right+10, self.avaterIMG.bottom-15,150 , 10);
    self.MoneyLab.frame   = CGRectMake(SCREEN_WIDTH-70, (self.height-20)/2, 60, 20);
    self.LINE.frame       = CGRectMake(12, self.height-0.5, SCREEN_WIDTH-10, 0.5);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
