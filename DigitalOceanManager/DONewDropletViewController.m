//
//  DONewDropletViewController.m
//  DigitalOceanManager
//
//  Created by Philip Heinser on 22.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import "DONewDropletViewController.h"
#import "DODropletsListTableViewController.h"

@interface DONewDropletViewController ()

@end

@implementation DONewDropletViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadInfos];
}

- (void)loadInfos
{
    [DOSize allSizesWithBlock:^(NSArray *sizes, NSError *error) {
        if (sizes.count > 0) {
            self.sizes = sizes;
            self.sizeStepper.maximumValue = sizes.count-1;
            [self sizeValueChanged];
        }
    }];
    
    [DORegion allRegionsWithBlock:^(NSArray *regions, NSError *error) {
        self.regions = regions;
    }];
    
    [DOImage allImagesWithBlock:^(NSArray *images, NSError *error) {
        self.images = images;
    }];
    
    [DOSshKey allSshKeysWithBlock:^(NSArray *sshKeys, NSError *error) {
        self.sshKeys = sshKeys;
    }];
}

- (IBAction)saveDroplet:(id)sender
{
    [DODroplet newDroplet:self.picketName size:self.picketSize.sizeID image:self.picketImage.imageID region:self.picketRegion.regionID sshKey:self.picketSshKey.sshkeyID withBlock:^(DODroplet *droplet, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your new Droplet is now online." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (IBAction)sizeValueChanged
{
    DOSize *newSize = self.sizes[(int)self.sizeStepper.value];
    self.picketSize = newSize;
    self.sizeLabel.text = newSize.name;
}

- (IBAction)showImagePicker
{
    UIActionSheet *picker = [[UIActionSheet alloc] initWithTitle:@"Images" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (DOImage *image in self.images) {
        [picker addButtonWithTitle:image.name];
    }
    
    [picker addButtonWithTitle:@"Cancel"];
    picker.cancelButtonIndex = self.images.count;
    [picker showInView:self.navigationController.view];
}

- (IBAction)showRegionPicker
{
    UIActionSheet *picker = [[UIActionSheet alloc] initWithTitle:@"Region" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (DORegion *region in self.regions) {
        [picker addButtonWithTitle:region.name];
    }
    
    [picker addButtonWithTitle:@"Cancel"];
    picker.cancelButtonIndex = self.regions.count;
    [picker showInView:self.navigationController.view];
}

- (IBAction)showSSHKeyPicker
{
    UIActionSheet *picker = [[UIActionSheet alloc] initWithTitle:@"SSH Key" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (DOSshKey *sshKey in self.sshKeys) {
        [picker addButtonWithTitle:sshKey.name];
    }
    
    [picker addButtonWithTitle:@"Cancel"];
    picker.cancelButtonIndex = self.sshKeys.count;
    [picker showInView:self.navigationController.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"Images"]) {
        if (buttonIndex < self.images.count) {
            self.picketImage = self.images[buttonIndex];
            [self.imageButton setTitle:self.picketImage.name forState:UIControlStateNormal];
        }
    }
    if ([actionSheet.title isEqualToString:@"Region"]) {
        if (buttonIndex < self.regions.count) {
            self.picketRegion = self.regions[buttonIndex];
            [self.regionButton setTitle:self.picketRegion.name forState:UIControlStateNormal];
        }
    }
    if ([actionSheet.title isEqualToString:@"SSH Key"]) {
        if (buttonIndex < self.sshKeys.count) {
            self.picketSshKey = self.sshKeys[buttonIndex];
            [self.sshKeyButton setTitle:self.picketSshKey.name forState:UIControlStateNormal];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.picketName = textField.text;
    return [textField resignFirstResponder];
}

@end
