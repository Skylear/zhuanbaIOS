//
//  ABPersonViewController+Delete.m
//  MiaoChat
//
//  Created by Beyondream on 16/8/3.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "ABPersonViewController+Delete.h"

@implementation ABPersonViewController (Delete)

- (id)init
{
    self = [super init];
    
    if (self)
    {
        @try
        {
            // Display the "Delete" and "Cancel" action sheet
            [self setValue:[NSNumber numberWithBool:YES] forKey:@"allowsDeletion"];
        }
        @catch (NSException * exception)
        {
            // Log any exception
            NSLog(@"%@", exception);
        }
    }
    
    return self;
}
@end
