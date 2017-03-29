//
//  DTKeychainAccount.h
//  PL
//
//  Created by Oliver Drobnik on 03/12/14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTKeychainItemQuery;

/**
 This is the common root class for all kinds of keychain items.
 */
@interface DTKeychainItem : NSObject

/**
 Instantiates the receiver with a dictionary as returned by a keychain query
 @param dictionary The dictionary as it would come out of keychain queries
 */
- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

/**
 The class of the keychain item. Subclasses need to overwrite this. This determins the secItemClass to be used for keychain queries.
 */
+ (nullable NSString *)itemClass;


/**
 Determines the correct class of the class cluster for a given itemClass
 @param itemClass The keychain item class string
 @returns The class to represent items with this item class as
 */
+ (nullable Class)classForItemClass:(nonnull NSString *)itemClass;

/**
 Returns the modifyable attributes to write to the keychains for updates or newly created items
 */
- (nonnull NSDictionary *)attributesToUpdate;


/**
 @name Constructing Queries
 */

/**
 A basic query that only contains the item class and should be enhanced with the primary key fields of subclasses.
 */
+ (nonnull NSDictionary *)keychainItemQuery;

/**
 @name Properties
 */

/**
 A persistent reference to the receiver in the keychain. This can be persisted on disk.
 */
@property (nonatomic, readonly, nullable) NSData *persistentReference;

/**
 The time the receiver was last modified
 */
@property (nonatomic, readonly, nullable) NSDate *modificationDate;

/**
 The time the receiver was created
 */
@property (nonatomic, readonly, nullable) NSDate *creationDate;

/**
 The keychain access group the receiver belongs to. Is usually the app identifier including the group prefix
 */
@property (nonatomic, readonly, nullable) NSString *accessGroup;

/**
 Whether the receiver is synchronizable
 */
@property (nonatomic, readonly, getter=isSynchronizable) BOOL synchronizable;

/**
 Under which circumstances the receiver is accessible, see kSecAttrAccessible. Only used on iOS.
 */
@property (nonatomic, copy, getter=accessibilityMode, nullable) NSString *accessibility;

/**
 The secure data or the receiver
 */
@property (nonatomic, copy, nullable) NSData *secureData;

/**
 A label to describe the item
 */
@property (nonatomic, copy, nullable) NSString *label;

/**
 A comment to describe the item
 */
@property (nonatomic, copy, nullable) NSString *comment;

/**
 A comment to describe the item
 */
@property (nonatomic, copy, nullable) NSString *descriptionText;

@end
