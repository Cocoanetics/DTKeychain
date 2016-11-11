//
//  DTKeychain.h
//  PL
//
//  Created by Oliver Drobnik on 03/12/14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

#import <Foundation/Foundation.h>

// domain for returned errors
extern NSString * _Nonnull const DTKeychainErrorDomain;

// so that including source only needs DTKeychain.h
#import "DTKeychainGenericPassword.h"

// proper nullable tags for the NSError **
#define NullableError NSError * __autoreleasing _Nullable * _Nullable

/**
 Wrapper for the iOS/OSX keychain
 */
@interface DTKeychain : NSObject

/**
 The shared instance of DTKeychain
 */
+ (nonnull instancetype)sharedInstance;


/**
 @name Finding Keychain Items
 */

/**
 Query the keychain for items matching the query
 @param query The query to find certain keychain items
 @param error An optional output parameter to take on an error if one occurs
 @returns An array of results or `nil` if the query failed
 */
- (nullable NSArray<DTKeychainItem *> *)keychainItemsMatchingQuery:(nonnull NSDictionary *)query error:(NullableError)error;

/**
 On OSX the secure data of keychain items needs to be retrieved separately whereas on iOS keychainItemsMatchingQuery:error: already does that. On OSX this triggers a user interaction alert asking the user to permit access for items which have not been created by the current app.
 @param keychainItem The DTKeychainItem for which to retrieve the secure data
 @param error An optional output parameter to take on an error if one occurs
 @returns `YES` if the operation was successful
 */
- (BOOL)retrieveSecuredDataForKeychainItem:(nonnull DTKeychainItem *)keychainItem error:(NullableError)error;

/**
 @name Manipulating Keychain Items
 */

/**
 Writes the keychain item to the keychain. If it has a persistent reference it will be an update, if not it will be newly created.
 @param keychainItem The DTKeychainItem to persist
 @param error An optional output parameter to take on an error if one occurs
 @returns `YES` if the operation was successful
 */
- (BOOL)writeKeychainItem:(nonnull DTKeychainItem *)keychainItem error:(NullableError)error;

/**
 Removes a keychain item from the keychain
 @param keychainItem The DTKeychainItem to remove from the keychain
 @param error An optional output parameter to take on an error if one occurs
 @returns `YES` if the operation was successful
 */
- (BOOL)removeKeychainItem:(nonnull DTKeychainItem *)keychainItem error:(NullableError)error;

/**
 Removes multiple keychain items from the keychain
 @param keychainItems The keychain items to remove from the keychain
 @param error An optional output parameter to take on an error if one occurs
 @returns `YES` if the operation was successful
 */
- (BOOL)removeKeychainItems:(nonnull NSArray *)keychainItems error:(NullableError)error;

@end
