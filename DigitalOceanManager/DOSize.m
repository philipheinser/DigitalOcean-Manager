//
//  Size.m
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 05.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import "DOSize.h"

@implementation DOSize

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _sizeID = [attributes[@"id"] integerValue];
    _name = attributes[@"slug"];
    _slug = attributes[@"slug"];
    
    return self;
}

#pragma mark - Get Sizes From Server

+ (void)allSizesWithBlock:(void (^)(NSArray *sizes, NSError *error))block
{
    [[DigitalOceanAPIClient sharedClient] getPath:@"sizes/" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSArray *sizesFromResponse = JSON[@"sizes"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[sizesFromResponse count]];
        for (NSDictionary *attributes in sizesFromResponse) {
            DOSize *size = [[DOSize alloc] initWithAttributes:attributes];
            [mutablePosts addObject:size];
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

+ (void)sizeWithSizeID:(NSUInteger)sizeID withBlock:(void (^)(DOSize *size))block
{
    [DOSize allSizesWithBlock:^(NSArray *sizes, NSError *error) {
        for (DOSize *size in sizes) {
            if (sizeID == size.sizeID) {
                block(size);
                return;
            }
        }
    }];
}

@end
