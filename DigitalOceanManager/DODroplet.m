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
    
    _powerActions = @[
                 @{@"name": @"Reboot", @"apiMethod":@"reboot"},
                 @{@"name": @"Power Cycle", @"apiMethod":@"power_cycle"},
                 @{@"name": @"Shutdown", @"apiMethod":@"shutdown"},
                 @{@"name": @"Power Off", @"apiMethod":@"power_off"},
                 @{@"name": @"Power On", @"apiMethod":@"power_on"}
                 ];
    
    return self;
}

- (void)takeSnapshotWithBlock:(void (^)(NSError *error))block
{
    [self performAction:@"snapshot" WithBlock:block];
}

- (void)performAction:(NSString *)action WithBlock:(void (^)(NSError *error))block
{
    NSString *path = [NSString stringWithFormat:@"droplets/%lu/%@/", (unsigned long)self.dropletID, action];
    
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

+(void)newDroplet:(NSString *)name size:(NSUInteger)size_id image:(NSUInteger)image_id region:(NSUInteger)region_id sshKey:(NSUInteger)ssh_key_ids withBlock:(void (^)(DODroplet *, NSError *))block
{
    NSString *path = [NSString stringWithFormat:@"droplets/new?name=%@&size_id=%lu&image_id=%lu&region_id=%lu", name, (unsigned long)size_id, (unsigned long)image_id, (unsigned long)region_id];
    if (ssh_key_ids) {
        path = [path stringByAppendingFormat:@"&ssh_key_ids=%lu", (unsigned long)ssh_key_ids];
    }
    [[DigitalOceanAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSString *status = JSON[@"droplet"];
        if (!status) {
            NSError *error = [NSError errorWithDomain:@"APIError" code:1202 userInfo:@{NSLocalizedDescriptionKey:@"You have not filled all required fields."}];
            block(nil, error);
        }else{
            DODroplet *droplet = [[DODroplet alloc] initWithAttributes:JSON[@"droplet"]];
            block(droplet, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@", error.description);
        block(nil, error);
    }];
}

@end
