//
//  RegisterTextField.h
//  writeApp
//
//  Created by miaomiaokeji on 16/8/25.
//  Copyright © 2016年 ios03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterTextField : UITextField

@property (nonatomic,strong) NSString  * Placeholder;
-(id)initWithFrame:(CGRect)frame Icon:(UIImageView*)icon;
@end
