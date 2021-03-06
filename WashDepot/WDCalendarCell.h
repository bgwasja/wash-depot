//
//  WDCalendarCell.h
//  WashDepot
//
//  Created by Balazh Vasyl on 6/18/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"
#import <CoreGraphics/CoreGraphics.h>

@protocol WDCalendarCellDelegate <NSObject>

-(void)closeRowAtIndexPath:(NSIndexPath*)indexPath;
-(void)setNewRequestDate:(NSDate*)_date;

@end

@interface WDCalendarCell : UITableViewCell <CKCalendarDelegate>{
    BOOL isOpen;
}
@property (nonatomic, weak) id<WDCalendarCellDelegate> delegate;
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *setTextLabel;
@property (nonatomic) BOOL isOpen;

-(void) setOpen;
-(void) setClosed;
-(void) createCalendar;

- (void) resetToToday;

@end
