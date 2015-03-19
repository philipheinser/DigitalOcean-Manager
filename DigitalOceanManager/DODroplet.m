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
    _region = [[DORegion alloc] initWithAttributes:attributes[@"region"]];
    _imageID = [attributes[@"image_id"] integerValue];
    _image = [[DOImage alloc] initWithAttributes:attributes[@"image"]];
    _name = attributes[@"name"];
    _status = attributes[@"status"];
    _ipAddress = attributes[@"networks"][@"v4"][0][@"ip_address"];
    _size = [[DOSize alloc] initWithAttributes:attributes[@"size"]];
    
    _powerActions = @[
                 @{@"name": @"Reboot", @"apiMethod":@"reboot"},
                 @{@"name": @"Power Cycle", @"apiMethod":@"power_cycle"},
                 @{@"name": @"Shutdown", @"apiMethod":@"shutdown"},
                 @{@"name": @"Power Off", @"apiMethod":@"power_off"},
                 @{@"name": @"Power On", @"apiMethod":@"power_on"}
                 ];
    
    return self;
}

#pragma mark - Droplet Actions

- (void)takeSnapshotWithBlock:(void (^)(NSError *error))block
{
    [self performAction:@"snapshot" WithBlock:block];
}

- (void)performAction:(NSString *)action WithBlock:(void (^)(NSError *error))block
{
    NSString *path = [NSString stringWithFormat:@"droplets/%lu/actions", (unsigned long)self.dropletID];
    
    
    
    [[DigitalOceanAPIClient sharedClient] postPath:path parameters:@{
                                                                    @"type": action
                                                                    } success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSString *status = JSON[@"action"][@"status"];
        if ([status isEqualToString:@"in-progress"]) {
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(error);
    }];
}

- (UIImage *)imageForStatus {
    if ([self.status isEqualToString:@"active"]) {
        return [UIImage imageNamed:@"GreenDot"];
    }
    return nil;
}

- (UIColor *)colorForStatus
{
    if ([self.status isEqualToString:@"active"]) {
        return [UIColor greenColor];
    }
    
    return nil;
}

#pragma mark - Get Droplets From Server

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

+(void)newDroplet:(NSString *)name size:(NSString *)size_id image:(NSUInteger)image_id region:(NSString *)region_id sshKey:(NSString *)ssh_key_ids withBlock:(void (^)(DODroplet *, NSError *))block
{
    NSString *path = @"droplets";
    
    NSMutableDictionary *data;
    
    if (size_id && image_id && region_id) {
         data = @{
                                      @"name": name,
                                      @"size": size_id,
                                      @"image":  @(image_id),
                                      @"region":  region_id
                                      }.mutableCopy;
    }
    
    if (ssh_key_ids && data) {
        [data setValue:@[ssh_key_ids] forKey:@"ssh_keys"];
    }
    
    NSMutableURLRequest *request = [[DigitalOceanAPIClient sharedClient] requestWithMethod:@"POST" path:path parameters:nil];
    
    if (data) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:nil];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            block(nil, nil);
        } else {
            if (connectionError) {
                block(nil, connectionError);
            } else {
                NSString *info = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSError *error = [NSError errorWithDomain:@"DigitalOcean" code:10023 userInfo:@{NSLocalizedDescriptionKey: info}];
                block(nil, error);
            }
        }
    }];
}

@end
