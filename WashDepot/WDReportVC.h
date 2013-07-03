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

enum WdCellType{
  WDCalendar=0,
  WDLocation,
  WDImportance,
  WDArea
    
};
@interface WDReportVC : UIViewController <UITextViewDelegate,WDCalendarCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *reportTable;
@property (strong, nonatomic) IBOutlet UIButton *logOutBut;
- (IBAction)logOutTapped:(id)sender;
-(void)closeRowAtIndexPath:(NSIndexPath*)indexPath;

@end
