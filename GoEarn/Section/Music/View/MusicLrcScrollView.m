//
//  MusicLrcScrollView.m
//  Music
//
//  Created by hanlei on 16/7/21.
//  Copyright © 2016年 hanlei. All rights reserved.
//

#import "MusicLrcScrollView.h"

#import "MusicLrcCell.h"
#import "MusicLrcModel.h"
#import "MusicLrcLabel.h"
#import "MusicModel.h"

@interface MusicLrcScrollView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

/** 歌词的数据 */
@property (nonatomic,strong) NSArray *lrcArray;

/** 当前播放歌词的下标 */
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation MusicLrcScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

//类在IB中创建,在xocde中被实例化时被调用的
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.rowHeight = 35;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    //使用Autolayout
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView = tableView;
}

//内部调整子视图位置时调用
- (void)layoutSubviews
{
    [super layoutSubviews];
    //约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.mas_height);
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.height * 0.5, 0, self.bounds.size.height * 0.5, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicLrcCell *cell = [MusicLrcCell lrcCellWithTableView:tableView];
    
    if (self.currentIndex == indexPath.row) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:20];
    }else{
        cell.lrcLabel.font = [UIFont systemFontOfSize:14];
        cell.lrcLabel.progress = 0;
    }
    
    MusicLrcModel *lrcModel = self.lrcArray[indexPath.row];
    cell.lrcLabel.text = lrcModel.text;
    
    return cell;
}

- (void)setLrcName:(NSString *)lrcName
{
    //0.重置保存的当前位置的下标
    self.currentIndex = 0;
    
    //1.保存歌词名称
    _lrcName = [lrcName copy];
    
    //2.解析歌词
    self.lrcArray = [MusicLrcTool lrcWithName:lrcName];
    
    //3.刷新
    [self.tableView reloadData];
    
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    
    // 用当前时间和歌词进行匹配
    NSInteger count = self.lrcArray.count;
    for (int i = 0; i < count; i++) {
        // 1.拿到i位置的歌词
        MusicLrcModel *currentLrcLine = self.lrcArray[i];
        
        // 2.拿到下一句的歌词
        NSInteger nextIndex = i + 1;
        MusicLrcModel *nextLrcLine = nil;
        if (nextIndex < count) {
            nextLrcLine = self.lrcArray[nextIndex];
        }
        
        // 3.用当前的时间和i位置的歌词比较,并且和下一句比较,如果大于i位置的时间,并且小于下一句歌词的时间,那么显示当前的歌词
        if (self.currentIndex != i && currentTime >= currentLrcLine.time && currentTime < nextLrcLine.time) {
            
            // 1.获取需要刷新的行号
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            
            // 2.记录当前i的行号
            self.currentIndex = i;
            
            // 3.刷新当前的行,和上一行
            [self.tableView reloadRowsAtIndexPaths:@[indexPath, previousIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            // 4.显示对应句的歌词
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            // 5.设置外面歌词的Label的显示歌词
            self.lrcLabel.text = currentLrcLine.text;
            
            //6.生成锁屏界面的图片
            [self generatorLockImage];
        }
        
        // 4.根据进度,显示label画多少
        if (self.currentIndex == i) {
            // 4.1.拿到i位置的cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            MusicLrcCell *cell = (MusicLrcCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            // 4.2.更新label的进度
            CGFloat progress = (currentTime - currentLrcLine.time) / (nextLrcLine.time - currentLrcLine.time);
            cell.lrcLabel.progress = progress;
            
            // 4.3.设置外面歌词的Label的进度
            self.lrcLabel.progress = progress;
        }
    }
}
#pragma mark - 生成锁屏界面的图片
- (void)generatorLockImage
{
    //1.拿到当前图片
    MusicModel *playingMusic = [MusicTool playingMusic];
    UIImage *currentImage= [UIImage imageNamed:playingMusic.icon];
    //2.拿到歌词
    MusicLrcModel *currentLrc = self.lrcArray[self.currentIndex];
    
//    NSInteger previousIndex = self.currentIndex - 1;
//    MusicLrcModel *previousLrc = nil;
//    if (previousIndex >= 0) {
//        previousLrc = self.lrcArray[previousIndex];
//    }
    
    NSInteger nextIndex = self.currentIndex + 1;
    MusicLrcModel *nextLrc = nil;
    if (nextIndex < self.lrcArray.count) {
        nextLrc = self.lrcArray[nextIndex];
    }
    //3.生成水印图片
    UIGraphicsBeginImageContext(currentImage.size);
    //图片画上
    [currentImage drawInRect:CGRectMake(0, 0, currentImage.size.width, currentImage.size.height)];
    //歌词水印到图片上
    CGFloat titleH = 25;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    
//    [previousLrc.text drawInRect:CGRectMake(0, currentImage.size.height - titleH * 3, currentImage.size.width, titleH) withAttributes:[self settingDictWithFont:14 color:@"cbc0c4"]];
    
    [nextLrc.text drawInRect:CGRectMake(0, currentImage.size.height - titleH - 10, currentImage.size.width, titleH)  withAttributes:[self settingDictWithFont:17 color:@"cbc0c4"]];
    
    [currentLrc.text drawInRect:CGRectMake(0, currentImage.size.height - titleH * 2 -15, currentImage.size.width, titleH)  withAttributes:[self settingDictWithFont:17 color:@"fbf6fd"]];
    
    //4.生成图片
    UIImage *lockImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.设置锁屏信息
    [self setupLockScreenInfoWithLockImage:lockImage];
    //6.关闭
    UIGraphicsEndImageContext();
}

- (void)setupLockScreenInfoWithLockImage:(UIImage *)lockImage
{
    // 0.获取当前正在播放的歌曲
    MusicModel *playingMusic = [MusicTool playingMusic];
    
    // 1.获取锁屏界面中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    // 2.设置展示的信息
    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionary];
    [playingInfo setObject:playingMusic.name forKey:MPMediaItemPropertyAlbumTitle];
    [playingInfo setObject:playingMusic.singer forKey:MPMediaItemPropertyArtist];
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:lockImage];
    [playingInfo setObject:artWork forKey:MPMediaItemPropertyArtwork];
    [playingInfo setObject:@(self.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    [playingInfo setObject:@(self.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    playingInfoCenter.nowPlayingInfo = playingInfo;
    
    // 3.让应用程序可以接受远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (NSDictionary *)settingDictWithFont:(CGFloat )font color:(NSString *)color
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:font],
                                  NSForegroundColorAttributeName : [UIColor colorWithHexString:color],
                                  NSParagraphStyleAttributeName : style};
    return attributes;
}

@end
