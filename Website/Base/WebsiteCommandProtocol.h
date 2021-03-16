//
//  WebsiteCommandProtocol.h
//  VWorld
//
//  Created by Chou Coody on 2018/1/15.
//  Copyright © 2018年 Coody. All rights reserved.
//

#import "WebsiteBaseDefine.h"

@protocol WebsiteCommandProtocol <NSObject>

-(void)startCommandWithSuccessBlock:(WebApiRequestSuccessBlock)successBlock 
                      withFaliBlock:(WebApiRequestFailBlock)failBlock;

-(void)terminate;

@end
