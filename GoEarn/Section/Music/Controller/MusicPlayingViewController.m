//
//  MusicPlayingViewController.m
//  Music
//
//  Created by hanlei on 16/7/21.
//  Copyright © 2016年 hanlei. All rights reserved.
//

#import "MusicPlayingViewController.h"
#import "MusicLrcScrollView.h"
#import "MusicModel.h"
#import "MusicLrcLabel.h"
#import "LLShareSDKTool.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import  "WXApi.h"
#import "WeiboSDK.h"
#import "MIAOShareView.h"
#define XMGColor(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0])

@interface MusicPlayingViewController ()<UIScrollViewDelegate,AVAudioPlayerDelegate>
{
    SSDKPlatformType type;
}
@property (strong, nonatomic) UIImageView *albumView;
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *songLabel;
@property (strong, nonatomic) UILabel *singerLabel;
@property (strong, nonatomic) UILabel *currentTimeLabel;
@property (strong, nonatomic) UILabel *totalTimeLabel;
@property (strong, nonatomic) UISlider *progressSlider;
@property (strong, nonatomic)UIButton *playOrPauseBtn;

@property (strong, nonatomic) MusicLrcLabel *lrcLabel;
@property (strong, nonatomic) MusicLrcScrollView *lrcView;

/** 进度定时器 */
@property (nonatomic,strong) NSTimer *progressTimer;

/** 歌词更新定时器*/
@property (nonatomic,strong) CADisplayLink *lrcTimer;

/** 当前播放器 */
@property (nonatomic,weak) AVAudioPlayer *currentPlayer;

@end

