//
//  WebsiteBase.h
//  Website
//
//  Created by Coody on 2017/10/8.
//  Copyright © 2017年 Coody. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WebsiteBaseDefine.h"

extern NSTimeInterval const kWebsiteBaseTimeoutMAX;
extern NSTimeInterval const kWebsiteBaseTimeoutMin;
extern NSTimeInterval const kWebsiteBaseTimeoutDefault;

//
extern NSString *const kWebsitePostString;
extern NSString *const kWebsiteGetString;

//
extern NSString *const kHomeUrlString;
extern NSString *const kDatainfoUrlString;
extern NSString *const kDatainfoMemberUrlString;
extern NSString *const kDownloadUrlString;

#pragma mark - 
@interface WebsiteBase : NSObject

+(instancetype)sharedInstance;

// config
-(void)setTimeout:(NSUInteger)second;
/** 是否允許私有憑證？ debug 可以設定 release 強制為 YES*/
-(void)setIsAllowInvalidCertificates:(BOOL)isAllow;
/** 驗證證書中的 domain 這一個字段。 debug 可以設定 release 強制為 YES */
-(void)setValidatesDomainName:(BOOL)validatesDomainName;

// Url
-(void)setUrlString:(NSString *)urlString withKey:(NSString *)urlKey;
-(NSString *)getUrlString:(NSString *)urlKey;
-(void)setHomeUrl:(NSString *)homeUrl;
-(void)setDatainfoUrl:(NSString *)datainfoUrl;
-(void)setDownloadUrl:(NSString *)downloadUrl;

// Header
-(void)setHeader:(NSDictionary *)headerDic;
-(void)addHeader:(NSDictionary *)headerDic;
-(BOOL)removeHeader:(NSString *)headerKey;
-(void)clearHeader;

// Mine Type
-(void)setRespAcceptableContentTypes:(NSArray *)ary;

#pragma mark - Service
/**
 * @brief 1.1 - Post , Home url 
 */
-(void)createWebApiHomeUrlAndPostRequestWithTailUrl:(NSString *)tailUrl
                                         withParams:(NSDictionary *)params
                                   withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                                      withFailBlock:(WebApiRequestFailBlock)failBlock;

/**
 * @brief 1.2 - Post , Home url , request Type
 * @params tailUrl , params , requestType , successBlock , failBlock
 */
-(void)createWebApiHomeUrlAndPostRequestWithTailUrl:(NSString *)tailUrl
                                         withParams:(NSDictionary *)params 
                                    withRequestType:(EnumRequestType)requestType 
                                   withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                                      withFailBlock:(WebApiRequestFailBlock)failBlock;

/**
 * @brief 1.3 - Post , Home url , request Type , response Type 
 * @params tailUrl , params , requestType , responseType , successBlock , failBlock
 */
-(void)createWebApiHomeUrlAndPostRequestWithTailUrl:(NSString *)tailUrl
                                         withParams:(NSDictionary *)params 
                                    withRequestType:(EnumRequestType)requestType 
                                   withResponseType:(EnumResponseType)responseType 
                                   withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                                      withFailBlock:(WebApiRequestFailBlock)failBlock;

/**
 * @brief 1.4 - Webapi request always need header
 */
-(void)createWebApiRequestWithType:(EnumWebsiteType)type
                           withUrl:(EnumUrlType)urlType 
                       withTailUrl:(NSString *)tailUrl
                        withParams:(NSDictionary *)params
                  withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                     withFailBlock:(WebApiRequestFailBlock)failBlock;

/**
 * @brief   1.5 WebsiteRequest Use EnumUrlType Base
 * @params  isNeedHeader ,
 *          type(Post/Get) ,
 *          urlType(Home/DataInfo/...) ,
 *          tailUrl ,
 *          params ,
 *          SuccessBlock ,
 *          FailBlock
 */
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader 
                                  WithType:(EnumWebsiteType)type
                                   withUrl:(EnumUrlType)urlType
                               withTailUrl:(NSString *)tailUrl
                                withParams:(NSDictionary *)params
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock;

