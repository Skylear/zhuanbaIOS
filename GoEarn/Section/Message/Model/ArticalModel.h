//
//  ArticalModel.h
//  MIAOTUI2
//
//  Created by Beyondream on 16/5/20.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  文章列表的model类
 */
@interface ArticalModel : NSObject

//@property(nonatomic,assign)int adver_auto;

@property (nonatomic, copy) NSArray *ads;

@property(nonatomic,strong)NSString *artID;

@property(nonatomic,strong)NSString *img;

@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *view;

@property(nonatomic,strong)NSString *time;

@property(nonatomic,strong)NSString  * url;

@end
