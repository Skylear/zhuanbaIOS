

//
//  ShareFriendModel.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/11/2.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "ShareFriendModel.h"

@implementation ShareFriendModel

- (void)encodeWithCoder:(NSCoder *)encode{
    [encode encodeObject:self.img forKey:@"img"];
    [encode encodeObject:self.title forKey:@"title"];
    [encode encodeObject:self.desc forKey:@"desc"];
    [encode encodeObject:self.shareUrl forKey:@"shareUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self) {
        self.img = [decoder decodeObjectForKey:@"img"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.desc  = [decoder decodeObjectForKey:@"desc"];
        self.shareUrl = [decoder decodeObjectForKey:@"shareUrl"];
    }
    return self;
}

@end
