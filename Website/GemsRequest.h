//
//  GemsRequest.h
//  Website
//
//  Created by Coody on 2017/10/9.
//  Copyright © 2017年 Coody. All rights reserved.
//

#import "WebApiRequest.h"

#pragma mark - Properties
@interface GemsResult : JSONModel
@property (assign , nonatomic) int coins_per_gem;
@property (assign , nonatomic) NSInteger quantity;
@end

@interface GemsRequest : WebApiRequest <WebApiRequestProtocol>

-(void)setGems:(NSInteger)gems;

@end
