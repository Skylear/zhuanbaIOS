//
//  AFNetworkRequest.h
//  AF封装
//
//  Created by Beyondream on 15/11/15.
//  Copyright © 2015年 Beyondream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingView : UIView

+(LoadingView*)shareInstance;

-(void)showLoading:(UIViewController*)vc withMessage:(NSString*)message;

-(void)showErrorMessage:(NSString*)message;

-(void)hiden;

@end


//网络请求类型
typedef NS_ENUM(NSUInteger,NetworkRequestType) {
    NetworkRequestTypePost,
    NetworkRequestTypeGet,
    NetworkRequestTypeHead,
    NetworkRequestTypePut,
    NetworkRequestTypeDelete
};

typedef void(^NetworkRequestResultBlock)(id responseObject,NSError *error);

@interface AFNetworkRequest : NSObject
- (BOOL)isConnected;
/**
 *  发送网络请求
 *
 *  @param urlString   网址字符串
 *  @param parameters  参数
 *  @param type        请求类型
 *  @param resultBlock 返回结果：responseObject,error
 */
- (void)requestWithVC:(UIViewController*)VC   URLString:(NSString *)urlString
           parameters:(NSMutableDictionary *)parameters
                 type:(NetworkRequestType)type
          resultBlock:(NetworkRequestResultBlock)resultBlock;
@end
