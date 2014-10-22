//
//  Size.h
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 05.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOSize : NSObject

@property (readonly) NSUInteger sizeID;
@property (readonly) NSString *name;
@property (readonly) NSString *slug;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)allSizesWithBlock:(void (^)(NSArray *sizes, NSError *error))block;
+ (void)sizeWithSizeID:(NSUInteger)sizeID withBlock:(void (^)(DOSize *size))block;

@end
