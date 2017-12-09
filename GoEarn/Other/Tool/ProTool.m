//
//  ProTool.m
//  PromotionApp
//
//  Created by app03 on 16/5/11.
//  Copyright © 2016年 app03. All rights reserved.
//

#import "ProTool.h"
#import "NetHelp.h"
#import "NSString+BXExtension.h"
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <Reachability.h>
#import "LeadVC.h"
#import "RTabBarController.h"
#import <SDImageCache.h>
#import <CommonCrypto/CommonDigest.h>
#import "RTabBarController.h"

#define urlKey @"+^fwfuD5=~*K%62sX@&IM1dfhm4V/rBH!rutuicYh$G"

#define articalKey @"<N1^H}*%0QO`Y{Vl5.t9xAK>a&_v|pJEU3I)b#s6"

@interface ProTool ()

@end

static NSString *domain  = @"www.baidu.com";

@implementation ProTool

//获取网络IP地址
+ (NSString *)getIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"]||[name isEqualToString:@"pdp_ip0"])  // Wi-Fi adapter
                    DLog(@"IP:%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)]);
                return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;

}
//判断是否含有淘宝字段
+(BOOL)judgeTaoBaoString:(NSString*)urlString
{
    if ([urlString containsString:@"taobao.com"])
    {
        return YES;
    }else
    {
        return NO;
    }
}
//转化淘宝字符串
+(NSString*)tansfromTaoBaoString:(NSString*)urlString
{
    if ([urlString hasPrefix:@"http://"])
    {
        urlString = [urlString stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:@"taobao://"];
        
    }else
    {
        urlString = [urlString stringByReplacingCharactersInRange:NSMakeRange(0, 8) withString:@"taobao://"];
    }
    return urlString;
}
/**
 *  private final static String regxpForHtml = "<([^>]*)>"; // 过滤所有以<开头以>结尾的标签
 private final static String regxpForImgTag = "<\\s*img\\s+([^>]*)\\s*>"; // 找出IMG标签
 private final static String regxpForImaTagSrcAttrib = "src=\"([^\"]+)\""; // 找出IMG标签的SRC属性

 */
-(NSString *)filterHTML:(NSString *)html

{
    
    NSScanner * scanner = [NSScanner scannerWithString:html];
    
    NSString * text =nil;
    
    while([scanner isAtEnd]==NO)
        
    {
        
        //找到标签的起始位置
        
        [scanner scanUpToString:@"<"intoString:nil];
        
        //找到标签的结束位置
        
        [scanner scanUpToString:@">"intoString:&text];
        
        //替换字符
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text]withString:@""];
        
    }
    
    //    NSString * regEx = @"<([^>]*)>";
    
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    
    return html;
    
}
- (void)rexget:(NSString *)staString{
    
    
    
    NSString *emotion =@"src-data=";
    
    // NSString *parten = @"(\s)*(\[)(\s)*(self)(\s)*(.)(\s)*(label)(\s)*(setText)(\s)*(:)(\s)*(@)(\s)*(".*")(\s)*(\])(\s)*(;)(\s)*";
    
    NSError* error =NULL;
    
    
    
    NSRegularExpression *reg1 = [NSRegularExpression regularExpressionWithPattern:emotion options:NSRegularExpressionCaseInsensitive error:&error];
    
    
    
    
    NSArray* match1 = [reg1 matchesInString:staString options:NSMatchingReportCompletion range:NSMakeRange(0, [staString length])];
    
    
    
    if (match1.count !=0)
        
    {
        
        for (NSTextCheckingResult *matc in match1)
            
        {
            
            NSRange range = [matc range];
            
              DLog(@"%lu,%lu,%@",(unsigned long)range.location,(unsigned long)range.length,[staString substringWithRange:range]);
            
            
        }
        
    }
    
}
/**
 *  加密url
 */
