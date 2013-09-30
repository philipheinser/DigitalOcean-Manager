//
//  DropletsListTableViewController.h
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 02.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DODropletsListTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addDropletButton;

- (void)refreshData;

@end
