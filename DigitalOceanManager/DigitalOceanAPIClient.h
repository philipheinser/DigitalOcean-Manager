//
//  DigitalOceanAPIClient.h
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 01.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import "AFHTTPClient.h"
#import "KeychainItemWrapper.h"

@interface DigitalOceanAPIClient : AFHTTPClient

@property (retain) KeychainItemWrapper *keychain;
@property (retain, nonatomic) NSString *cliendID;
@property (retain, nonatomic) NSString *apiKey;
@property BOOL hasCreadentials;

+ (DigitalOceanAPIClient *)sharedClient;

@end
