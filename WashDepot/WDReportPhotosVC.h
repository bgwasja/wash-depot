//
//  WDReportPhotosVC.h
//  WashDepot
//
//  Created by Eugene on 18.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledPageControl.h"
#define WD_NUMBER_OF_PHOTOVIEWS 3
#define WD_SDRT_PHOTO_SIZE (USING_IPAD ? CGSizeMake(230,290):CGSizeMake(244,316))
@class WDRequest;

@interface WDReportPhotosVC : UIViewController<UIScrollViewDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) WDRequest* createdRequest;

@property(nonatomic,retain) NSMutableArray *imageArray;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet StyledPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *processButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIImageView *tappedView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
- (IBAction)backPressed;
- (IBAction)processTapped;
- (IBAction)deleteTapped;
@end