/**
 * @brief   1.6 WebsiteRequest Base 
 * @params  isNeedHeader ,
 *          type(Post/Get) ,
 *          urlType(Home/DataInfo/...) ,
 *          tailUrl ,
 *          params ,
 *          requestType(Json/Common) ,
 *          SuccessBlock ,
 *          FailBlock
 */
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader 
                                  WithType:(EnumWebsiteType)type
                                   withUrl:(EnumUrlType)urlType
                               withTailUrl:(NSString *)tailUrl
                                withParams:(NSDictionary *)params 
                           withRequestType:(EnumRequestType)requestType 
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock;

/**
 * @brief   1.7 WebsiteRequest Base 
 * @params  isNeedHeader ,
 *          type(Post/Get) ,
 *          urlType(Home/DataInfo/...) ,
 *          tailUrl ,
 *          params ,
 *          requestType(Json/Common) ,
 *          responseType(Json/Common) ,
 *          SuccessBlock ,
 *          FailBlock
 */
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader
                               withTimeOut:(NSTimeInterval)timeOut 
                                  WithType:(EnumWebsiteType)type
                                   withUrl:(EnumUrlType)urlType
                               withTailUrl:(NSString *)tailUrl
                                withParams:(NSDictionary *)params 
                           withRequestType:(EnumRequestType)requestType 
                          withResponseType:(EnumResponseType)responseType 
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock;

/**
 * @brief   1,8 WebsiteRequest Base 
 * @params  isNeedHeader ,
 *          time out,
 *          type(Post/Get) ,
 *          frontUrl(Custom front url string),
 *          tailUrl ,
 *          params ,
 *          requestType(Json/Common) ,
 *          SuccessBlock ,
 *          FailBlock
 */
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader 
                               withTimeOut:(NSTimeInterval)timeOut 
                                  WithType:(EnumWebsiteType)type 
                             withUrlString:(NSString *)urlString
                               withTailUrl:(NSString *)tailUrl
                                withParams:(NSDictionary *)params 
                           withRequestType:(EnumRequestType)requestType 
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock;

/**
 * @brief   1.9 WebsiteRequest Base 
 * @params  isNeedHeader ,
 *          time out,
 *          type(Post/Get) ,
 *          frontUrl(Custom front url string),
 *          tailUrl ,
 *          params ,
 *          requestType(Json/Common) ,
 *          responseType(Json/Common) ,
 *          SuccessBlock ,
 *          FailBlock
 */
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader 
                               withTimeOut:(NSTimeInterval)timeOut 
                                  WithType:(EnumWebsiteType)type 
                             withUrlString:(NSString *)urlString
                               withTailUrl:(NSString *)tailUrl
                                withParams:(NSDictionary *)params 
                           withRequestType:(EnumRequestType)requestType 
                         withResponseBlock:(EnumResponseType)responseType
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock;

/**
 * @brief   1.10 WebsiteRequest Base 
 * @params  isNeedHeader ,
 *          time out,
 *          type(Post/Get) ,
 *          total url ,
 *          params ,
 *          requestType(Json/Common) ,
 *          SuccessBlock ,
 *          FailBlock
 */
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader 
                               withTimeOut:(NSTimeInterval)timeOut 
                                  WithType:(EnumWebsiteType)type
                              withTotalUrl:(NSString *)totalUrl
                                withParams:(NSDictionary *)params 
                           withRequestType:(EnumRequestType)requestType 
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock;

/**
 * @brief   1.11 WebsiteRequest Base 
 * @params  isNeedHeader ,
 *          time out,
 *          type(Post/Get) ,
 *          total url ,
 *          params ,
 *          requestType(Json/Common) ,
 *          responseType(Json/Common) ,
 *          SuccessBlock ,
 *          FailBlock
 */
-(void)createWebApiRequestWithIsNeedHeader:(BOOL)isNeedHeader 
                               withTimeOut:(NSTimeInterval)timeOut 
                                  WithType:(EnumWebsiteType)type
                              withTotalUrl:(NSString *)totalUrl
                                withParams:(NSDictionary *)params 
                           withRequestType:(EnumRequestType)requestType 
                          withResponseType:(EnumResponseType)responseType
                          withSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                             withFailBlock:(WebApiRequestFailBlock)failBlock;

@end
