//
//  ZZPhotoBrowerViewController.m
//  ZZPhotoKit
//
//  Created by 袁亮 on 16/5/27.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "ZZPhotoBrowerViewController.h"
#import "ZZPhotoBrowerCell.h"
#import "ZZPageControl.h"
#import "ZZPhoto.h"


@interface ZZPhotoBrowerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,assign)NSInteger currentInteger;
@property (strong, nonatomic) UIBarButtonItem             *selectedBtn;
@property(nonatomic,assign)BOOL scrollLeftOrRight;
@property (nonatomic, strong) UICollectionView *picBrowse;
@property (nonatomic, assign) NSInteger        numberOfItems;
@property (nonatomic, strong) UIBarButtonItem  *backBarButton;
@end

@implementation ZZPhotoBrowerViewController

-(UIBarButtonItem *)backBarButton
{
    if (!_backBarButton) {
        UIButton *back_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 44)];
        [back_btn setImage:[UIImage imageNamed:@"return_btn"] forState:UIControlStateNormal];
        [back_btn setImage:[UIImage imageNamed:@"return_btn"] forState:UIControlStateHighlighted];
        back_btn.size = CGSizeMake(70, 30);
        // 让按钮的内容往左边偏移10
        back_btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        // 让按钮内部的所有内容左对齐
        back_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [back_btn addTarget:self action:@selector(backItemMethod) forControlEvents:UIControlEventTouchUpInside];
        
        _backBarButton = [[UIBarButtonItem alloc] initWithCustomView:back_btn];
    }
    return _backBarButton;
}
/*
- (UIBarButtonItem *)selectedBtn{
    if (!_selectedBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.size = CGSizeMake(40, 40);
        
        // 让按钮的内容往左边偏移10
        [button setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
        [button setImageEdgeInsets:UIEdgeInsetsMake(10, 25, 10, -5)];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
        _selectedBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        
    }
    return _selectedBtn;
}
 */
-(void)backItemMethod
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) makeCollectionViewUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    /*
     *   创建核心内容 UICollectionView
     */
    self.view.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = (CGSize){self.view.frame.size.width,self.view.frame.size.height-64};
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _picBrowse = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _picBrowse.backgroundColor = [UIColor clearColor];
    _picBrowse.pagingEnabled = YES;
    
    _picBrowse.showsHorizontalScrollIndicator = NO;
    _picBrowse.showsVerticalScrollIndicator = NO;
    [_picBrowse registerClass:[ZZPhotoBrowerCell class] forCellWithReuseIdentifier:NSStringFromClass([ZZPhotoBrowerCell class])];
    _picBrowse.dataSource = self;
    _picBrowse.delegate = self;
    _picBrowse.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_picBrowse];
    
    NSLayoutConstraint *list_top = [NSLayoutConstraint constraintWithItem:_picBrowse attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *list_bottom = [NSLayoutConstraint constraintWithItem:_picBrowse attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *list_left = [NSLayoutConstraint constraintWithItem:_picBrowse attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *list_right = [NSLayoutConstraint constraintWithItem:_picBrowse attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f];
    
    [self.view addConstraints:@[list_top,list_bottom,list_left,list_right]];
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld",self.scrollIndex+1,self.photoData.count];
    self.navigationItem.leftBarButtonItem = self.backBarButton;
     self.navigationItem.rightBarButtonItem    = self.selectedBtn;
    [self makeCollectionViewUI];
    
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //滚动到指定位置
    
    [_picBrowse scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_scrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
}

#pragma mark --- UICollectionviewDelegate or dataSource
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photoData.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZPhotoBrowerCell *browerCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZZPhotoBrowerCell class]) forIndexPath:indexPath];

    if ([[_photoData objectAtIndex:indexPath.row] isKindOfClass:[ZZPhoto class]]) {
        //加载相册中的数据时实用
        ZZPhoto *photo = [_photoData objectAtIndex:indexPath.row];
        [browerCell loadPHAssetItemForPics:photo.asset];
    }

    return browerCell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //Selected index's color changed.
    static float newx = 0;
    static float oldIx = 0;
    newx= scrollView.contentOffset.x ;
    if (newx != oldIx) {
        //Left-YES,Right-NO
        if (newx > oldIx) {
            self.scrollLeftOrRight = NO;
        }else if(newx < oldIx){
            self.scrollLeftOrRight = YES;
        }
        oldIx = newx;
    }
   
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ZZPhotoBrowerCell class]]) {
        [(ZZPhotoBrowerCell *)cell recoverSubview];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger station = indexPath.row +1;
    if (self.scrollLeftOrRight ==NO) {
        _currentInteger =station+1;
        self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld",station+1,self.photoData.count];
    }else
    {
        _currentInteger =station-1;
        self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld",station-1,self.photoData.count];
    }

    if ([cell isKindOfClass:[ZZPhotoBrowerCell class]]) {
        [(ZZPhotoBrowerCell *)cell recoverSubview];
    }
}


-(void) showIn:(UIViewController *)controller
{
    [controller.navigationController pushViewController:self animated:YES];
}
//-(void)selectedBtn:(UIButton*)sender
//{
//    sender.selected = !sender.selected;
//    
//    ZZPhoto *photo = [self.photoData objectAtIndex:_currentInteger];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
