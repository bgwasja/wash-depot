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

@interface WDReportsListVC () <NSFetchedResultsControllerDelegate, WDReportListCellDelegate, WDPickerVCDelegate, WDDatePickerDelegate, UITextFieldDelegate> {
    int selectedRow;
    
}

@property NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSNumber* userType;
@property (nonatomic, strong) WDRequest* currentPickerReuqest;
@property (nonatomic, assign) BOOL pickerOpenedForStatus; // false - for completed
@property (nonatomic, assign) BOOL isSearchOpened;

@end

@implementation WDReportsListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationButtons];
    [self customizeSearchField];
    
    selectedRow = -1;
    
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];

    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.view.backgroundColor = background;
    self.reportsTable.backgroundView = nil;
    self.reportsTable.backgroundColor = [UIColor clearColor];
    
    
//    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:appDelegate.managedObjectContext queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        [appDelegate.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
//    }];

    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"WDRequest"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"location_name" ascending:YES]];
    
//    fetchRequest.returnsObjectsAsFaults = NO;
//    fetchRequest.includesPendingChanges = NO;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:@"location_name" cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.userType = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_type"];
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
    
    NSArray* rItems = @[[self navBarButtonWithTitle:@"Settings" selector:@selector(settingsTapped)],
                        [self navBarButtonWithTitle:@"Search" selector:@selector(searchTapped)]];
    self.navigationItem.rightBarButtonItems = rItems;
}


- (void) goBack {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"a_token"];
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
    return [NSPredicate predicateWithFormat:@"location_name contains[cd] %@ OR problem_area contains[cd] %@ OR desc contains[cd] %@", searchString, searchString, searchString];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSPredicate *predicate = nil;
    if (![self.searchTextField.text isEqualToString:@""]) {
        predicate = [self predicateForSearchString:self.searchTextField.text];
    }
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];

    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error){
        NSLog(@"error: %@",error);
    }

    [self.reportsTable reloadData];
    return YES;
}


- (void) editStatusTappedFor:(WDRequest*) r {
    WDPickerVC* vc = [[WDPickerVC alloc] initWithNibName:@"WDPickerVC" bundle:nil];
    vc.elements = [WDRequest availableStatuses];
    vc.defaultElement = r.current_status;
    vc.delegate = self;
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
    self.currentPickerReuqest = r;
    self.pickerOpenedForStatus = NO;
    [self presentModalViewController:vc animated:YES];
}


- (void) newElementPicked:(NSString*) newElement {
//    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
//    NSError* error = nil;
//    if ([appDelegate.managedObjectContext hasChanges]) {
//        [appDelegate.managedObjectContext save:&error];
//    }
    
    WDRequest* r = [_fetchedResultsController.managedObjectContext objectWithID:self.currentPickerReuqest.objectID];
    
    if (self.pickerOpenedForStatus) {
        r.current_status = newElement;
    } else {
        [r setCompletedFromString:newElement];
    }
    
    [_fetchedResultsController.managedObjectContext refreshObject:r mergeChanges:YES];
    
    NSError *error = nil;
    if (![_fetchedResultsController.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
    }
}


- (void) newDatePicked:(NSDate*) newDate {
    self.currentPickerReuqest.last_review = [NSString stringWithFormat:@"%f", [newDate timeIntervalSince1970]];
    
    [_fetchedResultsController.managedObjectContext refreshObject:self.currentPickerReuqest mergeChanges:YES];

    
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSError* error = nil;
    if ([appDelegate.managedObjectContext hasChanges]) {
        [appDelegate.managedObjectContext save:&error];
    }
    if (error != nil) {
        NSLog(@"%@", error);
    }
}


- (void) showPhotoTappedFor:(WDRequest*) r withPhotoNum:(int) photoNum {
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedRow == indexPath.row) {
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]] location_name];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = nil;
    if ([self.userType intValue] == 2) {
        CellIdentifier = @"report_cell_editable";
    } else {
        CellIdentifier = @"report_cell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    [self expandRowAtIndexPath:indexPath];
}


- (void) expandRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath == nil) {
        return;
    }
    NSMutableArray* rowsToUpdate =  [NSMutableArray arrayWithObject:indexPath];
    // update cell shadow over expanded cell
    [self addIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section] ifNotExistToArray:rowsToUpdate];
    
    bool needScroll = false;
    if (indexPath.row == selectedRow) {
        selectedRow = -1;
    } else {
        if (selectedRow != -1) {
            // update cell shadow over old expanded cell
            [self addIndexPath:[NSIndexPath indexPathForRow:selectedRow-1 inSection:indexPath.section] ifNotExistToArray:rowsToUpdate];
            // close old expanded cell
            [self addIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:indexPath.section] ifNotExistToArray:rowsToUpdate];
        }
        selectedRow = indexPath.row;
        needScroll = YES;
    }
    
    [self.reportsTable reloadRowsAtIndexPaths:rowsToUpdate withRowAnimation:UITableViewRowAnimationAutomatic];
    if (needScroll) {
        [self.reportsTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


- (void) addIndexPath:(NSIndexPath*) indexPath ifNotExistToArray:(NSMutableArray*) array {
    for (NSIndexPath* ip in array) {
        if (ip.row == indexPath.row) {
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
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
