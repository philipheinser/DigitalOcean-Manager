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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
}

@end
