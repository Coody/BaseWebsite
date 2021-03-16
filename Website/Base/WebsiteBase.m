//
//  WebsiteBase.m
//  Website
//
//  Created by Coody on 2017/10/8.
//  Copyright © 2017年 Coody. All rights reserved.
//

#import "WebsiteBase.h"

// for AFNetworking
#import "AFNetworking.h"

NSTimeInterval const kWebsiteBaseTimeoutMAX = 60.0f;
NSTimeInterval const kWebsiteBaseTimeoutMin = 1.0f;
NSTimeInterval const kWebsiteBaseTimeoutDefault = 20.0f;

NSString *const kWebsitePostString = @"POST";
NSString *const kWebsiteGetString = @"GET";

NSString *const kHomeUrlString = @"HOME";
NSString *const kDatainfoUrlString = @"DATAINFO";
NSString *const kDatainfoMemberUrlString = @"DATAINFO_MEMBER";
NSString *const kDownloadUrlString = @"DOWNLOAD";

@interface WebsiteBase()
@property (nonatomic , strong) NSMutableDictionary *urlDic;
@property (nonatomic , strong) NSDictionary *header;
@property (nonatomic , assign) NSTimeInterval timeoutSecond;
@property (nonatomic , assign) BOOL isAllowInvalidCertificates;
@property (nonatomic , assign) BOOL validatesDomainName;
@property (nonatomic , strong) NSArray *respAcceptableContentTypes;

@end

@implementation WebsiteBase

