//
//  WDLacationsListVC.m
//  WashDepot
//
//  Created by Balazh Vasyl on 7/1/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDLacationsListVC.h"
#import "WDRequest.h"

@interface WDLacationsListVC ()<NSFetchedResultsControllerDelegate>

@property NSFetchedResultsController *fetchedResultsController;

@end

@implementation WDLacationsListVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // return [[self.fetchedResultsController sections] count];
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
 //   cell.textLabel.text = [[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] location_name];
    cell.textLabel.text = @"sdcsc";
    cell.textLabel.textColor = [UIColor colorWithRed:100.0f/256 green:108.0f/256 blue:126.0f/256 alpha:1];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //
}


+ (WDLacationsListVC*) sharedLacationsVC {
    static WDLacationsListVC* instance = nil;
    if (instance == nil) {
        instance = [[WDLacationsListVC alloc] initWithNibName:@"WDLacationsListVC" bundle:nil];
    }
    return instance;
}


- (void) showInView:(UIView*) v{
    if (self.view.superview != nil) {
        @throw [NSException exceptionWithName:@"sharedLacationsVC" reason:@"Loading view already showed!" userInfo:nil];
    }
    [v addSubview:self.view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setLocationsTable:nil];
    [super viewDidUnload];
}


@end
