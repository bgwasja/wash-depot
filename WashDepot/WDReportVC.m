//
//  WDReportVC.m
//  WashDepot
//
//  Created by Balazh Vasyl on 6/13/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDReportVC.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+Utils.h"
#import "WDRequest.h"
#import "WDAppDelegate.h"
#import "WDReportPhotosVC.h"

@interface WDDropBoxState : NSObject
{
}

@property (strong, nonatomic) NSString* caption;
@property (strong, nonatomic) NSNumber* isOpen;
@property (strong, nonatomic) NSNumber* currentSelection;
@property (strong, nonatomic) NSArray* optionsNames;

- (id) initWithCaption:(NSString*)c optionsNames:(NSArray*)on;

@end

@implementation WDDropBoxState

- (id) initWithCaption:(NSString*)c optionsNames:(NSArray*)on {
    if (self = [super init]) {
        self.caption = c;
        self.optionsNames = on;
        self.isOpen = @NO;
        self.currentSelection = @0;
    }
    return self;
}

@end



@interface WDReportVC ()

@property (strong, nonatomic) NSMutableArray* dropBoxes;
@property (strong, nonatomic) WDRequest* createdRequest;

@end

@implementation WDReportVC

@synthesize reportTable;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavigationButtons];
    
    self.dropBoxes = [NSMutableArray new];
    
    [self.dropBoxes addObject:[[WDDropBoxState alloc] initWithCaption:@"Select Date" optionsNames:[NSArray arrayWithObjects:@"  Calendar", nil]]];

    [self.dropBoxes addObject:[[WDDropBoxState alloc] initWithCaption:@"Select Location" optionsNames:[NSArray arrayWithObjects:@"Location 001",@"Location 002",@"Location 003",@"Location 004",@"Location 005",@"Location 006",@"Location 007", nil]]];
    
    [self.dropBoxes addObject:[[WDDropBoxState alloc] initWithCaption:@"Importance" optionsNames:[NSArray arrayWithObjects:@"Low",@"Normal",@"Urgent", nil]]];
    
    [self.dropBoxes addObject:[[WDDropBoxState alloc] initWithCaption:@"Problem Area" optionsNames:[NSArray arrayWithObjects:@"Problem Area 1",@"Problem Area 2",@"Problem Area 3", @"Problem Area 4",nil]]];
    
    UIImage *bgImage = [[UIImage imageNamed:@"bg.png"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    [self.reportTable setSeparatorColor:[UIColor clearColor]];
    
    
    WDAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    self.createdRequest = (WDRequest*)[[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"WDRequest" inManagedObjectContext:appDelegate.managedObjectContext] insertIntoManagedObjectContext:appDelegate.managedObjectContext];
    self.createdRequest.date = [NSDate date];
    self.createdRequest.location_name = @"Location 001";
    self.createdRequest.priority = @1;
    self.createdRequest.problem_area = @"Problem Area 1";
    self.createdRequest.desc = @"";
    self.createdRequest.current_status = @"Queued";
    
    UIImage *logoutBackground = [[UIImage imageNamed:@"but_blue"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
    [_logOutBut setBackgroundImage:logoutBackground forState:UIControlStateNormal];
    
    UIImage *logoutBackgroundAct = [[UIImage imageNamed:@"but_blue_act"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(22, 12, 22, 12)];
    [_logOutBut setBackgroundImage:logoutBackgroundAct forState:UIControlStateHighlighted];
    
    
}


- (void) initNavigationButtons {
    self.navigationItem.rightBarButtonItem = [self navBarButtonWithTitle:@"Next" selector:@selector(goNext)];
    self.navigationItem.leftBarButtonItem = [self navBarButtonWithTitle:@"Logout" selector:@selector(goBack)];
}


- (void) goBack {
    [self userLogout];
    [self dismissModalViewControllerAnimated:YES];
}


- (void) goNext {
    [self performSegueWithIdentifier:@"image_view" sender:self];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(USING_IPAD){
        CALayer *leftBorder = [CALayer layer];
        leftBorder.borderColor = [UIColor whiteColor].CGColor;
        leftBorder.borderWidth = .6;
        leftBorder.frame = CGRectMake(-1, 0, self.view.frame.size.width+2, self.view.frame.size.height);
        
        [self.view.layer addSublayer:leftBorder];
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"image_view"]) {
        ((WDReportPhotosVC*)segue.destinationViewController).createdRequest = self.createdRequest;
    }
}


// Customize the number of sections in the table view.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section < 4) {
        WDDropBoxState* s = [self.dropBoxes objectAtIndex:section];
        if ([s.isOpen boolValue]) {
            return [s.optionsNames count] +1;
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int height = 30;
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 250.0f;
    }
    
    if(indexPath.section < 4){
        height = 30;
    }else if (indexPath.section == 4){
        height = 175;
    } else {
        height = 30;
    }
    return height;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"wd_report_cell";
    static NSString *OpenCellIdentifier = @"wd_option_cell";
    static NSString *DropDownCellIdentifier = @"wd_report_note_cell";
    static NSString *CalendarCellIdentifier = @"wd_calendar_cell";
    
    if(indexPath.section < 4) {
        WDDropBoxState* dropBox = self.dropBoxes[indexPath.section];
        switch ([indexPath row]) {
            case 0: {
                WDReportCell *cell = (WDReportCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                NSString* currentSelectionText = dropBox.optionsNames[[dropBox.currentSelection intValue]];
                [[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@", dropBox.caption, currentSelectionText]];
                return cell;
            }
            default: {
                UITableViewCell *cell = nil;
                if (indexPath.section == 0) {
                    cell = [tableView dequeueReusableCellWithIdentifier:CalendarCellIdentifier];
                } else {
                    cell = [tableView dequeueReusableCellWithIdentifier:OpenCellIdentifier];
                    NSString *label = [NSString stringWithFormat:@"  %@", dropBox.optionsNames[indexPath.row-1]];
                    [[cell textLabel] setText:label];
                }
                return cell;
            }
        }
    } else {
        WDReportCell *cell = (WDReportCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
        return cell;
    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        return nil;
    }
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDReportCell *cell = (WDReportCell*) [tableView cellForRowAtIndexPath:indexPath];
    WDDropBoxState* dropBox = self.dropBoxes[indexPath.section];
    
    switch ([indexPath row]) {
        case 0:{
            NSMutableArray *indexPathArray = [NSMutableArray new];
            
            dropBox.isOpen = @(![dropBox.isOpen boolValue]);

            for (int i = 0; i < [dropBox.optionsNames count]; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:[indexPath row]+i+1 inSection:[indexPath section]];
                [indexPathArray addObject:path];
            }

            if (![dropBox.isOpen boolValue]) {
                [cell setClosed];
                [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            } else {
                [cell setOpen];
                [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            }
            break;
        }
        default: {
            dropBox.currentSelection = @(indexPath.row - 1);
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:[indexPath section]];
            [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
            [self setNewValueForState:dropBox andIndexPath:indexPath];
            break;
        }
    }
            
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void) setNewValueForState:(WDDropBoxState*)state andIndexPath:(NSIndexPath*)indexPath {
    NSString* newValue = state.optionsNames[indexPath.row-1];
    
    if ([state.caption isEqualToString:@"Select Location"]) {
        self.createdRequest.location_name = newValue;
    } else
        if ([state.caption isEqualToString:@"Importance"]) {
            self.createdRequest.priority = @(indexPath.row-1);
        } else
            if ([state.caption isEqualToString:@"Problem Area"]) {
                self.createdRequest.problem_area = newValue;
            }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return USING_IPAD?25:15;
        default:
            
            return USING_IPAD?20:10;
            break;
    }
}


#pragma mark -
#pragma mark UITextViewDelegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        self.createdRequest.desc = textView.text;
    }
    return YES;
}


-(void) textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3f animations:^(void){
        CGRect screenRect = self.reportTable.frame;
        screenRect.size.height = USING_IPAD?318:190;
        [self.reportTable setFrame:screenRect];
    }];
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
    [reportTable scrollToRowAtIndexPath:indexPath
                       atScrollPosition:UITableViewScrollPositionBottom
                               animated:YES];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{    
    [UIView animateWithDuration:0.3f animations:^(void){
        CGRect screenRect = self.reportTable.frame;
        CGRect fullScreenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = fullScreenRect.size.height;
        screenRect.size.height = screenHeight;
        [self.reportTable setFrame:screenRect];
    }];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload
{
    [self setReportTable:nil];
    [self setLogOutBut:nil];
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (IBAction)logOutTapped:(id)sender {
    [self goBack];
}
@end
