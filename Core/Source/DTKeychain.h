//
//  DTKeychain.h
//  PL
//
//  Created by Oliver Drobnik on 03/12/14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

#import <Foundation/Foundation.h>

// domain for returned errors
extern NSString * const DTKeychainErrorDomain;

// so that including source only needs DTKeychain.h
#import "DTKeychainGenericPassword.h"

/**
 Wrapper for the iOS/OSX keychain
 */
@interface DTKeychain : NSObject

/**
 The shared instance of DTKeychain
 */
+ (instancetype)sharedInstance;


/**
 @name Finding Keychain Items
 */

/**
 Query the keychain for items matching the query
 @param query The query to find certain keychain items
 @param error An optional output parameter to take on an error if one occurs
 @returns An array of results or `nil` if the query failed
 */
- (NSArray *)keychainItemsMatchingQuery:(NSDictionary *)query error:(NSError *__autoreleasing *)error;

/**
 On OSX the secure data of keychain items needs to be retrieved separately whereas on iOS keychainItemsMatchingQuery:error: already does that. On OSX this triggers a user interaction alert asking the user to permit access for items which have not been created by the current app.
 @param keychainItem The DTKeychainItem for which to retrieve the secure data
 @param error An optional output parameter to take on an error if one occurs
 @returns `YES` if the operation was successful
 */
- (BOOL)retrieveSecuredDataForKeychainItem:(DTKeychainItem *)keychainItem error:(NSError *__autoreleasing *)error;

/**
 @name Manipulating Keychain Items
 */

/**
 Writes the keychain item to the keychain. If it has a persistent reference it will be an update, if not it will be newly created.
 @param keychainItem The DTKeychainItem to persist
 @param error An optional output parameter to take on an error if one occurs
 @returns `YES` if the operation was successful
 */
- (BOOL)writeKeychainItem:(DTKeychainItem *)keychainItem error:(NSError *__autoreleasing *)error;

/**
 Removes a keychain item from the keychain
 @param keychainItem The DTKeychainItem to remove from the keychain
 @param error An optional output parameter to take on an error if one occurs
 @returns `YES` if the operation was successful
 */
- (BOOL)removeKeychainItem:(DTKeychainItem *)keychainItem error:(NSError *__autoreleasing *)error;

/**
 Removes multiple keychain items from the keychain
 @param keychainItems The keychain items to remove from the keychain
 @param error An optional output parameter to take on an error if one occurs
 @returns `YES` if the operation was successful
 */
- (BOOL)removeKeychainItems:(NSArray *)keychainItems error:(NSError *__autoreleasing *)error;

@end
