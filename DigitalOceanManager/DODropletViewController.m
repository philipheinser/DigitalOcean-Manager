//
//  DropletViewController.m
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 05.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import "DODropletViewController.h"

@interface DODropletViewController ()

@end

@implementation DODropletViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setDropletUI];
    
    [self.whiteOverlayTopView setAlpha:0];
    
    [UIView animateWithDuration:2 animations:^{
        [self.whiteOverlayTopView setAlpha:0.8];
    }];
}

- (void)setDropletUI
{
    self.title = self.droplet.name;
    self.ipLabel.text = self.droplet.ipAddress;
    self.statusLabel.text = self.droplet.status;
    
    [DORegion regionWithRegionID:self.droplet.regionID withBlock:^(DORegion *region) {
        [self setMapLocationWithLocationName:region.name];
    }];
    
    [DOSize sizeWithSizeID:self.droplet.sizeID withBlock:^(DOSize *size) {
        self.sizeLabel.text = size.name;
    }];
    
    [DOImage imageWithImageID:self.droplet.imageID withBlock:^(DOImage *image) {
        if (image) {
            self.imageLabel.text = image.name;
        }
    }];
}

- (void)setMapLocationWithLocationName:(NSString *)locationName
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = locationName;
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        
        MKMapItem *mapItem = response.mapItems[0];
        
        CLLocationCoordinate2D annotationCoord;
        
        annotationCoord = mapItem.placemark.coordinate;
        
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = annotationCoord;
        annotationPoint.title = locationName;
        [self.mapView addAnnotation:annotationPoint];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotationCoord, 10000, 10000);
        
        [self.mapView setRegion:region animated:YES];
    }];
}

- (IBAction)toogleToolbar:(id)sender
{
    [self.toolbar setHidden:!self.toolbar.hidden];
}

- (IBAction)showPowerOptions:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Power Options" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (int i = 0; i < [self.droplet.powerActions count]; i++) {
        [actionSheet addButtonWithTitle:[self.droplet.powerActions objectAtIndex:i][@"name"]];
    }
    
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = self.droplet.powerActions.count;
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < self.droplet.powerActions.count) {
        NSString *apiMethod = [self.droplet.powerActions objectAtIndex:buttonIndex][@"apiMethod"];
        [self.droplet performAction:apiMethod WithBlock:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error.description);
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Power Action" message:@"Your action has successfully started." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

- (IBAction)refreshDroplet:(id)sender
{
    self.refreshButton.enabled = NO;
    [DODroplet droplet:self.droplet.dropletID withBlock:^(DODroplet *droplet, NSError *error) {
        self.refreshButton.enabled = YES;
        if (error) {
            NSLog(@"%@", error.description);
        }else{
            self.droplet = droplet;
            [self setDropletUI];
        }
    }];
}

- (IBAction)takeSnapshot
{
    [self.droplet takeSnapshotWithBlock:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error.description);
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Snapshot" message:@"Your snapshot has successfully started." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

@end
