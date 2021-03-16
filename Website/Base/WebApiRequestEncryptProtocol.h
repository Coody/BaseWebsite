//
//  WebApiRequestEncryptProtocol.h
//  VWorld
//
//  Created by Chou Coody on 2018/1/17.
//  Copyright © 2018年 Coody. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebApiRequestEncryptProtocol <NSObject>

@optional
-(BOOL)isNeedEncrypt;

-(BOOL)isNeedDecrypt;

-(id)encrypt:(id)origninalData;

-(id)decrypt:(id)encryptData;

@end
