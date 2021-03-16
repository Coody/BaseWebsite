//
//  WebApiRequest.m
//  Website
//
//  Created by Coody on 2017/10/9.
//  Copyright © 2017年 Coody. All rights reserved.
//

#import "WebApiRequest.h"

// for Tools
#import <objc/runtime.h>

// for WebsiteBase
#import "WebsiteBase.h"

@interface WebApiRequest()
@property (copy) WebApiRequestSuccessBlock successBlock;
@property (copy) WebApiRequestFailBlock failBlock;
@end

@implementation WebApiRequest
#pragma mark - WebsiteRequest protocol
#pragma mark : Optional
-(NSTimeInterval)setTimeOut{
    return kWebsiteBaseTimeoutDefault;
}

-(NSString *)customUrl{
    return @"";
}

-(EnumUrlType)setUrlType{
    return EnumUrlType_Custom;
}

-(EnumRequestType)setRequestType{
    return EnumRequestType_Json;
}

-(EnumResponseType)setResponseType{
    return EnumResponseType_Json;
}

#pragma mark : Required
-(BOOL)isNeedHeader{
    return YES;
}

-(EnumWebsiteType)setWebsiteType{
    return EnumWebsiteType_Post;
}

-(NSString *)setTailUrl{
    return @"";
}

-(NSDictionary *)setParams{
    return nil;
}

- (id<AbstractJSONModelProtocol>)parseResponse:(id)responseObject {
    // TODO:
    return nil;
}

#pragma mark - WebApiRequestEncrypt protocol
#pragma mark : Optional
-(BOOL)isNeedEncrypt{
    return NO;
}

-(BOOL)isNeedDecrypt{
    return NO;
}

-(id)encrypt:(id)origninalData{
    // TODO:
    return origninalData;
}

-(id)decrypt:(id)encryptData{
    return encryptData;
}

#pragma mark -
-(instancetype)initWithSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                      withFailBlock:(WebApiRequestFailBlock)failBlock
{
    self = [super init];
    if( self ){
        _successBlock = successBlock;
        _failBlock = failBlock;
    }
    return self;
}

-(void)dealloc{
    [self terminate];
}

-(void)send{
    
#ifdef D_Debug
    NSLog(@"\n\n******** WebApi : %@ -- 傳送開始 **********\n" , NSStringFromClass([self class]));
#endif
    
    // 處理加密
    NSDictionary *params = [self setParams];
#ifdef D_Debug
    NSLog(@"\n\nparams :\n%@\n\n\n" ,params);
#endif
    if( [self isNeedEncrypt] == YES ){
        params = [self encrypt:params];
    }
    
    // 取得 url string
    EnumUrlType type = [self setUrlType];
    
    if( type == EnumUrlType_Custom ){
        [[WebsiteBase sharedInstance] createWebApiRequestWithIsNeedHeader:[self isNeedHeader] 
                                                              withTimeOut:[self setTimeOut] 
                                                                 WithType:[self setWebsiteType] 
                                                            withUrlString:[self customUrl] 
                                                              withTailUrl:[self setTailUrl] 
                                                               withParams:params 
                                                          withRequestType:[self setRequestType] 
                                                        withResponseBlock:[self setResponseType] 
                                                         withSuccessBlock:^(NSError *error, id result) {
                                                             __strong __typeof(self)strongSelf = self;
                                                             [strongSelf doSuccessWithError:error 
                                                                                 withResult:result];
                                                         } 
                                                            withFailBlock:^(NSError *error, NSNumber *errorCode, NSString *errorMsg) {
                                                                __strong __typeof(self)strongSelf = self;
                                                                [strongSelf doFailWithError:error 
                                                                              withErrorCode:errorCode 
                                                                              withResultMsg:errorMsg];
                                                            }];
    }
    else{
        [[WebsiteBase sharedInstance] createWebApiRequestWithIsNeedHeader:[self isNeedHeader] 
                                                              withTimeOut:[self setTimeOut] 
                                                                 WithType:[self setWebsiteType] 
                                                                  withUrl:[self setUrlType] 
                                                              withTailUrl:[self setTailUrl] 
                                                               withParams:params 
                                                          withRequestType:[self setRequestType] 
                                                         withResponseType:[self setResponseType] withSuccessBlock:^(NSError *error, id result) {
                                                             __strong __typeof(self)strongSelf = self;
                                                             [strongSelf doSuccessWithError:error 
                                                                                 withResult:result];
                                                         } withFailBlock:^(NSError *error, NSNumber *errorCode, NSString *errorMsg) {
                                                             __strong __typeof(self)strongSelf = self;
                                                             [strongSelf doFailWithError:error 
                                                                           withErrorCode:errorCode 
                                                                           withResultMsg:errorMsg];
                                                         }];
        
#ifdef D_Debug
        NSLog(@"\n******** WebApi : %@ --   傳送結束 **********\n\n" , NSStringFromClass([self class]));
#endif
    }
}

