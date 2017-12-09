//
//  UIImage+ProImage.m
//  PromotionApp
//
//  Created by app03 on 16/5/11.
//  Copyright © 2016年 app03. All rights reserved.
//

#import "UIImage+ProImage.h"
//current window
#define tyCurrentWindow [[UIApplication sharedApplication].windows lastObject]

@implementation UIImage (ProImage)


// 引用自stackflow
+ (NSString *)ty_getLaunchImageName
{
    NSString *viewOrientation = @"Portrait";
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        viewOrientation = @"Landscape";
    }
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    CGSize viewSize = tyCurrentWindow.bounds.size;
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return launchImageName;
}

+ (UIImage *)ty_getLaunchImage
{
    return [UIImage imageNamed:[self ty_getLaunchImageName]];
}
@end
