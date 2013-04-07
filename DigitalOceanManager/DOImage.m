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
    
    return self;
}

+ (void)allImagesWithBlock:(void (^)(NSArray *images, NSError *error))block
{
    [[DigitalOceanAPIClient sharedClient] getPath:@"images/" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSArray *imagesFromResponse = JSON[@"images"];
        NSLog(@"%@", JSON);
        NSMutableArray *mutableImages = [NSMutableArray arrayWithCapacity:[imagesFromResponse count]];
        for (NSDictionary *attributes in imagesFromResponse) {
            DOSize *size = [[DOSize alloc] initWithAttributes:attributes];
            [mutableImages addObject:size];
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

@end
