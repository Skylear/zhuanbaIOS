//
//  QRCodeHandler.m
//  二维码
//
//  Created by 忆思梦 on 16/9/27.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

#import "QRCodeHandler.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface QRCodeHandler ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) UIView *superView;
@end

@implementation QRCodeHandler

#pragma mark -- 生成二维码
+ (UIImage *)createQRCodeForString:(NSString *)qrString withImageViewSize:(CGSize)size{
    NSData * stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter * qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    //容错率  “L”：7% “M”：15% “Q”：25% “H”：30% QR码有容错能力，QR码图形如果有破损，仍然可以被机器读取内容，最高可以到7%~30%面积破损仍可被读取，所以很多二维码的中间都有头像之类的图片但仍然可以识别
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    //二维码大小
    CGRect extent = CGRectIntegral(qrFilter.outputImage.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent)*scale;
    size_t height = CGRectGetHeight(extent)*scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext * context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:qrFilter.outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaleImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage * image = [UIImage imageWithCGImage:scaleImage];
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGImageRelease(scaleImage);
    return image;
}


#pragma mark 扫描二维码
- (instancetype)initInView:(UIView *)superView withCaptureFrame:(CGRect)frame{
    if (self = [super init]) {
        self.superView = superView;
        self.frame = frame;
        [self setupCaptureDevice];
    }
    return self;
}

- (void)setupCaptureDevice{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (!error) {
        self.output = [[AVCaptureMetadataOutput alloc]init];
        [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // Session
        self.session = [[AVCaptureSession alloc]init];
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([self.session canAddInput:self.input]) {
            [self.session addInput:self.input];
        }
        
        if ([self.session canAddOutput:self.output]) {
            [self.session addOutput:self.output];
        }
        //设置识别码
        self.output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,nil];
        self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.preview.frame = self.frame;
        [self.superView.layer insertSublayer:self.preview atIndex:0];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"摄像头不可用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        alert.tag = 0;
        [alert show];
    }
}
- (void)startRunning{
    if (!self.session.isRunning) {
        [self.session startRunning];
    }
}
- (void)stopRunning{
    if (self.session.isRunning) {
        [self.session stopRunning];
    }
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        if (_delegate && [_delegate respondsToSelector:@selector(qrCodeMessageString:)]) {
            [_delegate qrCodeMessageString:metadataObject.stringValue];
        }
    }
    [self stopRunning];
}


#pragma mark -- 识别图片中二维码
+ (NSString *)recognizedQRCodeOfImage:(UIImage *)image complete:(void (^)(NSString * messageString,BOOL success))complete{
    //1.初始化扫描仪，设置设别类型和识别质量
    NSDictionary *detectorOptions = @{CIDetectorAccuracy : CIDetectorAccuracyHigh};
    /* CIDetectorTypeFace:识别脸部，CIDetectorTypeRectangle:矩形，CIDetectorTypeQRCode：二维码 CIDetectorTypeText：文字 */
    CIDetector *qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:detectorOptions];
    //2.扫描获取的特征组
    /* CIFeature的子类 CIFaceFeature CIRectangleFeature CIQRCodeFeature CITextFeature */
    NSArray *features = [qrDetector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count>0) {
        CIQRCodeFeature * qrCodeFeature = features.firstObject;
        if (complete) {
            complete(qrCodeFeature.messageString,YES);
        }
        return qrCodeFeature.messageString;
    }else{
        if (complete) {
            complete(nil,NO);
        }
        return nil;
    }
}

@end
