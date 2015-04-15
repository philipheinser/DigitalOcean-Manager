//
//  DOImage.m
//  DigitalOceanManager
//
//  Created by Philip Heinser on 06.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import "DOImage.h"

@implementation DOImage

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _imageID = [attributes[@"id"] integerValue];
    _name = attributes[@"name"];
    _distribution = attributes[@"distribution"];
    _slug = attributes[@"slug"];
    
    return self;
}

-(NSString *)longName
{
    return [[self.distribution stringByAppendingString:@" "] stringByAppendingString:self.name];
}

#pragma mark - Get Images From Server

+ (void)allImagesWithBlock:(void (^)(NSArray *images, NSError *error))block
{
    [[DigitalOceanAPIClient sharedClient] getPath:@"images/" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSArray *imagesFromResponse = JSON[@"images"];
        NSMutableArray *mutableImages = [NSMutableArray arrayWithCapacity:[imagesFromResponse count]];
        for (NSDictionary *attributes in imagesFromResponse) {
            DOImage *image = [[DOImage alloc] initWithAttributes:attributes];
            [mutableImages addObject:image];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableImages], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            NSLog(@"%@", error.description);
            block([NSArray array], error);
        }
    }];
}

+ (void)imageWithImageID:(NSUInteger)imageID withBlock:(void (^)(DOImage *image))block
{
    [DOImage allImagesWithBlock:^(NSArray *images, NSError *error) {
        for (DOImage *image in images) {
            if (imageID == image.imageID) {
                block(image);
                return;
            }
        }
        block(nil);
    }];
}

@end
