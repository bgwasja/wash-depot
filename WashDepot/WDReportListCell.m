//
//  WDReportListCell.m
//  WashDepot
//
//  Created by Vova Musiienko on 18.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import "WDReportListCell.h"
#import "WDRequest.h"
#import <QuartzCore/QuartzCore.h>

@implementation WDReportListCell

@synthesize request;

- (void) updateCell {
    self.statusLabel.text = [NSString stringWithFormat:@"Status: %@", request.current_status];
    [self.expandedStatusButton setTitle:[NSString stringWithFormat:@"%@", request.current_status] forState:UIControlStateNormal];
    self.shortDescLabel.text = request.problem_area;
    self.importanceLabel.text = request.priorityString;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yy/MM/dd"];
    NSString* dateStr = [dateFormat stringFromDate:request.date];
    self.shortDateLabel.text = dateStr;
    self.expandedDateLabel.text = dateStr;
    [self.expandedDateButton setTitle:dateStr forState:UIControlStateNormal];
    
    self.descTextView.text = request.desc;
    [self.expandedQueueStatusButton setTitle:@"Pending" forState:UIControlStateNormal];

}


- (IBAction) expandedStatusButtonTapped {
    [self.delegate editStatusTappedFor:self.request];
}


- (IBAction) expandedDateButtonTapped {
    [self.delegate editDateTappedFor:self.request];

}


- (IBAction) expandedQueueStatusButtonTapped {
    [self.delegate editQueueStatusTappedFor:self.request];
}


- (IBAction) photoButtonTapped:(id)sender {
    [self.delegate showPhotoTappedFor:self.request withPhotoNum:((UIButton*)sender).tag];
}


- (void) setRequest:(WDRequest *)_request {
    request = _request;
    [self updateCell];
}


- (void) awakeFromNib {
    [super awakeFromNib];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.expandedBgImage.backgroundColor = background;
    
    self.descTextView.layer.cornerRadius = 10;
    self.descTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.descTextView.layer.borderWidth = 1.0f;

    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow.png"]];
    iv.frame = CGRectMake(0, 0, self.descTextView.frame.size.width, 8);
    [self.descTextView addSubview:iv];
    
    UIImage *buttonBackground = [[UIImage imageNamed:@"but_grey_small"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 32, 0, 23)];
    [self.photoButton1 setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [self.photoButton2 setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [self.photoButton3 setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    
    
    UIImage *bg = [[UIImage imageNamed:@"header_list_act.png"]
                   resizableImageWithCapInsets:UIEdgeInsetsMake(0, 36, 36, 200)];

    [self.expandedStatusButton setBackgroundImage:bg forState:UIControlStateNormal];
    [self.expandedDateButton setBackgroundImage:bg forState:UIControlStateNormal];
    [self.expandedQueueStatusButton setBackgroundImage:bg forState:UIControlStateNormal];

    [self updateCell];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
