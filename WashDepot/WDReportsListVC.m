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

@interface WDReportsListVC () <NSFetchedResultsControllerDelegate, WDReportListCellDelegate, WDPickerVCDelegate> {
    int selectedRow;
    
}

@property NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSNumber* userType;
@property (nonatomic, strong) WDRequest* currentPickerReuqest;

@end

@implementation WDReportsListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationButtons];
    
    selectedRow = -1;
    
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"WDRequest"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"location_name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:@"location_name" cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.userType = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_type"];
}


- (void) initNavigationButtons {
    self.navigationItem.leftBarButtonItem = [self navBarButtonWithTitle:@"Logout" selector:@selector(goBack)];
}


- (void) goBack {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"a_token"];
    [self dismissModalViewControllerAnimated:YES];
}


- (void) editStatusTappedFor:(WDRequest*) r {
    WDPickerVC* vc = [[WDPickerVC alloc] initWithNibName:@"WDPickerVC" bundle:nil];
    vc.elements = [WDRequest availableStatuses];
    vc.defaultElement = r.current_status;
    vc.delegate = self;
    self.currentPickerReuqest = r;
    [self presentModalViewController:vc animated:YES];
}


- (void) editDateTappedFor:(WDRequest*) r {
    
}


- (void) editQueueStatusTappedFor:(WDRequest*) r {
    
}


- (void) newElementPicked:(NSString*) newElement {
    self.currentPickerReuqest.current_status = newElement;
    
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSError* error = nil;
    [appDelegate.managedObjectContext save:&error];
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
