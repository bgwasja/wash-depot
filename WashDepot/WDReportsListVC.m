
//
//  WDReportsListVC.m
//  WashDepot
//
//  Created by Vova Musiienko on 17.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDReportsListVC.h"
#import "WDAppDelegate.h"
#import "WDRequest.h"
#import "WDReportListCell.h"
#import "UIViewController+Utils.h"
#import "WDPickerVC.h"
#import "WDDatePicker.h"
#import "WDLoadingVC.h"
#import "WDLocationsListVC.h"
#import "WDChangeReportVC.h"
#import "WDListOptionsVC.h"
#import "WDPopoverContentVC.h"
#import "WDImageViewVC.h"
#import "WDAPIClient.h"

@interface WDReportsListVC () <NSFetchedResultsControllerDelegate, WDReportListCellDelegate, WDPickerVCDelegate, WDDatePickerDelegate, UITextFieldDelegate, WDChangeReportVCDelegate, UIPopoverControllerDelegate>
{
    int selectedRow;
    int selectedSection;
    UIPopoverController *settingsPopover;
}

@property (nonatomic, strong) NSNumber* userType;
@property (nonatomic, strong) WDRequest* currentPickerReuqest;
@property (nonatomic, assign) BOOL pickerOpenedForStatus; // false - for completed
@property (nonatomic, assign) BOOL isSearchOpened;
@property (nonatomic, assign) BOOL needLoadingScreen;
@property (nonatomic, strong) WDLocationsListVC* locationsListVC;

@end

@implementation WDReportsListVC
@synthesize locationsListView, headerLabel;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self initNavigationButtons];
    [self customizeSearchField];
    
    selectedRow = -1;
    selectedSection = 0;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"filter_option"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@3 forKey:@"filter_option"];
    }
    
    
    
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];

    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.view.backgroundColor = background;
    self.reportsTable.backgroundView = nil;
    self.reportsTable.backgroundColor = [UIColor clearColor];
    
    
//    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:appDelegate.managedObjectContext queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        [appDelegate.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
//    }];

    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"WDRequest"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"location_name" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"creation_date" ascending:YES]];
    
//    fetchRequest.returnsObjectsAsFaults = NO;
//    fetchRequest.includesPendingChanges = NO;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:@"location_name" cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    //[self.reportsTable setEditing:YES];
    
    self.needLoadingScreen = YES;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AFIncrementalStoreContextDidFetchRemoteValues object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [[WDLoadingVC sharedLoadingVC] hide];
    }];
    
    self.locationsListVC = [[WDLocationsListVC alloc] initWithNibName:@"WDLocationsListVC" bundle:nil];
    [locationsListView addSubview:self.locationsListVC.view];
    self.locationsListVC.reportListVC = self;
    
    if(USING_IPAD)[self addSearchField];
    
    UIImage *headerButtonImage = [[UIImage imageNamed:@"but_header"] resizableImageWithCapInsets:UIEdgeInsetsMake(23, 12, 23, 12)];
    [self.filterButton setBackgroundImage:headerButtonImage forState:UIControlStateNormal];
    [self.logoutBut setBackgroundImage:headerButtonImage forState:UIControlStateNormal];
    
    UIImage *headerActButtonImage = [[UIImage imageNamed:@"but_blue_act"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
    [self.filterButton setBackgroundImage:headerActButtonImage forState:UIControlStateHighlighted];
    [self.logoutBut setBackgroundImage:headerActButtonImage forState:UIControlStateHighlighted];
    
    UIImage *toolbarImage = [[UIImage imageNamed:@"bg_header"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 480, 32)];
    [self.leftToolbar setBackgroundImage:toolbarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.rightToolbar setBackgroundImage:toolbarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:17];
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];

    settingsPopover.delegate = self;
    
    [WDRequest updateLists:^(void) {
    }];

    
    [self loadReports];
}


