//
//  WDChangeReportVC.m
//  WashDepot
//
//  Created by Balazh Vasyl on 7/2/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDChangeReportVC.h"
#import <QuartzCore/QuartzCore.h>
#import "WDRequest.h"
#import "WDReportsListVC.h"

@interface WDChangeReportVC ()

@end

@implementation WDChangeReportVC
@synthesize dialogView, statusButton, dateButton, completedButton, descriptionTextView, photo1Button, photo2Button, photo3Button, request;

- (void) updateData {
    descriptionTextView.text = request.desc;

    int userType = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_type"]intValue];
    if(userType == 2){
        [statusButton setTitle:[NSString stringWithFormat:@"%@", request.current_status] forState:UIControlStateNormal];
        [dateButton setTitle:[request lastReviewString] forState:UIControlStateNormal];
        [completedButton setTitle:[request completedString] forState:UIControlStateNormal];
    }else{
        _statusLabel.text = [NSString stringWithFormat:@"%@", request.current_status];
        _dateLabel.text = [request lastReviewString];
        _completedLabel.text = [request completedString];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"request = %@",request);
    dialogView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    dialogView.layer.cornerRadius = 20;
    
//    [statusButton setTitle:[NSString stringWithFormat:@"%@", request.current_status ]forState:UIControlStateNormal];
//    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yy/MM/dd"];
//    NSString* dateStr = [dateFormat stringFromDate:request.date];
//    [dateButton setTitle:dateStr forState:UIControlStateNormal];
//    [completedButton setTitle:[request completedString] forState:UIControlStateNormal];
    int userType = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_type"]intValue];
    if(userType == 1){
        
        [statusButton removeFromSuperview];
        [dateButton removeFromSuperview];
        [completedButton removeFromSuperview];
        descriptionTextView.editable = FALSE;
    
    }else{
        [_statusLabel removeFromSuperview];
        [_dateLabel removeFromSuperview];
        [_completedLabel removeFromSuperview];
    }
    
    descriptionTextView.layer.cornerRadius = 10;
    descriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    descriptionTextView.layer.borderWidth = 1.0f;
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow.png"]];
    iv.frame = CGRectMake(0, 0, descriptionTextView.frame.size.width, 8);
    [descriptionTextView addSubview:iv];
    
    UIImage *buttonBackground = [[UIImage imageNamed:@"but_grey_small"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 32, 0, 23)];
    [photo1Button setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [photo2Button setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [photo3Button setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    
    UIImage *bg = [[UIImage imageNamed:@"header_list_act.png"]
                   resizableImageWithCapInsets:UIEdgeInsetsMake(0, 36, 36, 200)];
    [statusButton setBackgroundImage:bg forState:UIControlStateNormal];
    [dateButton setBackgroundImage:bg forState:UIControlStateNormal];
    [completedButton setBackgroundImage:bg forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
//     NSManagedObject *managedObject = [self.reportListVC.fetchedResultsController objectAtIndexPath:[nsi]];
//    self.request.m
//    self.request = self.reportListVC.fetchedResultsController o
    [self updateData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setDialogView:nil];
    [self setStatusButton:nil];
    [self setDateButton:nil];
    [self setCompletedButton:nil];
    [self setDescriptionTextView:nil];
    [self setPhoto1Button:nil];
    [self setPhoto2Button:nil];
    [self setPhoto3Button:nil];
    [self setStatusLabel:nil];
    [self setDateLabel:nil];
    [self setCompletedLabel:nil];
    [super viewDidUnload];
}


- (IBAction)statusTapped:(id)sender {
    [self.delegate editStatusTappedFor:self.request];
}

- (IBAction)dateTapped:(id)sender {
    [self.delegate editDateTappedFor:self.request];
}

- (IBAction)completedTapped:(id)sender {
    [self.delegate editQueueStatusTappedFor:self.request];
}


- (IBAction)photoTapped:(id)sender {
    int photoNum = ((UIButton*)sender).tag;
    [self.delegate showPhotoTappedFor:self.request withPhotoNum:photoNum];
}


+ (WDChangeReportVC*) sharedChangeReportVC {
    static WDChangeReportVC* instance = nil;
    if (instance == nil) {
        instance = [[WDChangeReportVC alloc] initWithNibName:@"WDChangeReportVC" bundle:nil];
    }
    return instance;
}


- (void) showInView:(UIView*) v{
    if (self.view.superview != nil) {
        @throw [NSException exceptionWithName:@"sharedChangeReportVC" reason:@"ChangeReport view already showed!" userInfo:nil];
    }
    [v addSubview:self.view];
}


@end
