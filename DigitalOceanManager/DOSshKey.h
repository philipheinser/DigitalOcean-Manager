//
//  DOSHHKey.h
//  DigitalOceanManager
//
//  Created by Philip Heinser on 23.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOSshKey : NSObject

@property (readonly) NSUInteger sshkeyID;
@property (readonly) NSString *name;
@property (readonly) NSString *slug;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)allSshKeysWithBlock:(void (^)(NSArray *sshKeys, NSError *error))block;

@end
