//
//  MusicAudioTool.h
//  Music
//
//  Created by hanlei on 16/7/21.
//  Copyright © 2016年 hanlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicAudioTool : NSObject

+ (AVAudioPlayer *)playMusicWithMusicName:(NSString *)musicName;

+ (void)pauseMusicWithMusicName:(NSString *)musicName;

+ (void)stopMusicWithMusicName:(NSString *)musicName;

+ (void)playSoundWithSoundName:(NSString *)soundName;

@end
