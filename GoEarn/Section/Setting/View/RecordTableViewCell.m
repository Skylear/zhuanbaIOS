//
//  RecordTableViewCell.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/26.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "RecordTableViewCell.h"

@implementation RecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self updateUI];
    }
    return self;
}
-(void)updateUI{
    [self.contentView addSubview:self.avaterIMG];
    [self.contentView addSubview:self.NameLab];
    [self.contentView addSubview:self.IDLab];
    [self.contentView addSubview:self.moneyLab];
    [self.contentView addSubview:self.lineView];
    
}

-(UIImageView *)avaterIMG{
    if (!_avaterIMG) {
        _avaterIMG = [UIImageView new];
        _avaterIMG.image = [UIImage imageNamed:@"huhiu"];
        
    }
    return _avaterIMG;
}
-(UILabel *)NameLab{
    if (!_NameLab) {
        _NameLab = [UILabel new];
        _NameLab.textColor = UIColorFromRGB(0x333333);
        _NameLab.text = @"侧耳倾听";
        _NameLab.font = Font(13);
    }
    return _NameLab;
}
-(UILabel *)IDLab{
    if (!_IDLab) {
        _IDLab = [UILabel new];
        _IDLab.textColor = UIColorFromRGB(0x666666);
        _IDLab.font = Font(10);
        _IDLab.text = @"ID:15123487";
    }
    return _IDLab;
}
-(UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [UILabel new];
        _moneyLab.textColor = UIColorFromRGB(0xff4c61);
        _moneyLab.textAlignment = NSTextAlignmentRight;
        _moneyLab.font = Font(15);
        _moneyLab.text = @"+ 5 元";
    }
    return _moneyLab;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = MAINCOLOR;
    }
    return _lineView;
}

-(void)layoutSubviews{
    self.avaterIMG.frame = CGRectMake(10, 10, self.height-20, self.height-20);
    self.NameLab.frame = CGRectMake(self.avaterIMG.right+10, self.avaterIMG.top+5, 100, 13);
    self.IDLab.frame = CGRectMake(self.avaterIMG.right+10, self.NameLab.bottom+10, 100, 10);
    self.moneyLab.frame = CGRectMake(SCREEN_WIDTH-70, 0, 58,self.height);
    self.lineView.frame = CGRectMake(10, self.height-0.5, SCREEN_WIDTH-10, 0.5);
    self.avaterIMG.cornerRadius = self.avaterIMG.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