@implementation MusicPlayingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatUI];
    
    // 设置iconView圆角
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderWidth = 8.0;
    self.iconView.layer.borderColor = XMGColor(36, 36, 36).CGColor;
    // 1.添加毛玻璃效果
    [self setupBlurView];
    
    // 2.设置滑块的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    // 3.展示界面的信息
    [self startPlayingMusic];
    
    //4.设置歌词
    self.lrcView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    self.lrcView.lrcLabel = self.lrcLabel;
}
-(void)creatUI
{
    self.albumView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.albumView.backgroundColor = [UIColor whiteColor];
    self.albumView.image = [UIImage imageNamed:@"lkq.jpg"];
    [self.view addSubview:self.albumView];
    
    //顶部view
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
     [self.view addSubview:headView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(15, 25, 40, 40)];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [backBtn setImage:[UIImage imageNamed:@"miniplayer_btn_playlist_close_b"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(SCREEN_WIDTH - 55, 25, 40, 40)];
    [shareBtn setImage:[UIImage imageNamed:@"main_tab_more"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:shareBtn];
    
    
    self.songLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, SCREEN_WIDTH -200, 20)];
    self.songLabel.font = Font(17);
    self.songLabel.textColor = [UIColor whiteColor];
    self.songLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:self.songLabel];
    
    self.singerLabel =[[UILabel alloc]initWithFrame:CGRectMake(100, self.songLabel.maxY, SCREEN_WIDTH -200, 20)];
    self.singerLabel.textColor = [UIColor whiteColor];
    self.singerLabel.font = Font(14);
    self.singerLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:self.singerLabel];
    
    
    self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(30,self.view.centerY -(SCREEN_WIDTH-60)/2-50, SCREEN_WIDTH-60, SCREEN_WIDTH-60)];
    self.iconView.image = [UIImage imageNamed:@"lkq.jpg"];
    [self.view addSubview:self.iconView];
    
    self.lrcView = [[MusicLrcScrollView alloc]initWithFrame:CGRectMake(0, headView.maxY, SCREEN_WIDTH,SCREEN_HEIGHT- 220)];
    self.lrcView.scrollEnabled = YES;
    self.lrcView.pagingEnabled = YES;
    self.lrcView.bounces = YES;
    self.lrcView.delegate = self;
    [self.view addSubview:self.lrcView];
    
    // 底部view
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 150, SCREEN_WIDTH, 150)];
    
    self.playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playOrPauseBtn.frame = CGRectMake(SCREEN_WIDTH/2-32, 30+43, 64, 64);
    [self.playOrPauseBtn setImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:UIControlStateNormal];
    [self.playOrPauseBtn setImage:[UIImage imageNamed:@"player_btn_pause_normal"] forState:UIControlStateSelected];
    [self.playOrPauseBtn addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:self.playOrPauseBtn];
    
    
    UIButton *upSongBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    upSongBtn.frame = CGRectMake(self.playOrPauseBtn.minX -80, 30+50, 50, 50);
    [upSongBtn setImage:[UIImage imageNamed:@"player_btn_pre_normal"] forState:UIControlStateNormal];
    [upSongBtn addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:upSongBtn];
    
    UIButton *nextBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(self.playOrPauseBtn.maxX +30, 30+50, 50, 50);
    [nextBtn setImage:[UIImage imageNamed:@"player_btn_next_normal"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:nextBtn];
    
    [self.view addSubview:footView];
    
    self.lrcLabel = [[MusicLrcLabel alloc]init];
    self.lrcLabel.textAlignment = NSTextAlignmentCenter;
    self.lrcLabel.frame = CGRectMake(0, footView.minY - 20, SCREEN_WIDTH, 20);
    self.lrcLabel.textColor = [UIColor whiteColor];
    self.lrcLabel.font = Font(15);
    [self.view addSubview:self.lrcLabel];
    
    self.currentTimeLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, self.playOrPauseBtn.minY -40, 50, 16)];
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.font = Font(13);
    self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:self.currentTimeLabel];
    
    self.totalTimeLabel =[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, self.playOrPauseBtn.minY -40, 50, 16)];
    self.totalTimeLabel.textColor = [UIColor whiteColor];
    self.totalTimeLabel.font = Font(13);
    self.totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:self.totalTimeLabel];
    
    self.progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(50, self.totalTimeLabel.centerY-9, SCREEN_WIDTH -100, 18)];
    self.progressSlider.minimumTrackTintColor = UIColorFromRGB(0x26b253);
    self.progressSlider.value = 0;
    self.progressSlider.minimumValue = 0;
    self.progressSlider.maximumValue = 1;
    [footView addSubview:self.progressSlider];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderClick:)];
    [self.progressSlider addGestureRecognizer:gesture];
    
    [self.progressSlider addTarget:self action:@selector(startSlide) forControlEvents:UIControlEventTouchDown];
    [self.progressSlider addTarget:self action:@selector(endSlide) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventTouchUpOutside];
    
    
}
-(void)shareBtnClick:(UIButton*)sender
{
    MIAOShareView * share = [MIAOShareView creatXib];
    
    [share setGetTouch:^(NSInteger BTNTag) {
        [self getTag:BTNTag];
    }];
    [share show];
}
-(void)getTag:(NSInteger)tag
{
    if (tag==6) {
        //复制链接
        [self copyLianjia];
    }else{
        type =  SSDKPlatformTypeUnknown;
        switch (tag) {
            case 1:
                type = SSDKPlatformSubTypeWechatSession;
                break;
            case 2:
                type = SSDKPlatformSubTypeWechatTimeline;
                break;
            case 3:
                type = SSDKPlatformTypeSinaWeibo ;
                break;
            case 4:
                type = SSDKPlatformSubTypeQQFriend;
                break;
            case 5:
                type = SSDKPlatformSubTypeQZone;
                break;
            case 6:
                
                break;
                
            default:
                break;
        }
        
        //创建分享参数
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKEnableUseClientShare];
        
        MusicModel *playingMusic = [MusicTool playingMusic];
        NSURL *url = [NSURL URLWithString:@"http://m.mt.miaomiao.tm"];
        GRLog(@"-------%@",url);
        
        [shareParams SSDKSetupShareParamsByText:playingMusic.name
                                         images:playingMusic.icon
                                            url:url
                                          title:playingMusic.singer
                                           type: SSDKContentTypeAuto ];
        //进行分享
        [ShareSDK share:type
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             
             switch (state) {
                 case SSDKResponseStateSuccess:
                 {
                     [MBProgressHUD showMessage:@"分享成功"];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {  //判断是否有微信
                     if ([WXApi isWXAppInstalled]||[QQApiInterface isQQInstalled]) {
                         
                         
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                     }
                     else{
                         
                         if (tag==1||tag==2) {
                             [MBProgressHUD showMessage:@"未安装微信,无法分享"];
                         }else if (tag==4||tag==5){
                             
                             [MBProgressHUD showMessage:@"未安装QQ,无法分享"];
                         }
                     }
                     break;
                 }
                 case SSDKResponseStateCancel:
                 {
                     
                     [MBProgressHUD showMessage:@"分享取消"];
                     break;
                     
                 }
                 default:
                     break;
             }
         }];
    }
}
-(void)copyLianjia{
    
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"http://m.mt.miaomiao.tm";
        if (pasteboard.string) {
            [MBProgressHUD showMessage:@"复制链接成功!"];
        }else{
            [MBProgressHUD showMessage:@"复制链接失败!"];
        }
}

