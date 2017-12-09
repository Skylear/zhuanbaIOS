//
//  MusicLrcModel.m
//  Music
//
//  Created by hanlei on 16/7/22.
//  Copyright © 2016年 hanlei. All rights reserved.
//

#import "MusicLrcModel.h"

@implementation MusicLrcModel

- (instancetype) initWithLrcString:(NSString *)lrcString
{
    if (self = [super init]) {
        // [01:05.43]我想就这样牵着你的手不放开
        NSArray *lrcArray = [lrcString componentsSeparatedByString:@"]"];
        self.text = lrcArray[1];
        NSString *timeString = lrcArray[0];
        self.time = [self timeStringWithString:[timeString substringFromIndex:1]];
    }
    return self;
}

+ (instancetype) lrcLineString:(NSString *)lrcLineString
{
    return [[self alloc] initWithLrcString:lrcLineString];
}

- (NSTimeInterval)timeStringWithString:(NSString *)timeString
{
    // 01:05.43
    NSInteger min = [[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger second = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger haomiao = [[timeString componentsSeparatedByString:@"."][1] integerValue];
    
    return (min * 60 + second + haomiao * 0.01);
}

@end
