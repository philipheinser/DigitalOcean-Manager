//
//  Region.h
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 04.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DORegion : NSObject

@property (readonly) NSUInteger regionID;
@property (readonly) NSString *name;
@property (readonly) NSString *slug;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)allRegionsWithBlock:(void (^)(NSArray *regions, NSError *error))block;
+ (void)regionWithRegionID:(NSUInteger)regionID withBlock:(void (^)(DORegion *))block;

@end