- (void)setupBlurView
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar setBarStyle:UIBarStyleBlack];
    [self.albumView addSubview:toolBar];
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.albumView);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 开始播放音乐
/** 播放音乐*/
- (void)startPlayingMusic
{
    // 1.取出当前播放歌曲
    MusicModel *playingMusic = [MusicTool playingMusic];
    
    // 2.设置界面信息
    self.albumView.image = [UIImage imageNamed:playingMusic.icon];
    self.iconView.image = [UIImage imageNamed:playingMusic.icon];
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    
    // 3.开始播放歌曲
    AVAudioPlayer *currentPlayer = [MusicAudioTool playMusicWithMusicName:playingMusic.filename];
    currentPlayer.delegate = self;
    self.totalTimeLabel.text = [NSString stringWithTime:currentPlayer.duration];
    self.currentTimeLabel.text = [NSString stringWithTime:currentPlayer.currentTime];
    self.currentPlayer = currentPlayer;
    self.playOrPauseBtn.selected = self.currentPlayer.isPlaying;
    
    //4.设置歌词
    self.lrcView.lrcName = playingMusic.lrcname;
    self.lrcLabel.text = @"";
    self.lrcView.duration = currentPlayer.duration;
    //5.开始播放动画
    [self startIconViewAnimate];
    
    //6.添加定时器更新进度 先移除在添加 保证切歌
    [self removeProgressTimer];
    [self addProgressTimer];
    [self removeLrcTimer];
    [self addLrcTimer];

}

- (void)startIconViewAnimate
{
    //1.创建基本动画
    CABasicAnimation *rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //2.设置属性
    rotateAnim.fromValue = @(0);
    rotateAnim.toValue = @(M_PI * 2);
    rotateAnim.repeatCount = NSIntegerMax;
    rotateAnim.duration = 40;
    //3.添加动画到图上
    [self.iconView.layer addAnimation:rotateAnim forKey:nil];
}

#pragma mark - 进度定时器
- (void)addProgressTimer
{
    [self updateProgerssInfo];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgerssInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

#pragma mark - 更新进度
- (void) updateProgerssInfo
{
    //1.设置当前的播放时间
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    
    //2.更新滑块的位置
    self.progressSlider.value = self.currentPlayer.currentTime / self.currentPlayer.duration;
    
}

#pragma mark - 歌词定时器
- (void)addLrcTimer
{
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

#pragma mark - 更新歌词
- (void)updateLrc
{
    self.lrcView.currentTime = self.currentPlayer.currentTime;
}

#pragma mark - Slider的事件处理
- (void)startSlide {
    [self removeProgressTimer];
}

- (void)sliderValueChange {
    //1.设置当前播放时间的label
    self.currentTimeLabel.text = [NSString stringWithTime:(self.currentPlayer.duration * self.progressSlider.value)];
}

- (void)endSlide {
    //1.设置歌曲的播放时间
    self.currentPlayer.currentTime = self.progressSlider.value * self.currentPlayer.duration;

    //2.添加定时
    [self addProgressTimer];
}
#pragma mark tap手势操作
- (void)sliderClick:(UITapGestureRecognizer *)sender {
    //1.获取点击位置
    CGPoint point = [sender locationInView:sender.view];
    //2.获取点击的slider长度中占据的比例
    CGFloat ratio = point.x / self.progressSlider.bounds.size.width;
    //3.改变歌曲播放事件
    self.currentPlayer.currentTime = ratio * self.currentPlayer.duration;
    //4.更改进度
    [self updateProgerssInfo];
}

#pragma mark - 歌曲控制事件处理
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
    
    if (self.currentPlayer.playing) {
        [self.currentPlayer pause];
        
        [self removeProgressTimer];
        [self removeLrcTimer];
        
        // 暂停iconView的动画
        [self.iconView.layer pauseAnimate];
    } else {
        [self.currentPlayer play];
        
        [self addProgressTimer];
        [self addLrcTimer];
        
        // 恢复iconView的动画
        [self.iconView.layer resumeAnimate];
    }

}

- (void)previous {
    [self playingMusicWithMusic:[MusicTool previousMusic]];
}

- (void)next {
    
    [self playingMusicWithMusic:[MusicTool nextMusic]];
}

- (void)playingMusicWithMusic:(MusicModel *)music
{
    //1.停止当前歌曲
    MusicModel *palying = [MusicTool playingMusic];
    [MusicAudioTool stopMusicWithMusicName:palying.filename];
    
    //3.播放歌曲
    [MusicAudioTool playMusicWithMusicName:music.filename];
    
    //4.将当前歌曲切换成播放的歌曲
    [MusicTool setPlayingMusic:music];
    
    //5.改变界面信息
    [self startPlayingMusic];
}

#pragma mark  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //1.获取滑动多少
    CGPoint point = scrollView.contentOffset;
    //2.计算滑动比例
    CGFloat ratio = 1 - point.x / scrollView.bounds.size.width;
    //3.设置view属性
    self.iconView.alpha = ratio;
    self.lrcLabel.alpha = ratio;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self next];
    }
}

#pragma mark - 监听远程事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playOrPause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self next];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previous];
            break;
        default:
            break;
    }
}

-(void)backBtnClick:(UIButton*)sender
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
