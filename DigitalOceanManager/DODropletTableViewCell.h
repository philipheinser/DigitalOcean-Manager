//
//  DropletTableViewCell.h
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 04.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DODropletTableViewCell : UITableViewCell

@property (nonatomic) DODroplet *droplet;

-(void)setDroplet:(DODroplet *)droplet;

@end
