//
//  WDReportCell.m
//  WashDepot
//
//  Created by Balazh Vasyl on 6/13/13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDReportCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation WDReportCell

@synthesize textLabel, imageCell, isOpen, descriptionTextView;

- (void) setOpen
{
    [self setIsOpen:YES];
}

- (void) setClosed
{
    [self setIsOpen:NO];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void) awakeFromNib {
    [super awakeFromNib];
    UIImage *bg = [[UIImage imageNamed:@"header_list_act.png"]
                   resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 200)];
    [[self imageCell] setImage:bg];
    
//    UIImage *bg_description = [[UIImage imageNamed:@"text_input.png"]
//                   resizableImageWithCapInsets:UIEdgeInsetsMake(110, 1, 12340, 20)];
//    descriptionTextView.backgroundColor = [UIColor colorWithPatternImage:bg_description];
    descriptionTextView.layer.cornerRadius = 10;
    descriptionTextView.text = @"   Brief Description of Problem";
    descriptionTextView.textColor = [UIColor lightGrayColor];
}


@end
