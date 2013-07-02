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

- (void) updateCell {
    [statusButton setTitle:[NSString stringWithFormat:@"%@", request.current_status] forState:UIControlStateNormal];
    [dateButton setTitle:[request lastReviewString] forState:UIControlStateNormal];
    descriptionTextView.text = request.desc;
    [statusButton setTitle:[request completedString] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dialogView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    dialogView.layer.cornerRadius = 10;
    
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
    [super viewDidUnload];
}
- (IBAction)statusTapped:(id)sender {
    //[self.reportListVC editStatusTappedFor:<#(WDRequest *)#>]
}

- (IBAction)dateTapped:(id)sender {
}

- (IBAction)completedTapped:(id)sender {
}


- (IBAction)photo1Tapped:(id)sender {
}

- (IBAction)photo2Tapped:(id)sender {
}

- (IBAction)photo3Tapped:(id)sender {
}

+ (WDChangeReportVC*) sharedChangeReportVC {
    static WDChangeReportVC* instance = nil;
    if (instance == nil) {
        instance = [[WDChangeReportVC alloc] initWithNibName:@"WDChangeReportVC" bundle:nil];
    }
    return instance;
}


- (void) showInView:(UIView*) v{
//    if (v.superview != nil) {
//        @throw [NSException exceptionWithName:@"sharedChangeReportVC" reason:@"Loading view already showed!" userInfo:nil];
    //}
    [v addSubview:self.view];
}

@end
