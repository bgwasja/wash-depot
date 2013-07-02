//
//  WDReportsListVC.h
//  WashDepot
//
//  Created by Vova Musiienko on 17.06.13.
//  Copyright (c) 2013 SWAN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDRequest;
@interface WDReportsListVC : UIViewController

@property (nonatomic, strong) IBOutlet UITableView* reportsTable;
@property (nonatomic, strong) IBOutlet UIView* searchView;
@property (nonatomic, strong) IBOutlet UITextField* searchTextField;
@property (strong, nonatomic) IBOutlet UIView *locationsListView;
@property (nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
- (IBAction)logoutTapped:(id)sender;
- (void) editStatusTappedFor:(WDRequest*)r ;
@end
