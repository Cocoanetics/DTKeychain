//
//  ViewController.m
//  DTKeychainDemo
//
//  Created by Oliver Drobnik on 04/12/14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

#import "ViewController.h"
#import "DTKeychain.h"

#define SERVICE_NAME @"foo"

@interface ViewController ()

@end

@implementation ViewController
{
	DTKeychainGenericPassword *_pass;
}

- (void)_showError:(NSError *)error
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something weng wrong!"
																						message:[error localizedDescription]
																			  preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:NULL];
	[alert addAction:ok];
	 
	[self presentViewController:alert animated:YES completion:NULL];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// see if there is already an item
	// get shared instance
	DTKeychain *keychain = [DTKeychain sharedInstance];
	
	// create a keychain query for generic passwords
	NSDictionary *query = [DTKeychainGenericPassword keychainItemQueryForService:SERVICE_NAME account:nil];
	
	// retrieve matching keychain items
	NSError *error;
	NSArray *items = [keychain keychainItemsMatchingQuery:query error:&error];
	
	if (items)
	{
		_pass = [items firstObject];
		self.accountField.text = _pass.account;
		self.passwordField.text = _pass.password;
	}
	else
	{
		[self _showError:error];
	}
}

- (IBAction)save:(id)sender
{
	// get shared instance
	DTKeychain *keychain = [DTKeychain sharedInstance];
	
	if (!_pass)
	{
		// create new pass
		_pass = [DTKeychainGenericPassword new];
		_pass.service = SERVICE_NAME;
	}
	
	_pass.account = self.accountField.text;
	_pass.password = self.passwordField.text;
	
	NSError *error;
	if (![keychain writeKeychainItem:_pass error:&error])
	{
		[self _showError:error];
	}
}
@end
