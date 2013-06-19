//
//  WDReportVC.h
//  WashDepot
//
//  Created by Balazh Vasyl on 6/13/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDReportCell.h"
#import "WDCalendarCell.h"

@interface WDReportVC : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *reportTable;

@end
