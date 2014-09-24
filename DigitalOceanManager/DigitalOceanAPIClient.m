//
//  DigitalOceanAPIClient.m
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 01.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import "DigitalOceanAPIClient.h"

#import "AFJSONRequestOperation.h"


@implementation DigitalOceanAPIClient

NSString * const kAFDigitalOceanAPIBaseURLString = @"https://api.digitalocean.com/v2/";

+ (DigitalOceanAPIClient *)sharedClient {
    static DigitalOceanAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAFDigitalOceanAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    [self getCreadentials];
    
    return self;
}

- (void)getCreadentials
{
    if (!self.keychain) {
        self.keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"DigitalOcean" accessGroup:nil];
    }
    
    self.apiKey = [self.keychain objectForKey:(__bridge id)kSecValueData];
    
    [self checkForCreadentials];
}

-(void)setApiKey:(NSString *)apiKey
{
    if (!self.keychain) {
        self.keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"DigitalOcean" accessGroup:nil];
    }
    
    if ([apiKey isEqualToString:@""]) {
        _apiKey = nil;
    }else{
        _apiKey = apiKey;
    }
    
    [self.keychain setObject:apiKey forKey:(__bridge id)(kSecValueData)];
    
    [self checkForCreadentials];
}

-(void)checkForCreadentials
{
    if (self.apiKey) {
        self.hasCreadentials = YES;
    }else{
        self.hasCreadentials = NO;
    }    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DigitalOceanCreadentialsChanged" object:self];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters {
    if (self.apiKey) {
        [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", self.apiKey]];
    }
    
    return [super requestWithMethod:method path:path parameters:parameters];
}

@end
