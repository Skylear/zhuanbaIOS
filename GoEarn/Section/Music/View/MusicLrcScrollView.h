//
//  MusicLrcScrollView.h
//  Music
//
//  Created by hanlei on 16/7/21.
//  Copyright © 2016年 hanlei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicLrcLabel;

@interface MusicLrcScrollView : UIScrollView

@property (nonatomic,copy) NSString *lrcName;

/** 当前播放的时间 */
@property (nonatomic,assign) NSTimeInterval currentTime;

/** 外面歌词的Label */
@property (nonatomic, weak) MusicLrcLabel *lrcLabel;

/** 当前歌曲的总时长 */
@property (nonatomic, assign) NSTimeInterval duration;

@end
