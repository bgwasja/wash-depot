//
//  WDReportCell.h
//  WashDepot
//
//  Created by Balazh Vasyl on 6/13/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDReportCell : UITableViewCell
{
IBOutlet UILabel *textLabel;
IBOutlet UIImageView *arrow_up;

BOOL isOpen;

}

- (void) setOpen;
- (void) setClosed;

@property (nonatomic) BOOL isOpen;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UIImageView *arrow_up;

@end
