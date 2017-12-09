//
//  OpenOther.m
//  GoEarn
//
//  Created by Beyondream on 2016/11/4.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "OpenOther.h"
 #include <objc/runtime.h>
@implementation OpenOther

+(BOOL)openOther:(NSString*)bundleString
{
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    
    NSObject * workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    
    BOOL isopen = [workspace performSelector:@selector(openApplicationWithBundleID:) withObject:bundleString];
    
    return isopen;
}
-(void)defaultWorkspace
{
    
}
-(void)openApplicationWithBundleID:(id)obj
{
    
}
+(BOOL)findOther:(NSString*)bundleString
{
   // NSString *const bundleStr = bundleString;
    
    
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray *allApplications = [workspace performSelector:@selector(allApplications)];//这样就能获取到手机中安装的所有App
    NSInteger zlConnt = 0;
    for (NSString *appStr in allApplications)
    {
        
        NSString *app = [NSString stringWithFormat:@"%@",appStr];//转换成字符串
        DLog(@"------app-----%@",app);
        if ([app containsString:bundleString])
        {
            zlConnt = 100;
        }
        
    }
                         
         if (zlConnt > 1) {
             return YES;
         }else
         {
             DLog(@"------app-----222");
             return NO;
         }
    
}
-(void)allApplications
{
    
}
@end
