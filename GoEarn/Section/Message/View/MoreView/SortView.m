//
//  SortView.m
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/18.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import "SortView.h"
#import "SortCell.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "UIView+Extension.h"
#import "ArticalList.h"
static NSString * const reuseID = @"SortCell";

@interface SortView ()<LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *channelList;

@property(nonatomic,assign)NSInteger selectInteger;
@end

@implementation SortView
- (instancetype)initWithFrame:(CGRect)frame channelList:(NSMutableArray *)channelList withSelect:(NSInteger)selectIndex; {
    _channelList = channelList;
    self.selectInteger = selectIndex;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];        
        // 中间的排序collectionView,
        LXReorderableCollectionViewFlowLayout *flowLayout = [LXReorderableCollectionViewFlowLayout new];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10,
                                                                                              frame.size.width,
                                                                                              frame.size.height - 10 - 49)
                                                              collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[SortCell class] forCellWithReuseIdentifier:reuseID];
        [self addSubview:collectionView];
        
        // 设置cell的大小和细节,每排4个
        CGFloat margin = 10.0;
        CGFloat width  = ([UIScreen mainScreen].bounds.size.width - margin * 5) / 4.f;
        CGFloat height = width * 3.f / 7.f; // 按图片比例来的
        flowLayout.sectionInset = UIEdgeInsetsMake(5, margin, 10, margin);
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.minimumLineSpacing = 20;

    }
    return self;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _channelList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        SortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
       ArticalList *art = _channelList[indexPath.row];
        [cell.button setTitle:art.title forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    if (indexPath.row!=0) {
        // 在每个cell下面生成一个虚线的框框
        //[cell.button setBackgroundImage:[UIImage imageNamed:@"channel_sort_circle"] forState:UIControlStateNormal];
        UIButton *placeholderBtn = [[UIButton alloc] initWithFrame:cell.frame];
        //[placeholderBtn setBackgroundImage:[UIImage imageNamed:@"channel_sort_placeholder"] forState:UIControlStateNormal];
        placeholderBtn.width  -= 1;		placeholderBtn.centerX = cell.centerX;
        placeholderBtn.height -= 1;		placeholderBtn.centerY = cell.centerY;
        [collectionView insertSubview:placeholderBtn atIndex:0];
         }else
         {
             cell.button.backgroundColor = [UIColor clearColor];
         }
    if (indexPath.row!=self.selectInteger) {
         [cell.button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        }else
        {
            [cell.button setTitleColor:UIColorFromRGB(0xf23d3d) forState:UIControlStateNormal];
        }
        
        return cell;
}

#pragma mark LXReorderableCollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    ArticalList *artSelect = _channelList[self.selectInteger];
    ArticalList *art =_channelList[fromIndexPath.item];
    [_channelList removeObjectAtIndex:fromIndexPath.item];
    [_channelList insertObject:art atIndex:toIndexPath.item];
    for (int i=0; i<_channelList.count; i++) {
        ArticalList *ar = _channelList[i];
        if ([artSelect.title isEqualToString:ar.title]) {
            self.selectInteger = i;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (self.sortCompletedBlock) {
        self.sortCompletedBlock(_channelList,self.selectInteger);
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {return NO;}
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (fromIndexPath.row == 0 || toIndexPath.row == 0) {return NO;}
    return YES;
}
/** cell按钮点击事件 */
- (void)cellButtonClick:(UIButton *)button
{
    if (self.cellButtonClick) {
        self.cellButtonClick(button);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
