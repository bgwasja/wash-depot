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
    
    descriptionTextView.layer.cornerRadius = 10;
    descriptionTextView.text = @"   Brief Description of Problem";
    descriptionTextView.textColor = [UIColor lightGrayColor];
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow.png"]];
    iv.frame = CGRectMake(0, 0, self.descriptionTextView.frame.size.width, 8);
    [self.descriptionTextView addSubview:iv];
}


@end
