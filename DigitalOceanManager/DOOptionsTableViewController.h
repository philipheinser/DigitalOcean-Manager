//
//  DOOptionsTableViewController.h
//  DigitalOceanManager
//
//  Created by Philip Heinser on 06.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface DOOptionsTableViewController : UITableViewController <UITextFieldDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (weak, nonatomic) IBOutlet UITextField *cliendIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTextField;

@end
