//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */


#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"
@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        //[self setbgView];
        //[self setupTitleLabel];
    }
    
    return self;
}
/*
- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}
-(void)setbgView
{
    UIView *bg = [[UIView alloc]init];
    _bgView = bg;
    [self.contentView addSubview:bg];
    
}
 */
- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}
/*
- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
}

*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    if (self.onlyDisplayText) {
//        _titleLabel.frame = self.bounds;
//    } else {
        _imageView.frame = self.bounds;
    /*
        CGFloat titleLabelW = self.sd_width;
        CGFloat titleLabelH = _titleLabelHeight;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = self.sd_height - titleLabelH;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW-40, titleLabelH);
        
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(_titleLabel.maxX, titleLabelY, 40, titleLabelH)];
        rightView.backgroundColor = [UIColor clearColor];
        [self addSubview:rightView];
        
        _bgView.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
        UIColor *colorOne = [UIColor colorWithRed:0  green:0  blue:0  alpha:0.45];
        UIColor *colorTwo = [UIColor colorWithRed:0  green:0  blue:0  alpha:0];
        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor,  nil];
        CAGradientLayer *headerLayer = [CAGradientLayer layer];
        headerLayer.colors = colors;
        headerLayer.startPoint = CGPointMake(0, 1);
        
        headerLayer.endPoint = CGPointMake(1, 1);
        headerLayer.frame = _bgView.bounds;
        
        [_bgView.layer insertSublayer:headerLayer atIndex:0];

    }
     */
}

@end
