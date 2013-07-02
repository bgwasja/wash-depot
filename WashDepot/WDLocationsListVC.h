//
//  WDLacationsListVC.h
//  WashDepot
//
//  Created by Balazh Vasyl on 7/1/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDReportsListVC;


@interface WDLocationsListVC : UIViewController

@property(strong,nonatomic)WDReportsListVC *reportListVC;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

+ (WDLocationsListVC*) sharedLocationsVC;
- (void) showInView:(UIView*) v;

@end
