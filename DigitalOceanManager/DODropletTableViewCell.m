//
//  DropletTableViewCell.m
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 04.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import "DODropletTableViewCell.h"

@implementation DODropletTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setDroplet:(DODroplet *)droplet
{
    _droplet = droplet;
    
    self.textLabel.text = _droplet.name;
    self.detailTextLabel.text = _droplet.ipAddress;
    self.imageView.image = [[UIImage imageNamed:@"Drop_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imageView.tintColor = [_droplet colorForStatus];
    
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
