//
//  WDReportPhotosVC.h
//  WashDepot
//
//  Created by Eugene on 18.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WD_NUMBER_OF_PHOTOVIEWS 3
@class WDPageControl;
@interface WDReportPhotosVC : UIViewController<UIScrollViewDelegate,UIImagePickerControllerDelegate>




@property(nonatomic,retain) NSMutableArray *viewArray;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet WDPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *processButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)processTapped;
- (IBAction)deleteTapped;
@end
