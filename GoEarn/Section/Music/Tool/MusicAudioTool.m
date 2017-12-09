//
//  MusicAudioTool.m
//  Music
//
//  Created by hanlei on 16/7/21.
//  Copyright © 2016年 hanlei. All rights reserved.
//

#import "MusicAudioTool.h"

@implementation MusicAudioTool

static NSMutableDictionary *_soundDict;
static NSMutableDictionary *_playDict;


+ (void)initialize
{
    _soundDict = [NSMutableDictionary dictionary];
    _playDict = [NSMutableDictionary dictionary];
}

+ (AVAudioPlayer *)playMusicWithMusicName:(NSString *)musicName
{
    assert(musicName);

   static AVAudioPlayer *player = nil;
    player = _playDict[musicName];
    if (player == nil) {
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        if (fileUrl == nil)return nil;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
        [_playDict setObject:player forKey:musicName];
        [player prepareToPlay];
    }
    [player play];
    
    return player;
}

+ (void)pauseMusicWithMusicName:(NSString *)musicName
{
    assert(musicName);
    
    AVAudioPlayer *player = _playDict[musicName];
    
    if (player) {
        [player pause];
    }
}

+ (void)stopMusicWithMusicName:(NSString *)musicName
{
    assert(musicName);
    
    AVAudioPlayer *player = _playDict[musicName];
    
    if (player) {
        [player stop];
        [_playDict removeObjectForKey:musicName];
        player = nil;
    }
}

+ (void)playSoundWithSoundName:(NSString *)soundName
{
    SystemSoundID soundID = 0;
    soundID = [_soundDict[soundName]unsignedIntValue];
    if (soundID == 0) {
        CFURLRef url = CFBridgingRetain([[NSBundle mainBundle]URLForResource:soundName withExtension:nil]);
        AudioServicesCreateSystemSoundID(url, &soundID);
        [_soundDict setObject:@(soundID) forKey:soundName];
    }
    AudioServicesPlaySystemSound(soundID);
}

@end
