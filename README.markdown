DTKeychain
==========

[![Build Status](https://travis-ci.org/Cocoanetics/DTKeychain.png?branch=develop)](https://travis-ci.org/Cocoanetics/DTKeychain) [![Coverage Status](https://coveralls.io/repos/Cocoanetics/DTKeychain/badge.png?branch=develop)](https://coveralls.io/r/Cocoanetics/DTKeychain?branch=develop)

A simple and modern keychain wrapper. This is universal for use on iOS and OSX.

The design goal of this component was to replace a previously used keychain wrapper that had gotten very ugly. It is also meant to be extensible to support additional keychain items in the future: Internet Passwords, Certificates, Identities etc. Do you have a use case for these, let us know!

How to Use
==========

To create a new generic password:

```
// get shared instance
DTKeychain *keychain = [DTKeychain sharedInstance];

// just create a new instance of the generic password and set values
DTKeychainGenericPassword *pass = [DTKeychainGenericPassword new];
pass.account = @"bar";
pass.service = @"foo";
pass.password = @"*****";

// write the new object to the keychain
NSError *error;
if (![keychain writeKeychainItem:pass error:&error])
{
   NSLog(@"%@", [error localizedDescription]);
}
```

After the keychain item has been written additional information is filled in, like the persistent reference. This allows you to modify or delete it later on. So for updating the code is the same:

```
pass.password = @"different";

NSError *error;
if (![keychain writeKeychainItem:pass error:&error])
{
   NSLog(@"%@", [error localizedDescription]);
}
```

To get all items matching a certain service. Note that service and account can both be nil.

```
// get shared instance
DTKeychain *keychain = [DTKeychain sharedInstance];

// create a keychain query for generic passwords
NSDictionary *query = [DTKeychainGenericPassword keychainItemQueryForService:@"foo" account:nil];

// retrieve matching keychain items
NSError *error;
NSArray *items = [keychain keychainItemsMatchingQuery:query error:&error];

if (!items)
{
   NSLog(@"%@", [error localizedDescription]);
}
```

iOS and OSX Differences
=======================

On iOS keychain items are sandboxed by access group. DTKeychain relies on the build-in system security and does not artificially restrict the items you can query for. This means that you can also query other already existing generic password keychain items, like WiFi passwords on OSX.

On OSX the user is asked for permission for each item you are trying to retrieve the secure data (aka password) for, on iOS access is regulated by the accessiblity parameter. On iOS, DTKeychain can retrieve the passwords for queried items. On OSX, you have to make a separate call to `retrieveSecuredDataForKeychainItem:error:`

```
// only necessary at an opportune moment on OSX, might cause an 
// access prompt alert to appear
NSError *error;
if (![keychain retrieveSecuredDataForKeychainItem:pass error:&error]
{
   NSLog(@"%@", [error localizedDescription]);
}
```

License
-------

It is open source and covered by a standard 2-clause BSD license. That means you have to mention *Cocoanetics* as the original author of this code and reproduce the LICENSE text inside your app. 

You can purchase a [Non-Attribution-License](http://www.cocoanetics.com/order/?product=DTKeychain%20Non-Attribution%20License) for 75 Euros for not having to include the LICENSE text.
