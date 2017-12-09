//
//  KeychainItemWrapper.h
//  GoEarn
//
//  Created by Beyondream on 2016/10/22.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeychainItemWrapper : NSObject
//{
//    NSMutableDictionary *keychainItemData;        // The actual keychain item data backing store.
//    NSMutableDictionary *genericPasswordQuery;    // A placeholder for the generic keychain item query used to locate the item.
//}
//
//@property (nonatomic, retain) NSMutableDictionary *keychainItemData;
//@property (nonatomic, retain) NSMutableDictionary *genericPasswordQuery;
//
//// Designated initializer.
//- (id)initWithAccount:(NSString *)account service:(NSString *)service accessGroup:(NSString *) accessGroup;
//
//- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup;
//- (void)setObject:(id)inObject forKey:(id)key;
//- (id)objectForKey:(id)key;
//
//// Initializes and resets the default generic keychain item data.
//- (void)resetKeychainItem;
+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)deleteKeyData:(NSString *)service;


@end
