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

@protocol WDChangeReportVCDelegate <NSObject>

- (void) editStatusTappedFor:(WDRequest*) r;
- (void) editDateTappedFor:(WDRequest*) r;
- (void) editQueueStatusTappedFor:(WDRequest*) r;
- (void) showPhotoTappedFor:(WDRequest*) r withPhotoNum:(int) photoNum;
//- (void) checkboxTappedFor:(WDRequest*) r;

@end

@interface WDChangeReportVC : UIViewController

@property (nonatomic, weak) id<WDChangeReportVCDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *dialogView;
@property (strong, nonatomic) IBOutlet UIButton *statusButton;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UIButton *completedButton;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *photo1Button;
@property (strong, nonatomic) IBOutlet UIButton *photo2Button;
@property (strong, nonatomic) IBOutlet UIButton *photo3Button;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *completedLabel;

- (IBAction)statusTapped:(id)sender;
- (IBAction)dateTapped:(id)sender;
- (IBAction)completedTapped:(id)sender;

- (IBAction)photoTapped:(id)sender;


@property (nonatomic, strong) WDRequest* request;
@property(strong,nonatomic)WDReportsListVC *reportListVC;

+ (WDChangeReportVC*) sharedChangeReportVC;
- (void) showInView:(UIView*) v;
- (void) updateData ;

@end