-(void)terminate{
    _successBlock = nil;
    _failBlock = nil;
}

#pragma mark - Private
-(void)doSuccessWithError:(NSError *)error 
               withResult:(id)result{
    if( [self isNeedDecrypt] == YES ){
        result = [self decrypt:result];
    }
    id model = [self parseResponse:result];
#ifdef D_Debug
    NSLog(@"\n\n******** WebApi : %@ -- 接收開始（成功） **********\n" , NSStringFromClass([self class]));
    NSLog(@"Response object :\n\n%@\n\n" , model);
    NSLog(@"\n******** WebApi : %@ --   接收結束（成功） **********\n\n" , NSStringFromClass([self class]));
#endif
    if( model ){
        if( _delegate && [_delegate respondsToSelector:@selector(doSomethingAfterGetResult:)] ){
            [_delegate doSomethingAfterGetResult:model];
        }
        
        // 線上環境避免暴露更多資訊，變更 error description 的內容（直接取代）
#ifndef D_Debug
        if( error ){
            NSDictionary *details = @{NSLocalizedDescriptionKey:@"接收內容有誤"};
            error = [NSError errorWithDomain:@"NSError_Domain_Parser_Model_Fail_710" 
                                        code:EnumWebsiteBase_ErrorCode_SuccessResponseError 
                                    userInfo:details];
        }
#endif
        if( _successBlock ){
            _successBlock( error , model );
        }
    }
    else{
        NSDictionary *details = @{NSLocalizedDescriptionKey:@"Result Parser FAIL !!!!"};
        NSError *error = [NSError errorWithDomain:@"NSError_Domain_Parser_Model_Fail_700"
                                             code:EnumWebsiteBase_ErrorCode_ParserFail
                                         userInfo:details];
        if( _failBlock ){
            _failBlock( error , @(EnumWebsiteBase_ErrorCode_ParserFail) , @"Result Parser FAIL !!!!" );
        }
    }
}

-(void)doFailWithError:(NSError *)error 
         withErrorCode:(NSNumber *)errorCode 
         withResultMsg:(NSString *)errorMsg{
#ifdef D_Debug
    NSLog(@"\n\n******** WebApi : %@ -- 接收開始（失敗） **********\n*" , NSStringFromClass([self class]));
    NSLog(@"\n* Response object :\n*\n* %@\n" , error.description);
    NSLog(@"\n* Response object :\n*\n*  ErrorCode :  (%@)\n*  ErrorMsg  :  %@\n*\n******** WebApi : %@ --   接收結束（失敗） **********\n\n" , errorCode , errorMsg , NSStringFromClass([self class]));
#else
    errorMsg = @"網路連線失敗";
#endif
    if( _failBlock ){
        _failBlock( error , errorCode , errorMsg );
    }
}

@end


#pragma mark - WebApiRequest Pro
@interface WebApiRequestPro()
@property (nonatomic , weak) id requestDelegate;
@end

@implementation WebApiRequestPro
#pragma mark - WebsiteRequest protocol
#pragma mark : Optional
-(NSTimeInterval)setTimeOut{
    return kWebsiteBaseTimeoutDefault;
}

