//
//  WebApiRequest.h
//  Website
//
//  Created by Coody on 2017/10/9.
//  Copyright © 2017年 Coody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebsiteBaseDefine.h"
#import <JSONModel/JSONModel.h>
#import "WebApiRequestEncryptProtocol.h"


typedef NS_ENUM( NSInteger , EnumWebsiteBase_ErrorCode ){
    EnumWebsiteBase_ErrorCode_ParserFail = -700,
    EnumWebsiteBase_ErrorCode_SuccessResponseError = -701,
};

#pragma mark - WebApiRequest Protocol
@protocol WebApiRequestProtocol <NSObject>
@optional
-(NSString *)customUrl;
-(EnumUrlType)setUrlType;
-(EnumRequestType)setRequestType;
-(EnumResponseType)setResponseType;
-(NSTimeInterval)setTimeOut;
@required
-(BOOL)isNeedHeader;
-(EnumWebsiteType)setWebsiteType;
-(NSString *)setTailUrl;
-(NSDictionary *)setParams;
-(id)parseResponse:(id)responseObject;
@end

#pragma mark - WebApiResponse Protocol
@protocol WebApiResponseProtocol <NSObject>
@optional
-(void)doSomethingAfterGetResult:(id)result;
@end

#pragma mark - WebApiRequest Using Block response
@interface WebApiRequest : NSObject <WebApiRequestProtocol,
WebApiRequestEncryptProtocol,
WebApiResponseProtocol>
@property (nonatomic , weak) id <WebApiResponseProtocol> delegate;
@property (readonly) WebApiRequestSuccessBlock successBlock;
@property (readonly) WebApiRequestFailBlock failBlock;

-(instancetype)initWithSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                      withFailBlock:(WebApiRequestFailBlock)failBlock;

-(void)send;

-(void)terminate;

@end

#pragma mark - WebApiRequestPro Protocol
@protocol WebApiRequestProProtocol <WebApiRequestProtocol>
@required
@property (nonatomic , weak , readonly) id requestDelegate;
@property (nonatomic , assign) SEL successSelector;
@property (nonatomic , assign) SEL failSelector;
@end

#pragma mark - WebApiRequestPro Using Delegate response
@interface WebApiRequestPro : NSObject <WebApiRequestProtocol,
WebApiRequestEncryptProtocol,
WebApiRequestProProtocol,
WebApiResponseProtocol>
@property (nonatomic , weak , readonly) id requestDelegate;
@property (nonatomic , weak) id <WebApiResponseProtocol> responseDelegate;
/**
 * @brief 設定成功的回呼方法（參數有兩個： NSError , id< result > ）
 *
 * @detail -(void)gotSuccessWithError:(NSError *)error withResult:(id)result;
 */
@property (nonatomic , assign) SEL successSelector;
/**
 * @brief 設定失敗的回呼方法（參數有三個： NSError , NSNumber ( error code ) , NSString ( error msg ) ）
 *
 * @detail -(void)gotFailWithError:(NSError *)error withErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg;
 */
@property (nonatomic , assign) SEL failSelector;

-(instancetype)initWithDelegate:(id)delegate;

-(void)send;

-(void)terminate;

@end




