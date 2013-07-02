//
//  WDChangeReportVC.h
//  WashDepot
//
//  Created by Balazh Vasyl on 7/2/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDRequest;
@class WDReportsListVC;

@interface WDChangeReportVC : UIViewController

@property (strong, nonatomic) IBOutlet UIView *dialogView;
@property (strong, nonatomic) IBOutlet UIButton *statusButton;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UIButton *completedButton;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *photo1Button;
@property (strong, nonatomic) IBOutlet UIButton *photo2Button;
@property (strong, nonatomic) IBOutlet UIButton *photo3Button;

- (IBAction)statusTapped:(id)sender;
- (IBAction)dateTapped:(id)sender;
- (IBAction)completedTapped:(id)sender;

- (IBAction)photo1Tapped:(id)sender;
- (IBAction)photo2Tapped:(id)sender;
- (IBAction)photo3Tapped:(id)sender;

@property (nonatomic, strong) WDRequest* request;
@property(strong,nonatomic)WDReportsListVC *reportListVC;

+ (WDChangeReportVC*) sharedChangeReportVC;
- (void) showInView:(UIView*) v;


@end