-(NSString *)customUrl{
    return @"";
}

-(EnumUrlType)setUrlType{
    return EnumUrlType_Custom;
}

-(EnumRequestType)setRequestType{
    return EnumRequestType_Json;
}

-(EnumResponseType)setResponseType{
    return EnumResponseType_Json;
}

#pragma mark : Required
-(BOOL)isNeedHeader{
    return YES;
}

-(EnumWebsiteType)setWebsiteType{
    return EnumWebsiteType_Post;
}

-(NSString *)setTailUrl{
    return @"";
}

-(NSDictionary *)setParams{
    return nil;
}

- (id<AbstractJSONModelProtocol>)parseResponse:(id)responseObject {
    // TODO:
    return nil;
}

#pragma mark - WebApiRequestEncrypt protocol
#pragma mark : Optional
-(BOOL)isNeedEncrypt{
    return NO;
}

-(BOOL)isNeedDecrypt{
    return NO;
}

-(id)encrypt:(id)origninalData{
    // TODO:
    return origninalData;
}

-(id)decrypt:(id)encryptData{
    return encryptData;
}

#pragma mark -
-(instancetype)initWithDelegate:(id)delegate{
    self = [super init];
    if( self ){
        _requestDelegate = delegate;
    }
    return self;
}

-(void)dealloc{
    [self terminate];
}

-(void)send{
    
#ifdef D_Debug
    NSLog(@"\n\n******** WebApi : %@ -- 傳送開始 **********\n" , NSStringFromClass([self class]));
#endif
    
    // 處理加密
    NSDictionary *params = [self setParams];
#ifdef D_Debug
    NSLog(@"\n\nparams :\n%@\n\n\n" ,params);
#endif
    if( [self isNeedEncrypt] == YES ){
        params = [self encrypt:params];
    }
    
    // 取得 url string
    EnumUrlType type = [self setUrlType];
    
    if( type == EnumUrlType_Custom ){
        [[WebsiteBase sharedInstance] createWebApiRequestWithIsNeedHeader:[self isNeedHeader] 
                                                              withTimeOut:[self setTimeOut] 
                                                                 WithType:[self setWebsiteType]
                                                            withUrlString:[self customUrl]
                                                              withTailUrl:[self setTailUrl]
                                                               withParams:params
                                                          withRequestType:[self setRequestType] 
                                                        withResponseBlock:[self setResponseType]
                                                         withSuccessBlock:^(NSError *error, id result) {
                                                             __strong __typeof(self)strongSelf = self;
                                                             [strongSelf doSuccessWithError:error
                                                                                 withResult:result];
                                                         }
                                                            withFailBlock:^(NSError *error, NSNumber *errorCode, NSString *errorMsg) {
                                                                __strong __typeof(self)strongSelf = self;
                                                                [strongSelf doFailWithError:error
                                                                              withErrorCode:errorCode
                                                                              withResultMsg:errorMsg];
                                                            }];
    }
    else{
        [[WebsiteBase sharedInstance] createWebApiRequestWithIsNeedHeader:[self isNeedHeader] 
                                                              withTimeOut:[self setTimeOut] 
                                                                 WithType:[self setWebsiteType]
                                                                  withUrl:[self setUrlType]
                                                              withTailUrl:[self setTailUrl]
                                                               withParams:params 
                                                          withRequestType:[self setRequestType] 
                                                         withResponseType:[self setResponseType]  
                                                         withSuccessBlock:^(NSError *error, id result) {
                                                             __strong __typeof(self)strongSelf = self;
                                                             [strongSelf doSuccessWithError:error
                                                                                 withResult:result];
                                                         }
                                                            withFailBlock:^(NSError *error, NSNumber *errorCode, NSString *errorMsg) {
                                                                __strong __typeof(self)strongSelf = self;
                                                                [strongSelf doFailWithError:error
                                                                              withErrorCode:errorCode
                                                                              withResultMsg:errorMsg];
                                                            }];
#ifdef D_Debug
        NSLog(@"\n******** WebApi : %@ --   傳送結束 **********\n\n" , NSStringFromClass([self class]));
#endif
    }
}

