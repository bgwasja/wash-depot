//
//  WDPopoverContentVC.h
//  WashDepot
//
//  Created by Balazh Vasyl on 7/3/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDReportsListVC.h"

@interface WDPopoverContentVC : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *contentTable;
@property (retain, nonatomic) WDReportsListVC * reportList;

@end
