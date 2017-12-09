//
//  UIImage+Extension.h
//  JYJ微博
//
//  Created by JYJ on 15/3/11.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  返回拉伸图片
 */
+ (UIImage *)resizedImage:(NSString *)name;
/**
 *  用颜色返回一张图片
 */
+ (UIImage *)createImageWithColor:(UIColor*) color;
/**
 *  带边框的图片
 *
 *  @param name        图片名字
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  带边框的图片
 *
 *  @param image        图片
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
+ (instancetype)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


/**
 *  使用图像名创建图像视图
 *
 *  @param imageName 图像名称
 *
 *  @return UIImageView
 */
+ (instancetype)imageViewWithImageName:(NSString *)imageName;
/**
 *  获取图片类型
 */
+ (NSString *)typeForImageData:(NSData *)data;

// 图片剪切

- (UIImage*)clipImageinRect:(CGSize)size;
// 图片压缩

- (UIImage*)imagetargetWidth:(CGFloat)defineWidth;


//图片上绘制文字
+ (UIImage *)createShareImage:(NSString *)imageString TEXT:(NSString *)text;
//图片压缩
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//修改图片分辨率
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
