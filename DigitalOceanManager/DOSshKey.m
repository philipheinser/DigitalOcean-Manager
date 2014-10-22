//
//  DOSHHKey.m
//  DigitalOceanManager
//
//  Created by Philip Heinser on 23.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import "DOSshKey.h"

@implementation DOSshKey

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _sshkeyID = [attributes[@"id"] integerValue];
    _name = attributes[@"name"];
    _slug = attributes[@"slug"];
    
    return self;
}

#pragma mark - Get SSH Keys From Server

+ (void)allSshKeysWithBlock:(void (^)(NSArray *sshKeys, NSError *error))block {
    [[DigitalOceanAPIClient sharedClient] getPath:@"account/keys" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSArray *sshKeysFromResponse = JSON[@"ssh_keys"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[sshKeysFromResponse count]];
        for (NSDictionary *attributes in sshKeysFromResponse) {
            DOSshKey *sshKey = [[DOSshKey alloc] initWithAttributes:attributes];
            [mutablePosts addObject:sshKey];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            NSLog(@"%@", error.description);
            block([NSArray array], error);
        }
    }];
}

@end
