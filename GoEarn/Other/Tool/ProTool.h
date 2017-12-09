//
//  ProTool.h
//  PromotionApp
//
//  Created by app03 on 16/5/11.
//  Copyright © 2016年 app03. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ProTool : NSObject
/**
 *  ip地址
 */
+(NSString *)getIPAddress;


/**
 *  去除html文本的标签
 */
-(NSString *)filterHTML:(NSString *)html;

- (void)rexget:(NSString *)staString;

/**
 *  加密url
 */
+(NSString*)encoingWithDic:(NSDictionary*)dataDic Withcharacter:(NSString*)character;
//加密文章
+(NSString*)encoingArticalWithDic:(NSMutableDictionary*)dataDic Withcharacter:(NSString*)character;

//md5 32位 加密 （小写）
+ (NSString *)md5:(NSString *)str;
//md5 16位加密 （大写）

+(NSString *)bigmd5:(NSString *)str;
/**
 *  无网占位图
 */
+(UIImageView*)setViewPlaceHoldImage:(CGFloat)maxY WithBgView:(UIView*)bgView;
//截取图片
+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size;
//获取图片
+(NSData*)findImgInDish:(NSString*)imageURL;

//判断链接中是否含有淘宝链接
+(BOOL)judgeTaoBaoString:(NSString*)urlString;
//转化淘宝字符串
+(NSString*)tansfromTaoBaoString:(NSString*)urlString;

@end

