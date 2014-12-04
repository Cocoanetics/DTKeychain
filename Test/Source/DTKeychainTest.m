//
//  DTKeychainTest.m
//  DTFoundation
//
//  Created by Oliver Drobnik on 03/12/14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DTKeychain.h"
#import "DTKeychainGenericPassword.h"

@interface DTKeychainTest : XCTestCase

@end

@implementation DTKeychainTest
{
	DTKeychain *_keychain;
	NSString *_service;
}

- (void)setUp
{
    [super setUp];
	
	_keychain = [DTKeychain sharedInstance];
	
	_service = @"com.cocoanetics.DTKeychain.UnitTests";
	
	[self _cleanKeychain];
	
	// check that there are no items to cause trouble
	NSError *error;
	NSArray *items = [self _keychainItemsError:&error];
	XCTAssertEqual([items count], 0, @"There should be no items to begin with");
	XCTAssertNil(error, @"%@", [error localizedDescription]);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
	
	// clean out all generic items
	NSArray *items = [_keychain keychainItemsMatchingQuery:[DTKeychainGenericPassword keychainItemQueryForService:_service account:@"bar"] error:NULL];
	
	if ([items count])
	{
		[_keychain removeKeychainItems:items error:NULL];
	}
}

#pragma mark - Helpers

- (void)_cleanKeychain
{
	// clean out all generic items
	NSError *error;
	NSArray *items = [self _keychainItemsError:&error];
	XCTAssertNil(error, @"%@", [error localizedDescription]);
	
	[_keychain removeKeychainItems:items error:&error];
	XCTAssertNil(error, @"%@", [error localizedDescription]);
}

- (DTKeychainGenericPassword *)_addFooBarItem
{
	DTKeychainGenericPassword *item = [DTKeychainGenericPassword new];
	item.account = @"foo";
	item.service = _service;
	item.password = @"pw";
	
	NSError *error;
	BOOL result = [_keychain writeKeychainItem:item error:&error];
	XCTAssertTrue(result, @"%@", [error localizedDescription]);
	
	return item;
}

- (void)_removeFooBarItem
{
	NSDictionary *query = [DTKeychainGenericPassword keychainItemQueryForService:@"foo" account:@"bar"];
	NSArray *items = [_keychain keychainItemsMatchingQuery:query error:NULL];
	[_keychain removeKeychainItems:items error:NULL];
}

- (NSArray *)_keychainItemsError:(NSError **)error
{
#if TARGET_OS_IPHONE
	// this can only be done on iOS since on OSX the keychain items are not sandboxed
	return [_keychain keychainItemsMatchingQuery:[DTKeychainGenericPassword keychainItemQuery] error:error];
#else
	return [_keychain keychainItemsMatchingQuery:[DTKeychainGenericPassword keychainItemQueryForService:_service account:nil] error:error];
#endif
}


#pragma mark - Tests

#if TARGET_OS_IPHONE
// this is only allowed on iOS
- (void)testCreateEmptyGenericPassword
{
	DTKeychainGenericPassword *item = [DTKeychainGenericPassword new];
	
	NSError *error;
	BOOL result = [_keychain writeKeychainItem:item error:&error];
	
	NSArray *items = [self _keychainItemsError:&error];
	XCTAssertTrue(result, @"%@", [error localizedDescription]);
	XCTAssertEqual([items count], 1, @"There should be one item");
}
#endif

- (void)testCreateNormalGenericPassword
{
	[self _addFooBarItem];
	
	NSError *error;
	NSArray *items = [self _keychainItemsError:&error];
	XCTAssertTrue(items, @"%@", [error localizedDescription]);
	XCTAssertEqual([items count], 1, @"There should be one item");
	
	DTKeychainGenericPassword *item = [items lastObject];
	XCTAssertTrue([item isKindOfClass:[DTKeychainGenericPassword class]], @"class should be DTKeychainGenericPassword");
	
	XCTAssertEqualObjects(item.account, @"foo", @"Account should match");
	XCTAssertEqualObjects(item.service, _service, @"Service should match");
	XCTAssertEqualObjects(item.password, @"pw", @"Password should match");
}


- (void)testCreateAndDeleteSingle
{
	DTKeychainGenericPassword *item = [self _addFooBarItem];
	
	NSError *error;
	BOOL result = [_keychain removeKeychainItem:item error:&error];
	XCTAssertTrue(result, @"%@", [error localizedDescription]);

	NSArray *items = [self _keychainItemsError:&error];
	XCTAssertTrue(items, @"%@", [error localizedDescription]);
	XCTAssertEqual([items count], 0, @"There should be no item");
}

- (void)testCreateDuplicate
{
	[self _addFooBarItem];
	
	DTKeychainGenericPassword *item2 = [DTKeychainGenericPassword new];
	item2.account = @"foo";
	item2.service = _service;
	item2.password = @"pw";
	
	NSError *error;
	BOOL result = [_keychain writeKeychainItem:item2 error:&error];
	XCTAssertFalse(result, @"%@", [error localizedDescription]);
}

- (void)testCreateAndChangePassword
{
	DTKeychainGenericPassword *item = [self _addFooBarItem];
	item.password = @"newpw";
	
	NSError *error;
	BOOL result = [_keychain writeKeychainItem:item error:&error];
	XCTAssertTrue(result, @"%@", [error localizedDescription]);
	
	NSArray *items = [self _keychainItemsError:&error];
	XCTAssertTrue(items, @"%@", [error localizedDescription]);
	XCTAssertEqual([items count], 1, @"There should be one item");
	
	item = [items lastObject];
	
	XCTAssertEqualObjects(item.password, @"newpw", @"Password should have been updated");
}

- (void)testCreateAndChangeAccount
{
	DTKeychainGenericPassword *item = [self _addFooBarItem];
	item.account = @"newfoo";
	
	NSError *error;
	BOOL result = [_keychain writeKeychainItem:item error:&error];
	XCTAssertTrue(result, @"%@", [error localizedDescription]);
	
	NSArray *items = [self _keychainItemsError:&error];
	XCTAssertTrue(items, @"%@", [error localizedDescription]);
	XCTAssertEqual([items count], 1, @"There should be one item");
	
	item = [items lastObject];
	
	XCTAssertEqualObjects(item.account, @"newfoo", @"Account name should have been updated");
}

- (void)testCreateAndChangeService
{
	NSString *newService = [_service stringByAppendingString:@".new"];
	
	DTKeychainGenericPassword *item = [self _addFooBarItem];
	item.service = newService;
	
	NSError *error;
	BOOL result = [_keychain writeKeychainItem:item error:&error];
	XCTAssertTrue(result, @"%@", [error localizedDescription]);
	
	NSArray *items = [_keychain keychainItemsMatchingQuery:[DTKeychainGenericPassword keychainItemQueryForService:newService account:nil] error:&error];
	XCTAssertTrue(items, @"%@", [error localizedDescription]);
	XCTAssertEqual([items count], 1, @"There should be one item");
	
	item = [items lastObject];
	
	XCTAssertEqualObjects(item.service, newService, @"Service name should have been updated");
	
	// remove it to clean up
	result = [_keychain removeKeychainItem:item error:&error];
	XCTAssertTrue(result, @"%@", [error localizedDescription]);
}


@end
