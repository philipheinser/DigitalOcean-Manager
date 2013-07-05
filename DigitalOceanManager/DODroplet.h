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

@property (retain) NSArray *powerActions;


- (id)initWithAttributes:(NSDictionary *)attributes;


- (UIImage *)imageForStaus;

- (void)takeSnapshotWithBlock:(void (^)(NSError *error))block;

- (void)performAction:(NSString *)action WithBlock:(void (^)(NSError *error))block;


+ (void)allDropletsWithBlock:(void (^)(NSArray *droplets, NSError *error))block;

+ (void)droplet:(NSUInteger)dropletID withBlock:(void (^)(DODroplet *droplet, NSError *error))block;

+ (void)newDroplet:(NSString *)name size:(NSUInteger)size_id image:(NSUInteger)image_id region:(NSUInteger)region_id sshKey:(NSUInteger)ssh_key_ids withBlock:(void (^)(DODroplet *droplet, NSError *error))block;

@end
