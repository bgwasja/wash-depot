//
//  WDReportsListVC.h
//  WashDepot
//
//  Created by Vova Musiienko on 17.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDReportsListVC : UIViewController

@property (nonatomic, strong) IBOutlet UITableView* reportsTable;
@property (nonatomic, strong) IBOutlet UIView* searchView;
@property (nonatomic, strong) IBOutlet UITextField* searchTextField;


@end