+(NSString*)encoingWithDic:(NSMutableDictionary*)dataDic Withcharacter:(NSString*)character
{
   //当前时间戳
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    [dataDic setObject:timeSp forKey:@"signTime"];
   // DLog(@"timesp===%@",timeSp);
    //随机16位数
    //NSString *randomStr = [NSString generateFradomCharacter];
    [dataDic setObject:character forKey:@"signStr"];
   // DLog(@"randomStr===%@",character);
    /*请求参数按照参数名ASCII码从小到大排序*/
    NSArray *keys = [dataDic allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString *returnStr = @"";
  
    //拼接字符串
    for (int i=0;i<sortedArray.count;i++) {
        NSString *category = sortedArray[i];
        
        if ([dataDic[category] isEqualToString:@""])
        {
            returnStr =[NSString stringWithFormat:@"%@%@%@",returnStr,@"",@""];
        }else
        {
            returnStr = [NSString stringWithFormat:@"%@&%@=%@",returnStr,category,dataDic[category]];
        }
               //DLog(@"key===%@value===%@",category,dataDic[category]);
    }
    if ([returnStr hasPrefix:@"&"])
    {
        returnStr = [returnStr substringFromIndex:1];
    }

    /*拼接上key得到stringSignTemp*/
    returnStr = [NSString stringWithFormat:@"%@&key=%@",returnStr,urlKey];
   // DLog(@"签名数据－－－－ %@",returnStr);
    /*md5加密*/
    returnStr = [self bigmd5:returnStr];
    
   // DLog(@"returnStr ======%@",returnStr);
    
   // DLog(@"---------------%@",[self bigmd5:@"signStr=0ic4eo3r9r7gj1d9&signTime=1464002720&key=<N1^H}*%0QO`Y{Vl5.t9xAK>a&_v|pJEU3I)b#s6"]);
    
    return returnStr;
}

/**
 *  加密文章url
 */
+(NSString*)encoingArticalWithDic:(NSMutableDictionary*)dataDic Withcharacter:(NSString*)character
{
    //当前时间戳
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    [dataDic setObject:timeSp forKey:@"signTime"];
    // DLog(@"timesp===%@",timeSp);
    //随机16位数
    //NSString *randomStr = [NSString generateFradomCharacter];
    [dataDic setObject:character forKey:@"signStr"];
    // DLog(@"randomStr===%@",character);
    /*请求参数按照参数名ASCII码从小到大排序*/
    NSArray *keys = [dataDic allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString *returnStr = @"";
    
    //拼接字符串
    for (int i=0;i<sortedArray.count;i++) {
        NSString *category = sortedArray[i];
        
        if ([dataDic[category] isEqualToString:@""])
        {
            returnStr =[NSString stringWithFormat:@"%@%@%@",returnStr,@"",@""];
        }else
        {
            returnStr = [NSString stringWithFormat:@"%@&%@=%@",returnStr,category,dataDic[category]];
        }
        //DLog(@"key===%@value===%@",category,dataDic[category]);
    }
    if ([returnStr hasPrefix:@"&"])
    {
        returnStr = [returnStr substringFromIndex:1];
    }
    
    /*拼接上key得到stringSignTemp*/
    returnStr = [NSString stringWithFormat:@"%@&key=%@",returnStr,articalKey];
    // DLog(@"签名数据－－－－ %@",returnStr);
    /*md5加密*/
    returnStr = [self bigmd5:returnStr];
    
    // DLog(@"returnStr ======%@",returnStr);
    
    // DLog(@"---------------%@",[self bigmd5:@"signStr=0ic4eo3r9r7gj1d9&signTime=1464002720&key=<N1^H}*%0QO`Y{Vl5.t9xAK>a&_v|pJEU3I)b#s6"]);
    
    return returnStr;
}



//md5 32位 加密 （小写）
+ (NSString *)md5:(NSString *)str {
    
    
    
    const char *cStr = [str UTF8String];
    
    
    
    unsigned char result[32];
    
    
    
    CC_MD5( cStr, strlen(cStr), result );
    
    
    
    return [NSString stringWithFormat:
            
            
            
            @"xxxxxxxxxxxxxxxx",
            
            
            
            result[0],result[1],result[2],result[3],
            
            result[4],result[5],result[6],result[7],
            
            result[8],result[9],result[10],result[11],
            
            result[12],result[13],result[14],result[15],
            
            result[16], result[17],result[18], result[19],
            
            result[20], result[21],result[22], result[23],
            
            result[24], result[25],result[26], result[27],
            
            result[28], result[29],result[30], result[31]];
    
}


//md5 32位加密 （大写）

+(NSString *)bigmd5:(NSString *)str {
    
    
    
    const char *cStr = [str UTF8String];
    
    
    
    unsigned char result[16];
    
    
    
    CC_MD5( cStr, strlen(cStr), result );
    
    
    
    return [NSString stringWithFormat:
            
            
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            
            
            result[0], result[1], result[2], result[3],
            
            
            
            result[4], result[5], result[6], result[7],
            
            
            
            result[8], result[9], result[10], result[11],
            
            
            
            result[12], result[13], result[14], result[15]
            
            
            
            ];
    
}
+(UIImageView*)setViewPlaceHoldImage:(CGFloat)maxY WithBgView:(UIView*)bgView
{
    float rate = SCREEN_WIDTH/320;
    UIImageView *holdimgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-102.5*rate, maxY, 205*rate, 185*rate)];
    bgView.tag = 101010;
    holdimgView.image = [UIImage imageNamed:@"no_service_img"];
    [bgView addSubview:holdimgView];
    return holdimgView;
    
}
+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size
{
    CGSize originalsize = [originalImage size];
    //NSLog(@"改变前图片的宽度为%f,图片的高度为%f",originalsize.width,originalsize.height);
    
    //原图长宽均小于标准长宽的，不作处理返回原图
    if (originalsize.width<size.width && originalsize.height<size.height)
    {
        return originalImage;
    }
    
    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    else if(originalsize.width>size.width && originalsize.height>size.height)
    {
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width/size.width;
        CGFloat heightRate = originalsize.height/size.height;
        
        rate = widthRate>heightRate?heightRate:widthRate;
        
        CGImageRef imageRef = nil;
        
        if (heightRate>widthRate)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
        }
        else
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
        }
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        //NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        
        return standardImage;
    }
    
    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    else if(originalsize.height>size.height || originalsize.width>size.width)
    {
        CGImageRef imageRef = nil;
        
        if(originalsize.height>size.height)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
        }
        else if (originalsize.width>size.width)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
        }
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        //NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        
        return standardImage;
    }
    
    //原图为标准长宽的，不做处理
    else
    {
        return originalImage;
    }
}

