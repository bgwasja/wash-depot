//
//  WDRegularVCiPad.h
//  WashDepot
//
//  Created by Eugene on 16.07.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDReportVC;
@class WDReportPhotosVC;

@interface WDRegularVCiPad : UIViewController
@property (strong, nonatomic) IBOutlet UIView *leftContainerView;
@property (strong, nonatomic) IBOutlet UIView *rightContainerView;
@property (strong, nonatomic, readwrite)  WDReportVC *reportVC;
@property (strong, nonatomic, readwrite) WDReportPhotosVC *reportPhotoVC;

@end
