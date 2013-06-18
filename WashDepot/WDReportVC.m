//
//  WDReportVC.m
//  WashDepot
//
//  Created by Balazh Vasyl on 6/13/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDReportVC.h"
#import <QuartzCore/QuartzCore.h>

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

@end

@implementation WDReportVC

@synthesize reportTable;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dropBoxes = [NSMutableArray new];
    
    [self.dropBoxes addObject:[[WDDropBoxState alloc] initWithCaption:@"Select Date" optionsNames:[NSArray arrayWithObjects:@"  Calendar", nil]]];

    [self.dropBoxes addObject:[[WDDropBoxState alloc] initWithCaption:@"Select Location" optionsNames:[NSArray arrayWithObjects:@"Location 001",@"Location 002",@"Location 003",@"Location 004",@"Location 005",@"Location 006",@"Location 007", nil]]];
    
    [self.dropBoxes addObject:[[WDDropBoxState alloc] initWithCaption:@"Importance" optionsNames:[NSArray arrayWithObjects:@"Low",@"Normal",@"Urgent", nil]]];
    
    [self.dropBoxes addObject:[[WDDropBoxState alloc] initWithCaption:@"Problem Area" optionsNames:[NSArray arrayWithObjects:@"1",@"2",@"3", nil]]];
    
    UIImage *bgImage = [[UIImage imageNamed:@"bg.png"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    [self.reportTable setSeparatorColor:[UIColor clearColor]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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


// Customize the number of sections in the table view.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < 4) {
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
    if(indexPath.section < 4){
        height = 30;
    }else{
        height = 175;
    }
    return height;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"wd_report_cell";
    static NSString *OpenCellIdentifier = @"wd_option_cell";
    static NSString *DropDownCellIdentifier = @"wd_report_note_cell";
    
    if (indexPath.section < 4) {
        WDDropBoxState* dropBox = self.dropBoxes[indexPath.section];
        switch ([indexPath row]) {
            case 0: {
                WDReportCell *cell = (WDReportCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                NSString* currentSelectionText = dropBox.optionsNames[[dropBox.currentSelection intValue]];
                [[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@", dropBox.caption, currentSelectionText]];
                return cell;
            }
            default: {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OpenCellIdentifier];
                NSString *label = [NSString stringWithFormat:@"  %@", dropBox.optionsNames[indexPath.row-1]];
                [[cell textLabel] setText:label];
                return cell;
            }
        }
    } else {
        WDReportCell *cell = (WDReportCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
        return cell;
    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 3) {
        return nil;
    }
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDReportCell *cell = (WDReportCell*) [tableView cellForRowAtIndexPath:indexPath];
    WDDropBoxState* dropBox = self.dropBoxes[indexPath.section];
    
    
    switch ([indexPath row]) {
        case 0: {
            NSMutableArray *indexPathArray = [NSMutableArray new];
            
            dropBox.isOpen = @(![cell isOpen]);

            for (int i = 0; i < [dropBox.optionsNames count]; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:[indexPath row]+i+1 inSection:[indexPath section]];
                [indexPathArray addObject:path];
            }

            if ([cell isOpen]) {
                [cell setClosed];
                [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            } else {
                [cell setOpen];
                [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            }
            break;
        }
        default:
        {
            dropBox.currentSelection = @(indexPath.row - 1);
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:[indexPath section]];
            [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
            }
            
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 15;
        case 1:
        case 2:
        case 3:
        case 4:
        default:
            return 10;
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
    }
    return YES;
}


-(void) textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3f animations:^(void){
        CGRect screenRect = self.reportTable.frame;
        screenRect.size.height = 190;
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
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

@end
