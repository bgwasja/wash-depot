//
//  WDLacationsListVC.m
//  WashDepot
//
//  Created by Balazh Vasyl on 7/1/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDLocationsListVC.h"
#import "WDRequest.h"
#import "WDReportsListVC.h"

@interface WDLocationsListVC ()<NSFetchedResultsControllerDelegate>

//@property NSFetchedResultsController *fetchedResultsController;

@end

@implementation WDLocationsListVC


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

-(void)viewDidAppear:(BOOL)animated{
//    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.reportListVC.fetchedResultsController sections] count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
        UIView *customSeparator = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 2)];
        customSeparator.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"separator.png"]];
        [cell.contentView addSubview:customSeparator];
        cell.textLabel.textColor = [UIColor colorWithRed:100.0f/256 green:108.0f/256 blue:126.0f/256 alpha:1];

    }
        
    cell.textLabel.text = [[self.reportListVC.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row]] location_name];
    return cell;
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


+ (WDLocationsListVC*) sharedLocationsVC {
    static WDLocationsListVC* instance = nil;
    if (instance == nil) {
        instance = [[WDLocationsListVC alloc] initWithNibName:@"WDLocationsListVC" bundle:nil];
    }
    return instance;
}


- (void) showInView:(UIView*) v{
    if (self.view.superview != nil) {
        @throw [NSException exceptionWithName:@"sharedLocationsVC" reason:@"Loading view already showed!" userInfo:nil];
    }
    [v addSubview:self.view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


@end
