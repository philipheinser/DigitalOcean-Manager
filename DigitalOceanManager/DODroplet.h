//
//  Droplet.h
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 01.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DORegion.h"
#import "DOImage.h"
#import "DOSize.h"

@interface DODroplet : NSObject

@property (readonly) NSUInteger dropletID;
@property (readonly) NSString *name;
@property (readonly) BOOL backups_active;
@property (readonly) NSUInteger regionID;
@property (readonly) DORegion *region;
@property (readonly) NSUInteger imageID;
@property (readonly) DOImage *image;
@property (readonly) NSUInteger sizeID;
@property (readonly) DOSize *size;
@property (readonly) NSString *status;
@property (readonly) NSString *ipAddress;

@property (retain) NSArray *powerActions;


- (id)initWithAttributes:(NSDictionary *)attributes;


- (UIImage *)imageForStatus;
- (UIColor *)colorForStatus;

- (void)takeSnapshotWithBlock:(void (^)(NSError *error))block;

- (void)performAction:(NSString *)action WithBlock:(void (^)(NSError *error))block;


+ (void)allDropletsWithBlock:(void (^)(NSArray *droplets, NSError *error))block;

+ (void)droplet:(NSUInteger)dropletID withBlock:(void (^)(DODroplet *droplet, NSError *error))block;

+(void)newDroplet:(NSString *)name size:(NSString *)size_id image:(NSUInteger)image_id region:(NSString *)region_id sshKey:(NSString *)ssh_key_ids withBlock:(void (^)(DODroplet *, NSError *))block;

@end
