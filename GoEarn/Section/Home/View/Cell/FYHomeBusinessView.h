//
//  FYHomeBusinessView.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/12.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYHomeBusinessView;

@protocol FYHomeBusinessDelegate <NSObject>

-(void)FYHomeBusiness:(FYHomeBusinessView*)businessView ;

@end

@interface FYHomeBusinessView : UIView

@property(nonatomic,assign)id<FYHomeBusinessDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame withUrl:(NSString*)urlString withArr:(NSArray*)arr withMoney:(NSString*)money;

@end

@interface BussinessModel : NSObject

@property(nonatomic,strong)NSString  * nameString;

@property(nonatomic,strong)NSString* nameID;
@end
