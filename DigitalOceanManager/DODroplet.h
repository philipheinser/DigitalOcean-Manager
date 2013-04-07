//
//  Droplet.h
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 01.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DODroplet : NSObject

@property (readonly) NSUInteger dropletID;
@property (readonly) NSString *name;
@property (readonly) BOOL backups_active;
@property (readonly) NSUInteger regionID;
@property (readonly) NSUInteger imageID;
@property (readonly) NSUInteger sizeID;
@property (readonly) NSString *status;
@property (readonly) NSString *ipAddress;

- (id)initWithAttributes:(NSDictionary *)attributes;

- (UIImage *)imageForStaus;
- (void)rebootDropletWithBlock:(void (^)(NSError *error))block;
- (void)takeSnapshotWithBlock:(void (^)(NSError *error))block;


+ (void)allDropletsWithBlock:(void (^)(NSArray *droplets, NSError *error))block;

@end