-(void)terminate{
    self.requestDelegate = nil;
    self.responseDelegate = nil;
}

#pragma mark - Private
-(void)doSuccessWithError:(NSError *)error
               withResult:(id)result{
    if( [self isNeedDecrypt] == YES ){
        result = [self decrypt:result];
    }
    id model = [self parseResponse:result];
#ifdef D_Debug
    NSLog(@"\n\n******** WebApi : %@ -- 接收開始（成功） **********\n" , NSStringFromClass([self class]));
    NSLog(@"Response object :\n\n%@\n\n" , model);
    NSLog(@"\n******** WebApi : %@ --   接收結束（成功） **********\n\n" , NSStringFromClass([self class]));
#endif
    if( model ){
        
        // 線上環境避免暴露更多資訊，變更 error description 的內容（直接取代）
#ifndef D_Debug
        if( error ){
            NSDictionary *details = @{NSLocalizedDescriptionKey:@"接收內容有誤"};
            error = [NSError errorWithDomain:@"NSError_Domain_Parser_Model_Fail_710" 
                                        code:EnumWebsiteBase_ErrorCode_SuccessResponseError 
                                    userInfo:details];
        }
#endif
        
        // Webapi 可以有自己內部的行為，在傳送資料出去前
        if( [self.responseDelegate respondsToSelector:@selector(doSomethingAfterGetResult:)] ){
            [self.responseDelegate performSelector:@selector(doSomethingAfterGetResult:) withObject:model];
        }
        if( self.requestDelegate ){
            if( [self.requestDelegate respondsToSelector:self.successSelector] ){
                IMP imp = [(NSObject *)self.requestDelegate methodForSelector:self.successSelector];
                void (*func)( id , SEL , NSError * , id ) = (void *)imp;
                func( self.requestDelegate , self.successSelector , error , model );
            }
        }
    }
    else{
        NSDictionary *details = @{NSLocalizedDescriptionKey:@"Result Parser FAIL !!!!"};
        NSError *error = [NSError errorWithDomain:@"NSError_Domain_Parser_Model_Fail_700"
                                             code:EnumWebsiteBase_ErrorCode_ParserFail
                                         userInfo:details];
        if( self.requestDelegate ){
            if( [self.requestDelegate respondsToSelector:self.failSelector] ){
                IMP imp = [(NSObject *)self.requestDelegate methodForSelector:self.failSelector];
                void (*func)( id , SEL , NSError * , NSNumber * , NSString * ) = (void *)imp;
                func( self.requestDelegate , self.failSelector , error , @(EnumWebsiteBase_ErrorCode_ParserFail) , @"Result Parser FAIL !!!!" );
            }
        }
    }
}

-(void)doFailWithError:(NSError *)error
         withErrorCode:(NSNumber *)errorCode
         withResultMsg:(NSString *)errorMsg{
#ifdef D_Debug
    NSLog(@"\n\n******** WebApi : %@ -- 接收開始（失敗） **********\n*" , NSStringFromClass([self class]));
    NSLog(@"\n* Response object :\n*\n* %@\n" , error.description);
    NSLog(@"\n* Response object :\n*\n*  ErrorCode :  (%@)\n*  ErrorMsg  :  %@\n*\n******** WebApi : %@ --   接收結束（失敗） **********\n\n" , errorCode , errorMsg , NSStringFromClass([self class]));
#else
    errorMsg = @"網路連線失敗";
#endif
    if( self.requestDelegate ){
        if( [self.requestDelegate respondsToSelector:self.failSelector] ){
            IMP imp = [(NSObject *)self.requestDelegate methodForSelector:self.failSelector];
            void (*func)( id , SEL , NSError * , NSNumber * , NSString * ) = (void *)imp;
            func( self.requestDelegate , self.failSelector , error , errorCode , errorMsg );
        }
    }
}


@end