+(instancetype)sharedInstance{
    static WebsiteBase *instance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once( &onceToken , ^{
        instance = [[WebsiteBase alloc] init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if( self ){
        _urlDic = [[NSMutableDictionary alloc] init];
        _timeoutSecond = kWebsiteBaseTimeoutDefault;
    }
    return self;
}

-(void)setTimeout:(NSUInteger)second{
    if( second <= kWebsiteBaseTimeoutMin ){
        second = kWebsiteBaseTimeoutMin;
    }
    else if( second > kWebsiteBaseTimeoutMAX ){
        second = kWebsiteBaseTimeoutMAX;
    }
    self.timeoutSecond = second;
}

-(void)setIsAllowInvalidCertificates:(BOOL)isAllow{
    // FIXME: 暫時都開放（讓所有憑證都允許是非常危險的事情！）
    // FIXME: 暫時都開放（讓所有憑證都允許是非常危險的事情！）
    // FIXME: 暫時都開放（讓所有憑證都允許是非常危險的事情！）
    // FIXME: 因為很重要所以寫三次
    //#ifdef D_Debug
    _isAllowInvalidCertificates = isAllow;
    //#else
    //    _isAllowInvalidCertificates = NO;
    //#endif
}

-(void)setValidatesDomainName:(BOOL)validatesDomainName{
    // FIXME: 暫時都開放（驗證證書中的 domain 這一個字段）
    // FIXME: 暫時都開放（驗證證書中的 domain 這一個字段）
    // FIXME: 暫時都開放（驗證證書中的 domain 這一個字段）
    // FIXME: 因為很重要所以寫三次
    //    #ifdef D_Debug
    _validatesDomainName = validatesDomainName;
    //#else
    //    _validatesDomainName = YES;
    //#endif
}

#pragma mark - Set Url
-(void)setUrlString:(NSString *)urlString withKey:(NSString *)urlKey{
    if( urlString == nil || [urlString isEqualToString:@""] || urlKey == nil || [urlKey isEqualToString:@""] ){
        NSLog(@"");
    }
    else{
        [self.urlDic setValue:urlString forKey:urlKey];
    }
}

-(NSString *)getUrlString:(NSString *)urlKey{
    NSString *customUrl = @"";
    NSString *tempUrl = [self.urlDic objectForKey:urlKey];
    if( tempUrl ){
        customUrl = [tempUrl copy];
    }
    return customUrl;
}

-(void)setHomeUrl:(NSString *)homeUrl{
    [self setUrlString:homeUrl withKey:kHomeUrlString];
}

-(void)setDatainfoUrl:(NSString *)datainfoUrl{
    [self setUrlString:datainfoUrl withKey:kDatainfoUrlString];
}

-(void)setDownloadUrl:(NSString *)downloadUrl{
    [self setUrlString:downloadUrl withKey:kDownloadUrlString];
}

-(void)setHeader:(NSDictionary *)headerDic{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    for( NSString *key in headerDic.allKeys ){
        if( [headerDic objectForKey:key] ){
            [tempDic setObject:[headerDic objectForKey:key] forKey:key];
        }
    }
    if( [tempDic count] > 0 ){
        _header = [tempDic copy];
    }
    else{
        _header = nil;
    }
}

-(void)addHeader:(NSDictionary *)headerDic{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    if( _header ){
        [tempDic setDictionary:_header];
    }
    for ( NSString *key in headerDic.allKeys ) {
        if( [headerDic objectForKey:key] ){
            [tempDic setObject:[headerDic objectForKey:key] forKey:key];
        }
    }
    _header = [tempDic copy];
}

-(BOOL)removeHeader:(NSString *)headerKey{
    BOOL hasValue = NO;
    NSString *value = [_header objectForKey:headerKey];
    if( value ){
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:_header];
        [tempDic removeObjectForKey:headerKey];
        _header = [tempDic copy];
        hasValue = YES;
    }
    return hasValue;
}

-(void)clearHeader{
    _header = nil;
}

-(void)setRespAcceptableContentTypes:(NSArray *)ary{
    _respAcceptableContentTypes = ary;
}

#pragma mark - Private
-(NSString *)getTotalUrlWithType:(EnumUrlType)type withTailUrl:(NSString *)tailUrl{
    NSString *totalUrl = @"";
    NSString *urlString = nil;
    switch ( type ) {
        case EnumUrlType_Home:
        {
        urlString = [self.urlDic objectForKey:kHomeUrlString];
        }
            break;
        case EnumUrlType_Datainfo:
        {
        urlString = [self.urlDic objectForKey:kDatainfoUrlString];
        }
            break;
        case EnumUrlType_Download:
        {
        urlString = [self.urlDic objectForKey:kDownloadUrlString];
        }
            break;
        case EnumUrlType_Datainfo_Member:
        {
        urlString = [self.urlDic objectForKey:kDatainfoMemberUrlString];
        }
            break;
        default:
            NSLog(@"Warning ! wrong url type(%d)! PLEASE check it!!" , type);
            break;
    }
    totalUrl = [self getTotalUrlWithFrontUrl:urlString 
                                 withTailUrl:tailUrl];
    return [totalUrl copy];
}

-(NSString *)getTotalUrlWithFrontUrl:(NSString *)frontUrl withTailUrl:(NSString *)tailUrl{
    NSMutableString *totalUrl = [[NSMutableString alloc] init];
    if( frontUrl == nil || [frontUrl isEqualToString:@""] ){
        NSLog(@"Warning ! you have not set Front Url !!");
    }
    else{
        [totalUrl setString:frontUrl];
    }
    if( tailUrl == nil || [tailUrl isEqualToString:@""] ){
        NSLog(@"Warning !! Tail Url is NULL or EMPTY string!!");
    }
    else{
        if( [[totalUrl pathComponents].lastObject isEqualToString:@"/"] ){
            [totalUrl appendFormat:@"%@" , tailUrl];
        }
        else{
            [totalUrl appendFormat:@"/%@" , tailUrl];
        }
    }
    return [totalUrl copy];
}

#pragma mark - Service
// 1.1
-(void)createWebApiHomeUrlAndPostRequestWithTailUrl:(NSString *)tailUrl
                                         withParams:(NSDictionary *)params
                                   withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                                      withFailBlock:(WebApiRequestFailBlock)failBlock
{
    [self createWebApiRequestWithType:EnumWebsiteType_Post
                              withUrl:EnumUrlType_Home
                          withTailUrl:tailUrl
                           withParams:params
                     withSuccessBlock:successBlock
                        withFailBlock:failBlock];
}

// 1.2
-(void)createWebApiHomeUrlAndPostRequestWithTailUrl:(NSString *)tailUrl
                                         withParams:(NSDictionary *)params 
                                    withRequestType:(EnumRequestType)requestType 
                                   withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                                      withFailBlock:(WebApiRequestFailBlock)failBlock
{
    [self createWebApiRequestWithIsNeedHeader:YES 
                                  withTimeOut:self.timeoutSecond 
                                     WithType:EnumWebsiteType_Post 
                                      withUrl:EnumUrlType_Home 
                                  withTailUrl:tailUrl 
                                   withParams:params 
                              withRequestType:requestType 
                             withResponseType:EnumResponseType_Json 
                             withSuccessBlock:successBlock 
                                withFailBlock:failBlock];
}

// 1.3
-(void)createWebApiHomeUrlAndPostRequestWithTailUrl:(NSString *)tailUrl
                                         withParams:(NSDictionary *)params 
                                    withRequestType:(EnumRequestType)requestType 
                                   withResponseType:(EnumResponseType)responseType 
                                   withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                                      withFailBlock:(WebApiRequestFailBlock)failBlock
{
    [self createWebApiRequestWithIsNeedHeader:YES 
                                  withTimeOut:self.timeoutSecond 
                                     WithType:EnumWebsiteType_Post 
                                      withUrl:EnumUrlType_Home 
                                  withTailUrl:tailUrl 
                                   withParams:params 
                              withRequestType:requestType 
                             withResponseType:responseType 
                             withSuccessBlock:successBlock 
                                withFailBlock:failBlock];
}

// 1.4
-(void)createWebApiRequestWithType:(EnumWebsiteType)type
                           withUrl:(EnumUrlType)urlType
                       withTailUrl:(NSString *)tailUrl
                        withParams:(NSDictionary *)params
                  withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                     withFailBlock:(WebApiRequestFailBlock)failBlock
{
    
    [self createWebApiRequestWithIsNeedHeader:YES 
                                     WithType:type 
                                      withUrl:urlType 
                                  withTailUrl:tailUrl 
                                   withParams:params 
                             withSuccessBlock:successBlock 
                                withFailBlock:failBlock];
}

// 1.5
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader 
                                  WithType:(EnumWebsiteType)type
                                   withUrl:(EnumUrlType)urlType
                               withTailUrl:(NSString *)tailUrl
                                withParams:(NSDictionary *)params
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock
{
    [self createWebApiRequestWithIsNeedHeader:isNeedHeader 
                                     WithType:type 
                                      withUrl:urlType 
                                  withTailUrl:tailUrl 
                                   withParams:params 
                              withRequestType:EnumRequestType_Json 
                             withSuccessBlock:successBlock 
                                withFailBlock:failBlock];
}

// 1.6
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader 
                                  WithType:(EnumWebsiteType)type
                                   withUrl:(EnumUrlType)urlType
                               withTailUrl:(NSString *)tailUrl
                                withParams:(NSDictionary *)params 
                           withRequestType:(EnumRequestType)requestType 
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock
{
    NSString *totalUrl = [self getTotalUrlWithType:urlType withTailUrl:tailUrl];
    [self createWebApiRequestWithIsNeedHeader:isNeedHeader 
                                  withTimeOut:self.timeoutSecond 
                                     WithType:type 
                                 withTotalUrl:totalUrl 
                                   withParams:params 
                              withRequestType:requestType 
                             withSuccessBlock:successBlock 
                                withFailBlock:failBlock];
}

// 1.7
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader 
                               withTimeOut:(NSTimeInterval)timeOut 
                                  WithType:(EnumWebsiteType)type
                                   withUrl:(EnumUrlType)urlType
                               withTailUrl:(NSString *)tailUrl
                                withParams:(NSDictionary *)params 
                           withRequestType:(EnumRequestType)requestType 
                          withResponseType:(EnumResponseType)responseType 
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock
{
    NSString *totalUrl = [self getTotalUrlWithType:urlType withTailUrl:tailUrl];
    [self createWebApiRequestWithIsNeedHeader:isNeedHeader 
                                  withTimeOut:timeOut 
                                     WithType:type 
                                 withTotalUrl:totalUrl 
                                   withParams:params 
                              withRequestType:requestType 
                             withResponseType:responseType 
                             withSuccessBlock:successBlock 
                                withFailBlock:failBlock];
}

// 1.8
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader 
                               withTimeOut:(NSTimeInterval)timeOut 
                                  WithType:(EnumWebsiteType)type 
                             withUrlString:(NSString *)urlString
                               withTailUrl:(NSString *)tailUrl
                                withParams:(NSDictionary *)params 
                           withRequestType:(EnumRequestType)requestType 
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock{
    NSString *totalUrl = [self getTotalUrlWithFrontUrl:urlString withTailUrl:tailUrl];
    [self createWebApiRequestWithIsNeedHeader:isNeedHeader  
                                  withTimeOut:timeOut 
                                     WithType:type 
                                 withTotalUrl:totalUrl 
                                   withParams:params 
                              withRequestType:requestType 
                             withSuccessBlock:successBlock 
                                withFailBlock:failBlock];
}

// 1.9
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader 
                               withTimeOut:(NSTimeInterval)timeOut 
                                  WithType:(EnumWebsiteType)type 
                             withUrlString:(NSString *)urlString
                               withTailUrl:(NSString *)tailUrl
                                withParams:(NSDictionary *)params 
                           withRequestType:(EnumRequestType)requestType 
                         withResponseBlock:(EnumResponseType)responseType
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock
{
    NSString *totalUrl = [self getTotalUrlWithFrontUrl:urlString withTailUrl:tailUrl];
    [self createWebApiRequestWithIsNeedHeader:isNeedHeader 
                                  withTimeOut:timeOut 
                                     WithType:type
                                 withTotalUrl:totalUrl
                                   withParams:params 
                              withRequestType:requestType
                             withResponseType:responseType
                             withSuccessBlock:successBlock
                                withFailBlock:failBlock];
}

/**
 * @brief 1.10 isNeedheader , urlType(get,post) , totalUrl , params , requestType(Json/Common) , 
 */
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader 
                               withTimeOut:(NSTimeInterval)timeOut 
                                  WithType:(EnumWebsiteType)type
                              withTotalUrl:(NSString *)totalUrl
                                withParams:(NSDictionary *)params 
                           withRequestType:(EnumRequestType)requestType 
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock
{
    [self createWebApiRequestWithIsNeedHeader:isNeedHeader 
                                  withTimeOut:timeOut 
                                     WithType:type
                                 withTotalUrl:totalUrl
                                   withParams:params 
                              withRequestType:requestType
                             withResponseType:EnumResponseType_Json
                             withSuccessBlock:successBlock
                                withFailBlock:failBlock];
}

// 1.11
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader 
                               withTimeOut:(NSTimeInterval)timeOut 
                                  WithType:(EnumWebsiteType)type
                              withTotalUrl:(NSString *)totalUrl
                                withParams:(NSDictionary *)params 
                           withRequestType:(EnumRequestType)requestType 
                          withResponseType:(EnumResponseType)responseType
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock
{
#ifdef D_Debug
    NSLog(@"\n======================================================\n  Send to full url :\n  %@  \n======================================================\n\n\n" , totalUrl);
#endif
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    switch ( requestType ) {
        case EnumRequestType_Json:
        {
        manager.requestSerializer = [AFJSONRequestSerializer new];
        //            [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        }
            break;
        case EnumRequestType_Common:
        default:
        {
        manager.requestSerializer = [AFHTTPRequestSerializer new];
        //            [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        }
            break;
    }
    
    switch ( responseType ) {
        case EnumResponseType_Json:
        {
        manager.responseSerializer = [AFJSONResponseSerializer new];
        ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
        
        if (_respAcceptableContentTypes && [_respAcceptableContentTypes count] > 0){
            
            NSMutableSet *newSet = [NSMutableSet set];
            newSet.set = manager.responseSerializer.acceptableContentTypes;
            
            for (NSString *type in _respAcceptableContentTypes) {
                [newSet addObject:type];
            }
            
            manager.responseSerializer.acceptableContentTypes = newSet;
            
        }
        
        }
            break;
        case EnumResponseType_Common:
        default:
        {
        manager.responseSerializer = [AFHTTPResponseSerializer new];
        }
            break;
    }
    //    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    // 設定 timeout
    [manager.requestSerializer setTimeoutInterval:timeOut];
    
    if( isNeedHeader && self.header != nil ){
#ifdef D_Debug
        NSLog(@"\nHeader :\n%@\n\n\n" , self.header);
#endif
        for( NSString *key in self.header.allKeys ){
            [manager.requestSerializer setValue:[self.header objectForKey:key]
                             forHTTPHeaderField:key];
        }
    }
    
    // TODO: 這段要拔出來另外優化
    // 處理 body
    switch (type) {
        case EnumWebsiteType_Get:
        {
        [manager GET:totalUrl
          parameters:params
            progress:nil
             success:
         ^(NSURLSessionTask *task, id responseObject) {
             successBlock( nil , responseObject);
         }
             failure:
         ^(NSURLSessionTask *operation, NSError *error) {
             failBlock( error , @(error.code) , error.description );
         }];
        }
            break;
        case EnumWebsiteType_Post:
        default:
        {
        // TODO: 優化加入 progress 功能
        [manager POST:totalUrl
           parameters:params 
             progress:nil
              success:
         ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             successBlock( nil , responseObject );
         }
              failure:
         ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef D_Debug
             NSLog(@"\n\n**********  WebApi Fail : %@  **********\n\bError :\n%@\n\n\n" , NSStringFromClass([self class]) , error);
#endif
             NSInteger statusCode = 0;
             if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                 NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                 statusCode = response.statusCode;
             }
             failBlock( error , @(statusCode) , error.description );
         }];
        }
            break;
    }
}

@end
