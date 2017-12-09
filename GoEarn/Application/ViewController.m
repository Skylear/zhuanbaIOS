//
//  ViewController.m
//  GoEarn
//
//  Created by Beyondream on 2016/9/23.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *holdImg = [[UIImageView alloc]initWithFrame:KEYWINDOW.bounds];
    NSString *launchImageName = nil;
    //横屏请设置成 @"Landscape"
    NSString *viewOrientation = @"Portrait";
    NSArray *imagesDict =
    [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    //获取启动图片
    CGSize viewSize = KEYWINDOW.bounds.size;

    for (NSDictionary *dict in imagesDict)
        
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) &&
            [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    holdImg.image = [UIImage imageNamed:launchImageName];
    
    [self.view addSubview:holdImg];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
