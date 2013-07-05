//
//  Region.m
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 04.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import "DORegion.h"

@implementation DORegion

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _regionID = [attributes[@"id"] integerValue];
    _name = attributes[@"name"];
    
    return self;
}

#pragma mark - Get Regions From Server

+ (void)allRegionsWithBlock:(void (^)(NSArray *regions, NSError *error))block {
    [[DigitalOceanAPIClient sharedClient] getPath:@"regions/" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSArray *regionsFromResponse = JSON[@"regions"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[regionsFromResponse count]];
        for (NSDictionary *attributes in regionsFromResponse) {
            DORegion *region = [[DORegion alloc] initWithAttributes:attributes];
            [mutablePosts addObject:region];
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

+ (void)regionWithRegionID:(NSUInteger)regionID withBlock:(void (^)(DORegion *))block
{
    if ([[DigitalOceanAPIClient sharedClient].cliendID isEqualToString:@"test"]) {
        DORegion *testRegion = [[DORegion alloc] initWithAttributes:@{@"name":@"Amsterdam"}];
        block(testRegion);
    }else{
        [DORegion allRegionsWithBlock:^(NSArray *regions, NSError *error) {
            for (DORegion *region in regions) {
                if (regionID == region.regionID) {
                    block(region);
                    return;
                }
            }
        }];
    }
}

@end
