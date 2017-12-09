//
//  QRCodeHandler.h
//  二维码
//
//  Created by 忆思梦 on 16/9/27.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RecognizeQRCodeDelegate <NSObject>

- (void)qrCodeMessageString:(NSString *)messageString;

@end

@interface QRCodeHandler : NSObject

#pragma mark -- 生成二维码
/**
 *  生成二维码
 */
+ (UIImage *)createQRCodeForString:(NSString *)qrString withImageViewSize:(CGSize)size;


#pragma mark -- 扫描二维码
- (instancetype)initInView:(UIView *)superView withCaptureFrame:(CGRect)frame;
@property (nonatomic, assign) id<RecognizeQRCodeDelegate> delegate;
/** @brief 扫描识别之后会自动关闭，继续扫描请重新打开 */
- (void)startRunning;
- (void)stopRunning;


#pragma mark -- 识别二维码
/**
 *  识别图片二维码
 */
+ (NSString *)recognizedQRCodeOfImage:(UIImage *)image complete:(void (^)(NSString * messageString,BOOL success))complete;

@end
