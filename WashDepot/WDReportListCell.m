//
//  WDReportListCell.m
//  WashDepot
//
//  Created by Vova Musiienko on 18.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDReportListCell.h"
#import "WDRequest.h"

@implementation WDReportListCell

@synthesize request;

- (void) updateCell {
    self.statusLabel.text = [NSString stringWithFormat:@"Status: %@", request.current_status];
    self.shortDescLabel.text = request.problem_area;
    self.importanceLabel.text = request.priorityString;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yy/MM/dd"];
    NSString* dateStr = [dateFormat stringFromDate:request.date];
    self.shortDateLabel.text = dateStr;
}


- (void) setRequest:(WDRequest *)_request {
    request = _request;
    [self updateCell];
}


- (void) awakeFromNib {
    [super awakeFromNib];
    [self updateCell];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
