//
//  DONewDropletViewController.h
//  DigitalOceanManager
//
//  Created by Philip Heinser on 22.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DONewDropletViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate>

@property NSString *picketName;
@property DOImage *picketImage;
@property DOSize *picketSize;
@property DORegion *picketRegion;
@property DOSshKey *picketSshKey;

@property NSArray *sizes;
@property NSArray *regions;
@property NSArray *images;
@property NSArray *sshKeys;

- (IBAction)saveDroplet:(id)sender;
- (IBAction)sizeValueChanged;
- (IBAction)showImagePicker;
- (IBAction)showRegionPicker;
- (IBAction)showSSHKeyPicker;

@property (weak, nonatomic) IBOutlet UITextField *dropletNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIStepper *sizeStepper;
@property (weak, nonatomic) IBOutlet UIButton *regionButton;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *sshKeyButton;

@end
