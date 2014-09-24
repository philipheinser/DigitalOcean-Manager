//
//  DropletsListTableViewController.m
//  Digital Ocean Manager
//
//  Created by Philip Heinser on 02.04.13.
//  Copyright (c) 2013 Philip Heinser. All rights reserved.
//

#import "DODropletsListTableViewController.h"
#import "DODropletViewController.h"
#import "DODropletTableViewCell.h"

@interface DODropletsListTableViewController ()

@property NSArray *droplets;

@end

@implementation DODropletsListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor whiteColor];
    self.refreshControl = refreshControl;

    [self refreshData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(credentialsChanged:) name:@"DigitalOceanCreadentialsChanged" object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self credentialsChanged:nil];
}

-(void) credentialsChanged:(id)sender
{
    self.addDropletButton.enabled = [[DigitalOceanAPIClient sharedClient] hasCreadentials];
    [self.tableView reloadData];
}

- (void)refreshData {
    [self.refreshControl beginRefreshing];
    if ([[DigitalOceanAPIClient sharedClient].apiKey isEqualToString:@"test"]) {
        [self.tableView beginUpdates];
        NSDictionary *testData = @{@"name": @"Test Droplet",
                                   @"ip_address": @"192.168.0.1",
                                   @"status": @"Ready for the App Store"};
        DODroplet *testDroplet = [[DODroplet alloc] initWithAttributes:testData];
        self.droplets = @[testDroplet];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        [self.refreshControl endRefreshing];
    }else{
        [DODroplet allDropletsWithBlock:^(NSArray *droplets, NSError *error) {
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            }
            [self.tableView beginUpdates];
            self.droplets = droplets;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
            [self.refreshControl endRefreshing];
        }];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.droplets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DropletCell";
    DODropletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DODroplet *droplet = self.droplets[indexPath.row];

    [cell setDroplet:droplet];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"showDropletViewController"]) {
        DODropletViewController *dropletVC = segue.destinationViewController;
        dropletVC.droplet = self.droplets[[self.tableView indexPathForSelectedRow].row];
    }
    
}

- (IBAction)backToDropletsList:(UIStoryboardSegue *)segue
{
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