+(NSData*)findImgInDish:(NSString*)imageURL
{
    NSData *imageData = nil;
    BOOL isExit = [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:imageURL]];
    if (isExit) {
        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imageURL]];
        if (cacheImageKey.length) {
            NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
            if (cacheImagePath.length) {
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
            }
        }
    }
    if (!imageData) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    }
    return imageData;
}

-(void)catchLocalMessage
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Configurator" ofType:@"plist"];/*读取app内的文件*/
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSMutableDictionary * config = [data mutableCopy];
    
    /*    apns part    */
    NSMutableDictionary * apns = config[@"PayloadContent"][0][@"PayloadContent"][0][@"DefaultsData"][@"apns"][0];
    [apns setObject:@"apnName"  forKey:@"apn"];
    [apns setObject:@"userName" forKey:@"username"];
    [apns setObject:@"passWord" forKey:@"password"];
    /*    UUID part    */
    // 负载的 uuid
    NSString * uuid = config[@"PayloadContent"][0][@"PayloadUUID"];
//    uuid = [CUManager configUUID];
//    // 文件的 uuid
//    NSString * fileuuid = config[@"PayloadUUID"];
//    fileuuid = APNModel.fileName;
    
    // file path 沙盒路径
    NSString *documentsDirectory =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [documentsDirectory stringByAppendingPathComponent:@"XXAPN.mobileconfig"];
    
    /*  打印一下 将要存进去的数据  */
    NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    DLog(@"%@", data1);
    
    // write to file  写到沙盒里面
    [config writeToFile:filename atomically:YES];
}

@end