- (void) loadReports {
    NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
    NSString *path = [NSString stringWithFormat:@"api/get_requests_list?auth_token=%@", aToken];
    NSMutableURLRequest *request = [[WDAPIClient sharedClient] requestWithMethod:@"POST" path:path parameters:nil];
    [request setHTTPShouldHandleCookies:YES];

    NSLog(@"LIST URL : %@", [request.URL description]);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        
        NSMutableArray* updatedObjectsIDs = [NSMutableArray new];
        
        for (NSDictionary* objDic in JSON) {
            NSString* _id = [NSString stringWithFormat:@"%i", [[objDic objectForKey:@"id"] intValue]];
            
            WDRequest* r = [WDRequest findByID:_id];
            if (r == nil) {
                r = [WDRequest newRequest];
            }
            
            [r updateFromDict:objDic];
            
            [updatedObjectsIDs addObject:_id];
        }

        [appDelegate.managedObjectContext save:nil];
        
        [WDRequest removeMissingObjects:updatedObjectsIDs];

        NSError* error = nil;
        [appDelegate.managedObjectContext save:&error];
        if (error != nil) {
            NSLog(@"%@", error);
        }

        selectedRow = -1;
        [self.reportsTable reloadData];
        [self.locationsListVC refreshLocations];
        
        [[WDLoadingVC sharedLoadingVC] hide];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSString* errMsg = nil;
        if (JSON != nil) {
            errMsg = [JSON  objectForKey:@"info"];
        } else {
            errMsg = [error localizedDescription];
        }
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"REPORTS" message:[NSString stringWithFormat:@"Can't get reports list: %@", errMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        [[WDLoadingVC sharedLoadingVC] hide];
    }];
    
    [operation start];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.userType = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_type"];
    
    NSPredicate *predicate = nil;
    if (![self.searchTextField.text isEqualToString:@""]) {
        predicate = [self predicateForSearchString:self.searchTextField.text];
    } else {
        predicate = [self predicateForSearchString:nil];
    }
    
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    if (self.needLoadingScreen) {
        [[WDLoadingVC sharedLoadingVC] showInController:self withText:@"Update requests..."];
        self.needLoadingScreen = NO;
    }
    
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    [self.reportsTable reloadData];
    [self.locationsListVC refreshLocations];
    
    if (error){
        NSLog(@"error: %@",error);
    }

}


- (void) customizeSearchField {
    UIImage *textFieldBackground = [[UIImage imageNamed:@"text_input"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.searchTextField.leftView = paddingView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.background = textFieldBackground;
}


- (void) initNavigationButtons {
    self.navigationItem.leftBarButtonItem = [self navBarButtonWithTitle:@"Logout" selector:@selector(goBack)];
    
    NSArray* rItems = @[[self navBarButtonWithTitle:@"Filter" selector:@selector(settingsTapped)],
                        [self navBarButtonWithTitle:@"Search" selector:@selector(searchTapped)]];
    self.navigationItem.rightBarButtonItems = rItems;
}


- (void) goBack {
    [self userLogout];
    [self dismissModalViewControllerAnimated:YES];
}


- (void) searchTapped {
    if (self.isSearchOpened == false) {
        [self showSearchFeild];
    } else {
        [self hideSearchFeild];
    }
    self.isSearchOpened = !self.isSearchOpened;
}


- (void) settingsTapped {
//    [self performSegueWithIdentifier:@"options_vc" sender:self];
    selectedRow = -1;
    
   int currentFilter= [[[NSUserDefaults standardUserDefaults] objectForKey:@"filter_option"]intValue];

    WDPickerVC* vc = [[WDPickerVC alloc] initWithNibName:@"WDPickerVC" bundle:nil];
    vc.elements = @[@"Completed for last 30 days",@"Completed for last 60 days",@"All completed",@"No filter"];
    vc.defaultElement = [vc.elements objectAtIndex:currentFilter];
    vc.delegate = self;
    vc.type = WDFilterPiker;
    self.pickerOpenedForStatus = NO;
    [self presentModalViewController:vc animated:YES];
}


- (void) showSearchFeild {
    [self.view addSubview:self.searchView];
    [self.searchTextField becomeFirstResponder];
    self.searchView.frame = CGRectMake(0, self.reportsTable.frame.origin.y - self.searchView.frame.size.height, self.searchView.frame.size.width, self.searchView.frame.size.height);
    [UIView animateWithDuration:0.25
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.searchView.frame = CGRectMake(0, 0, self.searchView.frame.size.width, self.searchView.frame.size.height);
                         self.reportsTable.frame = CGRectMake(0, self.searchView.frame.size.height, self.reportsTable.frame.size.width, self.view.bounds.size.height - self.searchView.frame.size.height - 218.0f);
                     }
                     completion:^(BOOL finished){
                     }];
}


-(void)addSearchField{
    [self.view addSubview:self.searchView];
    int x = _reportsTable.frame.origin.x;
    int offset = _reportsTable.frame.size.width/2;
    self.searchView.frame = CGRectMake(x+offset, self.reportsTable.frame.origin.y - self.searchView.frame.size.height, self.searchView.frame.size.width, self.searchView.frame.size.height);
    self.searchView.frame = CGRectMake(x+offset, 0, self.searchView.frame.size.width, self.searchView.frame.size.height);
    self.reportsTable.frame = CGRectMake(x, self.searchView.frame.size.height, self.reportsTable.frame.size.width, self.view.bounds.size.height - self.searchView.frame.size.height - 218.0f);
                   

}

- (void) hideSearchFeild {
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.searchView.frame = CGRectMake(0, 0 - self.searchView.frame.size.height, self.searchView.frame.size.width, self.searchView.frame.size.height);
                         self.reportsTable.frame = CGRectMake(0, 0, self.reportsTable.frame.size.width, self.view.bounds.size.height);
                     }
                     completion:^(BOOL finished){
                         [self.searchTextField resignFirstResponder];
                         [self.searchView removeFromSuperview];

                     }];
}


