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
@interface WDReportPhotosVC : UIViewController<UIScrollViewDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>




@property(nonatomic,retain) NSMutableArray *imageArray;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet StyledPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *processButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)processTapped;
- (IBAction)deleteTapped;
@end
