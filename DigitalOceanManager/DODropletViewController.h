//
//  DropletViewController.h
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 05.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DODropletViewController : UIViewController

@property DODroplet *droplet;

@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIView *whiteOverlayTopView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)toogleToolbar:(id)sender;

- (IBAction)reboot;
- (IBAction)takeSnapshot;

@end
