//
//  WDReportListCell.h
//  WashDepot
//
//  Created by Vova Musiienko on 18.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDRequest;

@interface WDReportListCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* nameLabel;
@property (nonatomic, strong) IBOutlet UILabel* statusLabel;
@property (nonatomic, strong) IBOutlet UILabel* shortDescLabel;
@property (nonatomic, strong) IBOutlet UILabel* importanceLabel;
@property (nonatomic, strong) IBOutlet UILabel* shortDateLabel;

@property (nonatomic, strong) WDRequest* request;

@end
