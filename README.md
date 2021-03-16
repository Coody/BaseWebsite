# Easy Website

* This is iOS webapi request tools.
* Easy to test, easy to use.
* Base on AFNetworking.
* Can easy to use your own Encrypt and Decrypt algorithm.

# How to use

* Quick way:

  ```
  // set base url
  [[WebsiteBase sharedInstance] setHomeUrl:@"https://api.guildwars2.com/v2"];
  
  // create a request
  [[WebsiteBase sharedInstance] createWebApiHomeUrlAndPostRequestWithTailUrl:@"" withParams:@{ @"quantity" : [NSNumber numberWithInteger:120] } 
  withSuccessBlock:^(NSError *error, id result) {
    // TODO: Success!
  } withFailBlock:^(NSError *error, NSNumber *errorCode, NSString *errorMsg) {
    // TODO: Fail!
  }];
  ```
  
  * OOC way:
    * Create an object inherit ```WebApiRequest``` .
    * Implement WebApiRequestProtocol.
    * Implement WebApiRequestEncryptProtocol.( if need Encrypt or Decrypt )
    * Alloc the class and initWithSuccessBlock ...
    * Set params.
    * Send.
    * Read more on class ```ViewController``` and ```GemsRequest```.
    
  * Third Party
    * AFNetworking
    * JSONModel
    
* License

  MIT
