//
//  SpreadCell.m
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/18.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import "SpreadCell.h"
#import "MessageListVC.h"
@implementation SpreadCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //		NSLog(@"%s", __func__);
    }
    return self;
}
-(void)setArt:(ArticalList *)art
{
    _newsVC = [[MessageListVC alloc]init];
    
    _newsVC.urlString = art.urlStr;
    
    _newsVC.titleID = [art.artID intValue];
    _newsVC.headTitle = art.title;
    [self addSubview:_newsVC.view];
}

@end
