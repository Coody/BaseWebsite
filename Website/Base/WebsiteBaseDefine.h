//
//  WebsiteBaseDefine.h
//  Website
//
//  Created by Coody on 2017/10/9.
//  Copyright © 2017年 Coody. All rights reserved.
//

#ifndef WebsiteBaseDefine_h
#define WebsiteBaseDefine_h

typedef enum:int{
    EnumWebsiteType_Get = 0,
    EnumWebsiteType_Post = 1,
}EnumWebsiteType;

typedef enum : int{
    EnumUrlType_Custom = 0,
    EnumUrlType_Home = 1,
    EnumUrlType_Datainfo,
    EnumUrlType_Datainfo_Member,
    EnumUrlType_Download
}EnumUrlType;

typedef enum : int{
    EnumRequestType_Json = 0,
    EnumRequestType_Common = 1
}EnumRequestType;

typedef enum : int{
    EnumResponseType_Json = 0,
    EnumResponseType_Common = 1
}EnumResponseType;

typedef void(^WebApiRequestSuccessBlock)(NSError *error , id result);
typedef void(^WebApiRequestFailBlock)(NSError *error , NSNumber *errorCode , NSString *errorMsg);

#endif /* WebsiteBaseDefine_h */
