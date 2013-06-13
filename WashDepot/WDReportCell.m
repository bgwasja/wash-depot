//
//  WDReportCell.m
//  WashDepot
//
//  Created by Balazh Vasyl on 6/13/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDReportCell.h"

@implementation WDReportCell

@synthesize textLabel, arrow_up, isOpen;

- (void) setOpen
{
    [arrow_up setHidden:NO];
    [self setIsOpen:YES];
}

- (void) setClosed
{
    [arrow_up setHidden:YES];
    [self setIsOpen:NO];
}

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

@end
