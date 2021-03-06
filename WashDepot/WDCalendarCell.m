//
//  WDCalendarCell.m
//  WashDepot
//
//  Created by Balazh Vasyl on 6/18/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDCalendarCell.h"
#import "WDReportVC.h"

@implementation WDCalendarCell
@synthesize isOpen;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setOpen
{
    [self setIsOpen:YES];
}

- (void) setClosed
{
    [self setIsOpen:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [self createCalendar];
}


-(void) createCalendar
{
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd-MM-yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"18-07-2012"];
    
    self.disabledDates = @[];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(0, 10, 300, 215);
    calendar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self.contentView addSubview:calendar];
    self.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}

- (void) resetToToday {
    [self.calendar selectDate:[NSDate date] makeVisible:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}


- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
        dateItem.backgroundColor = [UIColor colorWithRed:242.0f/256 green:242.0f/256 blue:242.0f/256 alpha:1.0];
        dateItem.textColor = [UIColor colorWithRed:100.0f/256 green:108.0f/256 blue:256.0f/256 alpha:1.0];
    }
}


- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}


- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    [self.delegate closeRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:WDCalendar]];
    [self.delegate setNewRequestDate:date];
    
}


- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor colorWithRed:242.0f/256 green:242.0f/256 blue:242.0f/256 alpha:1.0];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor colorWithRed:242.0f/256 green:242.0f/256 blue:242.0f/256 alpha:1.0];
        return NO;
    }
}


- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}


@end
