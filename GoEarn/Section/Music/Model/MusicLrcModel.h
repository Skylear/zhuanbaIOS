//
//  MusicLrcModel.h
//  Music
//
//  Created by hanlei on 16/7/22.
//  Copyright © 2016年 hanlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicLrcModel : NSObject

@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) NSTimeInterval time;

- (instancetype) initWithLrcString:(NSString *)lrcString;
+ (instancetype) lrcLineString:(NSString *)lrcLineString;

@end
