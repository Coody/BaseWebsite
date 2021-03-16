//
//  GemsRequest.m
//  Website
//
//  Created by Coody on 2017/10/9.
//  Copyright © 2017年 Coody. All rights reserved.
//

#import "GemsRequest.h"

@implementation GemsResult
@end

@interface GemsRequest()
@property (assign , nonatomic) NSInteger gems;
@end

@implementation GemsRequest

-(instancetype)initWithSuccessBlock:(WebApiRequestSuccessBlock)successBlock
                      withFailBlock:(WebApiRequestFailBlock)failBlock{
    self = [super initWithSuccessBlock:successBlock withFailBlock:failBlock];
    if( self ){
        
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
    GemsResult *result = [[GemsResult alloc] initWithDictionary:responseObject
                                                          error:&error];
    return result;
}

@end
