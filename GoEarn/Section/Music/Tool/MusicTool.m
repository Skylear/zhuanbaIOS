//
//  MusicTool.m
//  Music
//
//  Created by hanlei on 16/7/21.
//  Copyright © 2016年 hanlei. All rights reserved.
//

#import "MusicTool.h"

@implementation MusicTool

static NSArray *_musics;
static MusicModel *_playingMusic;

+ (void)initialize
{
    if (_musics == nil) {
        _musics = [MusicModel objectArrayWithFilename:@"Musics.plist"];
    }
    
    if (_playingMusic == nil) {
        _playingMusic = _musics[1];
    }
}

+ (NSArray *)musics
{
    return _musics;
}

+ (MusicModel *)playingMusic
{
    return _playingMusic;
}

+ (void)setPlayingMusic:(MusicModel *)playingMusic
{
    _playingMusic = playingMusic;
}

+ (MusicModel *)nextMusic
{
    // 1.拿到当前播放歌词下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.取出下一首
    NSInteger nextIndex = ++currentIndex;
    if (nextIndex >= _musics.count) {
        nextIndex = 0;
    }
    MusicModel *nextMusic = _musics[nextIndex];
    
    return nextMusic;
}

+ (MusicModel *)previousMusic
{
    // 1.拿到当前播放歌词下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.取出下一首
    NSInteger previousIndex = --currentIndex;
    if (previousIndex < 0) {
        previousIndex = _musics.count - 1;
    }
    MusicModel *previousMusic = _musics[previousIndex];
    
    return previousMusic;
}

@end
