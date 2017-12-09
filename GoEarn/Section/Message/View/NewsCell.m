//
//  NewsCell.m
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/19.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import "NewsCell.h"
#import "ArticalModel.h"
#import "SDCycleScrollView.h"

@interface NewsCell ()<SDCycleScrollViewDelegate>
@property (nonatomic,strong)UIView *cycleImageView;
@property(nonatomic,strong)UIImageView *hdImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *readCount;



@end

@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self CreatUI:reuseIdentifier];
    }
    return self;
}
//文章详情
-(void)setModel:(ArticalModel *)model
{
    _model = model;
    if (model.ads)
    {
        [self creatCycleImageCell:model];

    }
    else
    {
    [self.hdImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:newList_default];
    //设置行距
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:model.title];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.title length])];
    [self.titleLabel setAttributedText:attributedString];
    
    [self.titleLabel alignTop];
    self.readCount.text =[NSString stringWithFormat:@"%@",model.view];
    self.timeLabel.text = model.time;
    }
}
/**
 *   滚动视图
 */
-(void)creatCycleImageCell:(ArticalModel*)newsModel
{
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.cycleImageView.bounds delegate:nil placeholderImage:placeholder_banner];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    //cycleScrollView.autoScroll = newsModel.adver_auto;
    cycleScrollView.titlesGroup = ({
        NSMutableArray *titleArrayM = [NSMutableArray array];
        for (int i = 0; i < newsModel.ads.count; i++)
        {
            ArticalModel *art = newsModel.ads[i];
            if (art.title) {
             [titleArrayM addObject:art.title];
            }else
            {
                [titleArrayM addObject:@""];
            }
            
        }
        titleArrayM;
    });
    
    cycleScrollView.imageURLStringsGroup = ({
        NSMutableArray *urlArrayM = [NSMutableArray array];
        for (int i = 0; i < newsModel.ads.count; i++) {
            ArticalModel *art = newsModel.ads[i];
            if (art.img) {
                [urlArrayM addObject:art.img];
            }else
            {
                [urlArrayM addObject:@""];
            }

        }
        urlArrayM;
    });
    
    [self.cycleImageView addSubview:cycleScrollView];
    cycleScrollView.delegate = self;

}
-(void)CreatUI:(NSString *)reuseIdentifier
{
    if ([reuseIdentifier isEqualToString:@"NewsCycleImageCell"])
    {
        self.cycleImageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
        [self addSubview:self.cycleImageView];
    }else
    {
    
    self.hdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 85*SCREEN_POINT, 80*SCREEN_POINT -20)];
    [self addSubview:self.hdImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.hdImageView.maxX+10, 8, SCREEN_WIDTH-self.hdImageView.maxX-20 *SCREEN_POINT, 40 *SCREEN_POINT)];
    self.titleLabel.font = Font(title_Font);
    self.titleLabel.textAlignment = NSTextAlignmentJustified;
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    [self addSubview:self.titleLabel];
    
    self.readCount = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.minX, self.hdImageView.maxY-16, 150, 20)];
    self.readCount.font = Font(comment_Font);
    self.readCount.textColor = UIColorFromRGB(0x999999);
    [self addSubview:self.readCount];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, self.hdImageView.maxY-15, 70, 20)];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = Font(minute_Font);
    self.timeLabel.textColor = UIColorFromRGB(0xa6a6a6);
    [self addSubview:self.timeLabel];
    //横线
    UILabel *linlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80*SCREEN_POINT-0.5, SCREEN_WIDTH, 0.5)];
    linlabel.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [self addSubview:linlabel];
    }
    
}
//标示符
+ (NSString *)cellReuseID:(ArticalModel *)newsModel;
{
    // 接口中，ads 和 imgextra 可能共同出现，所以有ads的就直接弄成轮播。
    if (newsModel.ads) {
        return @"NewsCycleImageCell"; // 轮播
    } else {
        return @"News_L_img_R_text_Cell"; // 左图右字
    }
}
//计算高
+ (CGFloat)cellForHeight:(ArticalModel *)newsModel
{
    if (newsModel.ads)
    {
        return SCREEN_WIDTH/2;
    }else
    {
    return 80 * SCREEN_POINT;
    }
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSAssert(self.cycleImageClickBlock, @"必须传入self.cycleImageClickBlock");
    ArticalModel *art = self.model.ads[index];
    self.cycleImageClickBlock(index,art);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
