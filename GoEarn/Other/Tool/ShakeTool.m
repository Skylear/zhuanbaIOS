//
//  ShakeTool.m
//  MiaoChat
//
//  Created by Beyondream on 16/8/11.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "ShakeTool.h"
#import <AudioToolbox/AudioToolbox.h>


@interface ShakeTool (){
    NSArray *_patterns;
    NSMutableDictionary *_buff;
    bool _isRepeat;
}

void AudioServicesStopSystemSound(int);

void AudioServicesPlaySystemSoundWithVibration(int, id, NSDictionary *);

@end

@implementation ShakeTool
- (ShakeTool *)initWithPattern:(NSArray *)patterns{
    if ([super init]) {
        _patterns = [[NSMutableArray alloc] initWithArray:patterns copyItems:YES];
        _buff=nil;
        _isRepeat=NO;
    }
    return self;
}
- (ShakeTool *)initWithFile:(NSString *)file{
    if ([super init]) {
        _patterns = [NSMutableArray arrayWithContentsOfFile:file];
        _buff=nil;
        _isRepeat=NO;
    }
    return self;
}
- (ShakeTool *)initWithLoop:(NSUInteger)vibe pause:(NSUInteger)pause{
    if ([super init]) {
        MVibePattern *vibePattern = [MVibePattern PatternWithIntensity:0.3 time:vibe isVibe:YES];
        MVibePattern *pausePattern = [MVibePattern PatternWithIntensity:0.9 time:pause isVibe:NO];
        _patterns = @[vibePattern,pausePattern];
        _buff=nil;
        _isRepeat=YES;
    }
    return self;
}
- (void)play{
    [NSThread detachNewThreadSelector:@selector(loop) toTarget:self withObject:nil];
}
- (void)stop{
}
- (void)loop{
    NSUInteger i=0;
    while (YES) {

        MVibePattern *pattern = _patterns[i];
        if (!pattern.isV) {
        }
        else{
            [self prepareBuffWithPattern:pattern];
            [self performSelectorOnMainThread:@selector(systemPlay) withObject:nil waitUntilDone:NO];
        }
        [NSThread sleepForTimeInterval:pattern.time*1.0f/1000];
        i++;
        if (i==[_patterns count] && !_isRepeat) {
            break;
        }
        i=i%[_patterns count];
    }
}
- (void)prepareBuffWithPattern:(MVibePattern *)pattern{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSMutableArray* arr = [NSMutableArray array ];
    [arr addObject:[NSNumber numberWithBool:YES]]; //vibrate for 2000ms
    [arr addObject:[NSNumber numberWithInteger:pattern.time]];
    [dict setObject:arr forKey:@"VibePattern"];
    [dict setObject:[NSNumber numberWithFloat:pattern.intensity] forKey:@"Intensity"];
    _buff = dict;
}
- (void)systemPlay{

    AudioServicesStopSystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, _buff);
}
@end

@implementation MVibePattern

+ (MVibePattern *)PatternWithIntensity:(float)intensity time:(NSUInteger)time isVibe:(BOOL)isVibe{
    MVibePattern *pattern = [MVibePattern new];
    pattern.isV = isVibe;
    pattern.intensity = intensity;
    pattern.time = time;
    return pattern;
};

@end
