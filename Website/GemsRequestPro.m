//
//  GemsRequestPro.m
//  Website
//
//  Created by coodychou on 2018/9/28.
//  Copyright © 2018 Coody. All rights reserved.
//

#import "GemsRequestPro.h"

@implementation GemsResultPro
@end

@interface GemsRequestPro()
@property (assign , nonatomic) NSInteger gems;
@end

@implementation GemsRequestPro
-(instancetype)initWithDelegate:(id<WebApiRequestProProtocol , WebApiResponseProtocol>)delegate{
    self = [super initWithDelegate:delegate];
    if( self ){
        self.successSelector = @selector(getGemsSuccess:withResult:);
        self.failSelector = @selector(getGemsFail:withErrorCode:withErrorMsg:);
    }
    return self;
}

-(void)setGems:(NSInteger)gems{
    _gems = gems;
}

#pragma mark - WebApiRequest protocol
-(EnumWebsiteType)setWebsiteType{
    return EnumWebsiteType_Get;
}

-(EnumUrlType)setUrlType{
    return EnumUrlType_Home;
}

-(NSString *)setTailUrl{
    return @"commerce/exchange/gems";
}

-(NSDictionary *)setParams{
    return @{ @"quantity" : [NSNumber numberWithInteger:self.gems] };
}

-(id<AbstractJSONModelProtocol>)parseResponse:(id)responseObject{
    NSError *error = nil;
    GemsResultPro *result = [[GemsResultPro alloc] initWithDictionary:responseObject
                                                                error:&error];
    return result;
}

#pragma mark - WebApiResponse PRotocol
// Webapi 可以有自己內部的行為，在傳送資料出去前
-(void)doSomethingAfterGetResult:(id)result{
    
}

@end
