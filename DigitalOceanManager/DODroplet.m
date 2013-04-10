//
//  Droplet.m
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 01.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import "DODroplet.h"

@implementation DODroplet

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _dropletID = [attributes[@"id"] integerValue];
    _sizeID = [attributes[@"size_id"] integerValue];
    _regionID = [attributes[@"region_id"] integerValue];
    _imageID = [attributes[@"image_id"] integerValue];
    _name = attributes[@"name"];
    _status = attributes[@"status"];
    _ipAddress = attributes[@"ip_address"];
    
    return self;
}

- (void)takeSnapshotWithBlock:(void (^)(NSError *error))block
{
    NSString *path = [NSString stringWithFormat:@"droplets/%lu/snapshot/", (unsigned long)self.dropletID];
    
    [[DigitalOceanAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSString *status = JSON[@"status"];
        if ([status isEqualToString:@"OK"]) {
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(error);
    }];
}

- (void)rebootDropletWithBlock:(void (^)(NSError *error))block
{
    NSString *path = [NSString stringWithFormat:@"droplets/%lu/reboot/", (unsigned long)self.dropletID];
    
    [[DigitalOceanAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSString *status = JSON[@"status"];
        if ([status isEqualToString:@"OK"]) {
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(error);
    }];
}

-(UIImage *)imageForStaus {
    if ([self.status isEqualToString:@"active"]) {
        return [UIImage imageNamed:@"GreenDot"];
    }
    return nil;
}

+ (void)allDropletsWithBlock:(void (^)(NSArray *droplets, NSError *error))block
{
    [[DigitalOceanAPIClient sharedClient] getPath:@"droplets/" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSString *status = JSON[@"status"];
        if ([status isEqualToString:@"ERROR"]) {
            NSError *error = [NSError errorWithDomain:@"APIError" code:1200 userInfo:@{NSLocalizedDescriptionKey:JSON[@"description"]}];
            block([NSArray array], error);
        }else{
            NSArray *dropletsFromResponse = JSON[@"droplets"];
            NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[dropletsFromResponse count]];
            for (NSDictionary *attributes in dropletsFromResponse) {
                DODroplet *droplet = [[DODroplet alloc] initWithAttributes:attributes];
                [mutablePosts addObject:droplet];
            }
            
            if (block) {
                block([NSArray arrayWithArray:mutablePosts], nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            NSLog(@"%@", error.description);
            block([NSArray array], error);
        }
    }];
}

+(void)droplet:(NSUInteger)dropletID withBlock:(void (^)(DODroplet *, NSError *))block
{
    NSString *path = [NSString stringWithFormat:@"droplets/%lu/", (unsigned long)dropletID];
    [[DigitalOceanAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        DODroplet *droplet = [[DODroplet alloc] initWithAttributes:JSON[@"droplet"]];
        block(droplet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

@end
