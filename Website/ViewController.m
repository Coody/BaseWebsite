//
//  ViewController.m
//  Website
//
//  Created by Coody on 2017/10/8.
//  Copyright © 2017年 Coody. All rights reserved.
//

#import "ViewController.h"

#import "WebsiteBase.h"

#import "GemsRequestPro.h"

@interface ViewController ()<GemsRequestProProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[WebsiteBase sharedInstance] setHomeUrl:@"https://api.guildwars2.com/v2"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self ask];
}

-(void)ask{
    GemsRequestPro *request = [[GemsRequestPro alloc] initWithDelegate:self];
    [request setGems:100];
    [request send];
}

#pragma mark - WebApiRequestPro's Delegate
-(void)getGemsSuccess:(NSError *)error withResult:(GemsResultPro *)result{
    if( error ){
        NSLog(@" Response Success error: %@" , error );
        return;
    }
    NSLog(@" GemsResult: %@" , result );
}

-(void)getGemsFail:(NSError *)error withErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg{
    NSLog(@" Response Success error: %@(%@)" , errorMsg , errorCode );
}

@end
