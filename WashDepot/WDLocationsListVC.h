//
//  WDLacationsListVC.h
//  WashDepot
//
//  Created by Balazh Vasyl on 7/1/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDLocationsListVC : UIViewController


+ (WDLocationsListVC*) sharedLocationsVC;
- (void) showInView:(UIView*) v;

@end