- (NSPredicate*) predicateForSearchString:(NSString*) searchString  {
    
    int filterOption = [[[NSUserDefaults standardUserDefaults] objectForKey:@"filter_option"] intValue];
//    NSLog(@"filterOption=%i",filterOption);
    NSString* filterStr = nil;
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
    
    switch (filterOption) {
        case 0: {
            NSDate* d = [today dateByAddingTimeInterval:-secondsPerDay*30];
            filterStr = [NSString stringWithFormat:@"(completed = 1 AND last_review >= %f)", [d timeIntervalSince1970]];
            break;
        }
        case 1: {
            NSDate* d = [today dateByAddingTimeInterval:-secondsPerDay*60];
            filterStr = [NSString stringWithFormat:@"(completed = 1 AND last_review >= %f)", [d timeIntervalSince1970]];
            break;
        }
        case 2:{
            filterStr = [NSString stringWithFormat:@"(completed = 1)"];
            break;
        }
        default:
            break;
    }
    
    if (searchString == nil || [searchString isEqualToString:@""]) {
        if (filterOption == 3) {
            return nil;
        } else {
            return [NSPredicate predicateWithFormat:filterStr];
        }
    } else {
        if (filterOption == 3) {
            return [NSPredicate predicateWithFormat:@"location_name contains[cd] %@ OR problem_area contains[cd] %@ OR desc contains[cd] %@", searchString, searchString, searchString];
        } else {
            return [NSPredicate predicateWithFormat:@"location_name contains[cd] %@ OR problem_area contains[cd] %@ OR desc contains[cd] %@ AND %@", searchString, searchString, searchString, filterStr];
        }
    }
    return nil;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}

-(IBAction)updateSearchResults:(id)sender{
    selectedRow = -1;
    NSPredicate *predicate = [self predicateForSearchString:self.searchTextField.text];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error){
        NSLog(@"error: %@",error);
    }
    
    [self.reportsTable reloadData];
    [self.locationsListVC refreshLocations];

}


- (IBAction)logoutTapped:(id)sender {
    [self goBack];
}


- (IBAction)settingsTapped:(id)sender {
    selectedRow = -1;
    
    WDPopoverContentVC *contentVC = [[WDPopoverContentVC alloc]initWithNibName:@"PopoverContent" bundle:nil];

    contentVC.reportList = self;
    if (settingsPopover == nil || !settingsPopover.isPopoverVisible) {
        settingsPopover = [[UIPopoverController alloc] initWithContentViewController:contentVC];
        [settingsPopover setPopoverContentSize: CGSizeMake(300.0,195.0)];
        [settingsPopover presentPopoverFromRect:(CGRectMake(self.filterButton.frame.size.width, self.filterButton.frame.size.height, 1 , 1)) inView:self.filterButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
    } else {
        [settingsPopover dismissPopoverAnimated:YES];
        settingsPopover = nil;
    
    }
}


-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController*)popoverController
{
    return YES;
}


