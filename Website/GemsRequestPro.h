//
//  GemsRequestPro.h
//  Website
//
//  Created by coodychou on 2018/9/28.
//  Copyright © 2018 Coody. All rights reserved.
//

#import "WebApiRequest.h"

@class GemsResultPro;

@protocol GemsRequestProProtocol <NSObject>
-(void)getGemsSuccess:(NSError *)error withResult:(GemsResultPro *)result;
-(void)getGemsFail:(NSError *)error withErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg;
@end

@interface GemsResultPro : JSONModel
@property (assign , nonatomic) int coins_per_gem;
@property (assign , nonatomic) NSInteger quantity;
@end

@interface GemsRequestPro : WebApiRequestPro <WebApiRequestProtocol,WebApiResponseProtocol>

-(void)setGems:(NSInteger)gems;

@end

