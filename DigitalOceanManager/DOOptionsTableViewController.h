//
//  DOOptionsTableViewController.h
//  DigitalOceanManager
//
//  Created by Philip Heinser on 06.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOOptionsTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cliendIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTextField;

@end