- (void) editStatusTappedFor:(WDRequest*) r {
    WDPickerVC* vc = [[WDPickerVC alloc] initWithNibName:@"WDPickerVC" bundle:nil];
    vc.elements = [WDRequest availableStatuses];
    vc.defaultElement = r.current_status;
    vc.delegate = self;
    vc.type = WDPiker;
    self.currentPickerReuqest = r;
    self.pickerOpenedForStatus = YES;
    [self presentModalViewController:vc animated:YES];
}


- (void) editDateTappedFor:(WDRequest*) r {
    WDDatePicker* vc = [[WDDatePicker alloc] initWithNibName:@"WDDatePicker" bundle:nil];
    self.currentPickerReuqest = r;
    vc.delegate = self;
    [self presentModalViewController:vc animated:YES];
}


- (void) editQueueStatusTappedFor:(WDRequest*) r {
    WDPickerVC* vc = [[WDPickerVC alloc] initWithNibName:@"WDPickerVC" bundle:nil];
    vc.elements = [WDRequest availableCompletedNames];
    vc.defaultElement = [r completedString];
    vc.delegate = self;
    vc.type = WDPiker;
    self.currentPickerReuqest = r;
    self.pickerOpenedForStatus = NO;
    [self presentModalViewController:vc animated:YES];
}


- (void) checkboxTappedFor:(WDRequest*) r {
    if ([self.userType intValue] != 2) {
        return;
    }
    
    r.completed = @(![r.completed boolValue]);
    r.sys_modified = @YES;
    
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSError* error = nil;
    [appDelegate.managedObjectContext save:&error];
    if (error != nil) {
        NSLog(@"%@", error);
    }
    
    [WDRequest syncModifiedObjects];
}


