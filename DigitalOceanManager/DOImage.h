//
//  DOImage.h
//  DigitalOceanManager
//
//  Created by Philip Heinser on 06.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOImage : NSObject

@property (readonly) NSUInteger imageID;
@property (readonly) NSString *name;
@property (readonly) NSString *distribution;
@property (readonly) NSString *slug;
@property (readonly) NSString *longName;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)allImagesWithBlock:(void (^)(NSArray *images, NSError *error))block;
+ (void)imageWithImageID:(NSUInteger)imageID withBlock:(void (^)(DOImage *image))block;

@end
