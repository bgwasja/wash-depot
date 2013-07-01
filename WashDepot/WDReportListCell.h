//
//  WDReportListCell.h
//  WashDepot
//
//  Created by Vova Musiienko on 18.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDRequest;

@protocol WDReportListCellDelegate <NSObject>

- (void) editStatusTappedFor:(WDRequest*) r;
- (void) editDateTappedFor:(WDRequest*) r;
- (void) editQueueStatusTappedFor:(WDRequest*) r;
- (void) showPhotoTappedFor:(WDRequest*) r withPhotoNum:(int) photoNum;
- (void) checkboxTappedFor:(WDRequest*) r;

@end



@interface WDReportListCell : UITableViewCell

@property (nonatomic, weak) id<WDReportListCellDelegate> delegate;

@property (nonatomic, strong) IBOutlet UILabel* nameLabel;
@property (nonatomic, strong) IBOutlet UILabel* statusLabel;
@property (nonatomic, strong) IBOutlet UILabel* shortDescLabel;
@property (nonatomic, strong) IBOutlet UILabel* importanceLabel;
@property (nonatomic, strong) IBOutlet UILabel* shortDateLabel;

@property (nonatomic, strong) IBOutlet UIImageView* expandedBgImage;
@property (nonatomic, strong) IBOutlet UILabel* expandedStatusLabel;
@property (nonatomic, strong) IBOutlet UILabel* expandedDateLabel;
@property (nonatomic, strong) IBOutlet UILabel* expandedQueueStatusLabel;
@property (nonatomic, strong) IBOutlet UITextView* descTextView;
@property (nonatomic, strong) IBOutlet UIButton* photoButton1;
@property (nonatomic, strong) IBOutlet UIButton* photoButton2;
@property (nonatomic, strong) IBOutlet UIButton* photoButton3;

//editable

@property (nonatomic, strong) IBOutlet UIButton* checkboxButton;
@property (nonatomic, strong) IBOutlet UIButton* expandedStatusButton;
@property (nonatomic, strong) IBOutlet UIButton* expandedDateButton;
@property (nonatomic, strong) IBOutlet UIButton* expandedQueueStatusButton;

- (IBAction) expandedStatusButtonTapped;
- (IBAction) expandedDateButtonTapped;
- (IBAction) expandedQueueStatusButtonTapped;

- (IBAction) photoButtonTapped:(id)sender;
- (IBAction) checkboxButtonTapped:(id)sender;

@property (nonatomic, strong) WDRequest* request;

@end