- (void) newElementPicked:(NSString*) newElement {
    if (self.pickerOpenedForStatus) {
        if (![self.currentPickerReuqest.current_status isEqualToString:newElement]) {
            self.currentPickerReuqest.current_status = newElement;
            self.currentPickerReuqest.sys_modified = @YES;
        }
    } else {
        if (![[self.currentPickerReuqest completedString] isEqualToString:newElement]) {
            [self.currentPickerReuqest setCompletedFromString:newElement];
            self.currentPickerReuqest.sys_modified = @YES;
        }
    }

    NSError *error = nil;
    if (![_fetchedResultsController.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
    }
    [[WDChangeReportVC sharedChangeReportVC]updateData];
    
    [WDRequest syncModifiedObjects];
}


- (void) newDatePicked:(NSDate*) newDate {
    self.currentPickerReuqest.last_review = [NSNumber numberWithDouble:[newDate timeIntervalSince1970]];
    self.currentPickerReuqest.sys_modified = @YES;
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSError* error = nil;
    if ([appDelegate.managedObjectContext hasChanges]) {
        [appDelegate.managedObjectContext save:&error];
    }
    if (error != nil) {
        NSLog(@"%@", error);
    }
    [[WDChangeReportVC sharedChangeReportVC]updateData];

    [WDRequest syncModifiedObjects];
}


- (void) showPhotoTappedFor:(WDRequest*) r withPhotoNum:(int) photoNum {
    NSString* imageURLString = nil;
    switch (photoNum) {
        case 0:
            imageURLString = r.image1;
            break;
        case 1:
            imageURLString = r.image2;
            break;
        case 2:
            imageURLString = r.image3;
            break;
    }

    if (imageURLString != nil && ![imageURLString isKindOfClass:[NSNull class]] && ![imageURLString isEqualToString:@""]) {
        WDImageViewVC* vc = [[WDImageViewVC alloc] initWithNibName:@"WDImageViewVC" bundle:nil];
        vc.imageURLString = imageURLString;
        [self presentModalViewController:vc animated:YES];
    } else {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"IMAGE VIEW" message:@"No image." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSMutableURLRequest *r = [[WDAPIClient sharedClient] requestWithMethod:@"DELETE" path:nil parameters:nil];
        NSString* aToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"a_token"];
        NSString *path = [NSString stringWithFormat:@"/api/remove_request?auth_token=%@", aToken];
        [r setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[WDAPIClient sharedClient].baseURL absoluteString], path]]];
        
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:((WDRequest*)managedObject).identifier forKey:@"request_id"];
        NSError* error = nil;
        NSData *json = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        
        
        [r setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [r setHTTPBody:json];
        [r setHTTPShouldHandleCookies:NO];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:r success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

            [self.fetchedResultsController.managedObjectContext deleteObject:managedObject];
            NSError *error = nil;
            if (![_fetchedResultsController.managedObjectContext save:&error]) {
                NSLog(@"Error: %@", error);
            }
        
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSString* errMsg = nil;
            if (JSON != nil) {
                errMsg = [JSON  objectForKey:@"info"];
            } else {
                errMsg = [error localizedDescription];
            }
            NSLog(@"Can't delete object %@", errMsg);
        }];

        [operation start];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedRow == indexPath.row && selectedSection == indexPath.section) {
        if ([self.userType intValue] == 2) {
            return 360.0f;
        } else {
            return 300.0f;
        }
    } else {
        return tableView.rowHeight;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]] location_name];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView;
    if (USING_IPAD) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 703.0, 22.0)];
    }else {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 22.0)];
    }
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_header.png"]];;
    
    UILabel *headerSectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 100, 15)];
    headerSectionLabel.backgroundColor = [UIColor clearColor];
    headerSectionLabel.opaque = NO;
    headerSectionLabel.textColor = [UIColor whiteColor];
    headerSectionLabel.font = [UIFont boldSystemFontOfSize:15];
    headerSectionLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerSectionLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    headerSectionLabel.text = [[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]] location_name];
    [headerView addSubview:headerSectionLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = nil;
    if ([self.userType intValue] == 2 && !USING_IPAD) {
        CellIdentifier = @"report_cell_editable";
    } else {
        CellIdentifier = @"report_cell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if(!cell){
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ((WDReportListCell*)cell).request = (WDRequest*)managedObject;
    ((WDReportListCell*)cell).delegate = self;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (USING_IPAD){
        NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];

        [WDChangeReportVC sharedChangeReportVC].request = (WDRequest*)managedObject;
        [[WDChangeReportVC sharedChangeReportVC] showInView:self.view];
        [WDChangeReportVC sharedChangeReportVC].delegate = self;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        
    } else {
        [self expandRowAtIndexPath:indexPath];
    }
}


- (void) expandRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath == nil) {
        return;
    }
    NSMutableArray* rowsToUpdate =  [NSMutableArray arrayWithObject:indexPath];

    bool needScroll = false;
    if (indexPath.row == selectedRow && indexPath.section == selectedSection) {
        selectedRow = -1;
    } else {
        if (selectedRow != -1) {
            [self addIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:selectedSection] ifNotExistToArray:rowsToUpdate];
        }
        selectedRow = indexPath.row;
        selectedSection = indexPath.section;
        needScroll = YES;
    }
    
    [self.reportsTable reloadRowsAtIndexPaths:rowsToUpdate withRowAnimation:UITableViewRowAnimationAutomatic];
    if (needScroll) {
        [self.reportsTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


- (void) addIndexPath:(NSIndexPath*) indexPath ifNotExistToArray:(NSMutableArray*) array {
    for (NSIndexPath* ip in array) {
        if (ip.row == indexPath.row && ip.section == indexPath.section) {
            return;
        }
    }
    if (indexPath.row >= 0)
        [array addObject:indexPath];
}



#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.reportsTable beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.reportsTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]    withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.reportsTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]    withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)object
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.reportsTable insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]     withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.reportsTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]    withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.reportsTable cellForRowAtIndexPath:indexPath] forRowAtIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.reportsTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]    withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.reportsTable insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]     withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.reportsTable endUpdates];
    [self.locationsListVC refreshLocations];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLocationsListView:nil];
    [self setLogoutBut:nil];
    [self setFilterButton:nil];
    [self setLeftToolbar:nil];
    [self setRightToolbar:nil];
    [self setHeaderLabel:nil];
    [super viewDidUnload];
}
@end
