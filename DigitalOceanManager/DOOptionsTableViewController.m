//
//  DOOptionsTableViewController.m
//  DigitalOceanManager
//
//  Created by Philip Heinser on 06.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import "DOOptionsTableViewController.h"

@interface DOOptionsTableViewController ()

@end

@implementation DOOptionsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    self.cliendIDTextField.text = [DigitalOceanAPIClient sharedClient].cliendID;
    self.apiKeyTextField.text = [DigitalOceanAPIClient sharedClient].apiKey;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text = [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if (textField == self.cliendIDTextField) {
        [DigitalOceanAPIClient sharedClient].cliendID = self.cliendIDTextField.text;
    }
    if (textField == self.apiKeyTextField) {
        [DigitalOceanAPIClient sharedClient].apiKey = self.apiKeyTextField.text;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/philipheinser/DigitalOcean-Manager"]];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/philipheinser/DigitalOcean-Manager/issues"]];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"smallDonation"]];
        request.delegate = self;
        [request start];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController: self];
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        [[LTHPasscodeViewController sharedUser] showForChangingPasscodeInViewController: self];
    }
    
    if (indexPath.section == 2 && indexPath.row == 2) {
        [[LTHPasscodeViewController sharedUser] showForTurningOffPasscodeInViewController: self];
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([LTHPasscodeViewController passcodeExistsInKeychain]) {
        if (indexPath.section == 2 && indexPath.row == 0) {
            return NO;
        }
    } else {
        if (indexPath.section == 2 && indexPath.row == 1) {
            return NO;
        }
        if (indexPath.section == 2 && indexPath.row == 2) {
            return NO;
        }
    }
    
    return YES;
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    for (SKProduct *produkt in response.products) {
        SKPayment *payment = [SKPayment paymentWithProduct:produkt];
        if ([SKPaymentQueue canMakePayments]) {
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Donation Failed" message:@"Please make sure that In-App Purchases are enabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [queue finishTransaction:transaction];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank You" message:@"You are awesome!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        }
        if (transaction.transactionState == SKPaymentTransactionStateFailed) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Donation Failed" message:transaction.error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [queue finishTransaction:transaction];
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        }
    }
}

@end
