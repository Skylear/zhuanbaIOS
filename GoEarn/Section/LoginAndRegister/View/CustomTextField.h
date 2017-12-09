//
//  CustomTextField.h
//  writeApp
//
//  Created by miaomiaokeji on 16/8/25.
//  Copyright © 2016年 ios03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField

@property (nonatomic,strong) NSString  * Placeholder;
@property (nonatomic,assign) CGFloat titlefont;

-(instancetype)initWithFrame:(CGRect)frame font:(CGFloat)titleFont;
-(id)initWithFrame:(CGRect)frame Icon:(UIImageView*)icon;
@end
