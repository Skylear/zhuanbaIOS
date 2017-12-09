//
//  ShakeTool.h
//  MiaoChat
//
//  Created by Beyondream on 16/8/11.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShakeTool : NSObject

- (ShakeTool *)initWithPattern:(NSArray *)patterns;
- (ShakeTool *)initWithFile:(NSString *)file;
- (ShakeTool *)initWithLoop:(NSUInteger)vibe pause:(NSUInteger)pause;
- (void)play;
- (void)stop;
@end

@interface MVibePattern : NSObject

+ (MVibePattern *)PatternWithIntensity:(float)intensity time:(NSUInteger)time isVibe:(BOOL)isVibe;

@property (nonatomic) bool isV;

@property (nonatomic) float intensity;

@property (nonatomic) NSUInteger time;

@end