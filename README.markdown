DTKeychain
==========

A simple and modern keychain wrapper

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
